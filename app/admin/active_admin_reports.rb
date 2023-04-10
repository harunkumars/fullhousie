ActiveAdmin.register ActiveAdminReport do

  permit_params :name, :description, :ruby_script

  form do |f|
    script src: '//cdnjs.cloudflare.com/ajax/libs/ace/1.15.2/ace.min.js'
    script src: '//cdnjs.cloudflare.com/ajax/libs/ace/1.15.2/mode-html_ruby.min.js'
    script src: '//cdnjs.cloudflare.com/ajax/libs/ace/1.15.2/theme-monokai.min.js'
    script render partial: 'admin/active_admin_reports/edit_with_ace', formats: [:js]
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :name
      f.input :description, input_html: { rows: 5 }
      f.input :ruby_script, input_html: { rows: 20, data: { editor: 'ruby'}}
      f.actions
    end
  end

  action_item :execute, only: :show_code do
    dropdown_menu 'Execute Options' do
      item 'Execute Now', execute_now_admin_active_admin_report_path(resource)
      item 'Execute Later', execute_later_admin_active_admin_report_path(resource)
    end
  end

  action_item :edit, only: :show_code do
    link_to 'Edit Code', edit_admin_active_admin_report_path(resource)
  end

  member_action :execute_later, method: %i[get post] do
    @form_url = execute_later_admin_active_admin_report_path(@resource)
    if request.post?
      # if invalid.. we are good as long as there were no errors on the form fields
      if @object.valid? || (@object.errors.attribute_names & @object.form_fields_for_input.keys).empty?
        job = ActiveAdminReportJob.perform_later(resource.id, current_admin_user.id, input: @input)
        redirect_to resource_path, notice: "Submitted #{job.job_id}"
      else
        render_form #form with errors
      end
    else
      render_form #new form
    end
  end

  member_action :execute_now, method: %i[get post] do
    @form_url = execute_now_admin_active_admin_report_path(@resource)
    if request.post?
      # if invalid.. we are good as long as there were no errors on the form fields
      if @object.valid? || (@object.errors.attribute_names & @object.form_fields_for_input.keys).empty?
        begin
          response.headers['Content-Type'] = 'text/event-stream'
          response.headers['Last-Modified'] = Time.now.httpdate
          ActiveAdminReportJob.perform_live(resource.id, current_admin_user.id, input: @input) do |arg|
            response.stream.write "#{arg}\n"
          end
        ensure
          response.stream.close
        end
      else
        render_form #form with errors
      end
    else
     render_form #new form
    end
  end

  index do
    id_column
    column :name
    column :description
    column :created_at
    column :updated_at
    actions(default: true) do |resource|
      item 'Code', show_code_admin_active_admin_report_path(resource)
    end
  end

  member_action :show_code, method: :get do
    render type: :arb,
           layout: 'active_admin',
           inline: <<-TEMPLATE
    pre do
      code(class: 'language-ruby') do
        resource.ruby_script
      end
    end
    link rel: :stylesheet,
         href: '//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/default.min.css'
    script src: '//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js'
    script render partial: 'admin/active_admin_reports/highlight_code', formats: [:js]
    TEMPLATE
  end
  sidebar('Info', only: :show_code) do
    attributes_table do
      rows :name, :description, :created_at, :updated_at
    end
  end

  controller do
    include ActionController::Live

    before_action :set_resource_for_report_execution, only: %i[execute_now execute_later]
    before_action :set_input_for_report_execution, only: %i[execute_now execute_later], if: ->{ request.post? }

    def show
      if resource.active_admin_report_runs.present?
        redirect_to admin_active_admin_report_active_admin_report_runs_path(resource)
      else
        redirect_to show_code_admin_active_admin_report_path(resource)
      end
    end

    private

    def set_resource_for_report_execution
      @resource = ActiveAdminReport.find(params[:id])
      @klass = @resource.define_singleton_class_for_script
      @object = @klass.new
    end

    def set_input_for_report_execution
      @input = params.permit![@klass.name.underscore]&.slice(*@object.form_fields_for_input.keys)
      @object.assign_attributes(@input) if @input.present?
    end

    def render_form
      render type: :arb,
             layout: 'active_admin',
             locals: {
               object: @object,
               form_url: @form_url,
               form_input: @object.form_fields_for_input
             },
             inline: <<-TEMPLATE
active_admin_form_for object,
url: form_url,
method: :post do |f|
if form_input.present?
  f.semantic_errors
  f.inputs do
    form_input.each do |k,v|
      f.input k, v
    end
  end
else
 para b '\u2192 Hit Create Report to generate report or Cancel to Abort'
end
f.actions
end
      TEMPLATE
    end
  end
end
