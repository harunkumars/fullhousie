class ActiveAdminReportJob < ApplicationJob
  attr_reader :resource, :current_admin_user, :report_run

  before_enqueue do |job|
    report_id, admin_user_id = arguments
    report_run = ActiveAdminReportRun.create!(
      active_admin_report_id: report_id,
      admin_user_id: admin_user_id,
      run_status: :pending,
      job_reference: [:async, job.job_id].join('-')
    )
    job.arguments = job.arguments.insert(2, report_run.id) #use insert since report_run_id is a positional argument
  end

  def self.perform_live(*args, **kwargs, &block)
    new.perform(*args, **kwargs.merge(mode: :live), &block)
  end

  def perform(id, current_admin_user_id, report_run_id = nil, input: nil, mode: :async) # a block may be passed which is yielded with arguments from any #puts call
    @resource = ActiveAdminReport.find(id)
    @current_admin_user = AdminUser.find(current_admin_user_id)
    if report_run_id
      @report_run = resource.active_admin_report_runs.find(report_run_id)
    else
      @report_run = resource.active_admin_report_runs.build(
        admin_user: current_admin_user,
        job_reference: [mode, job_id].join('-')
      )
    end
    @report_run.update!(run_status: :running)

    custom_puts = proc do |arg|
      yield arg if block_given?
      report_run.log << "#{arg}\n"
    end

    custom_puts["R E P O R T   R U N   S T A R T E D: \n"]
    custom_puts["Performing #{mode.to_s.humanize} - #{job_id}"]
    custom_puts["(Output from #puts invocations, if any, will be logged here:)\n"]
    custom_puts["-------------------------------------------------------------\n"]

    mod = Module.new do
      define_method :puts do |*args|
        args.each{ |arg| custom_puts[arg] }
        nil
      end
    end

    klass = resource.define_singleton_class_for_script
    klass.extend(mod)

    klass_instance = klass.new(input)
    klass_instance.extend(mod)
    # ActiveRecord::Base.connected_to(role: :reading) do
    raise SyntaxError, 'The provided script should implement a #perform method' unless klass_instance.respond_to?(:perform)
    raise SyntaxError, 'The provided script should implement a #output method' unless klass_instance.respond_to?(:output)

    result = klass_instance.perform
    @out = ">>>> The Script returned: #{result}" if result

    [klass_instance.output].flatten.each do |out|
      report_run.reports.attach io: File.open(out), filename: File.basename(out)
    end

  rescue SyntaxError, StandardError => e
    run_status = :failed
    handle_error(e)
  else
    run_status = :completed
  ensure
    custom_puts["-------------------------------------------------------------\n"]
    custom_puts["#{@out}\n"]
    custom_puts["R E P O R T   R U N   E N D E D. \nYou may now close the tab.\n"]
    # update at the end as we accumulate custom_puts output in the log attribute
    report_run.update!(run_status: run_status, ran_at: Time.current)
  end

  private

  def handle_error(e)
    report_run.update!(run_status: :failed, ran_at: Time.current)
    case e
    when SyntaxError
      @out = "The provided Ruby Script contains a syntax error: #{e.inspect}. Kindly fix and retry."
    else
      @out = "The Script failed: #{e.inspect}"
    end
    @out = "#{@out} \n\n
###############################################
 B A C K T R A C E
###############################################\n\n
    #{e.backtrace.join("\n")}"
  end

end
