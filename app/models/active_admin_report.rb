class ActiveAdminReport < ApplicationRecord
  has_many :active_admin_report_runs

  def define_singleton_class_for_script
    ruby_script = self.ruby_script #pass instance attribute ruby_script through scope gates
    Class.new(ActiveAdminReportRun) do
      class_attribute :form_fields_for_input, default: {}
      def self.name
        "Report"
      end

      def self.input(name, cast_type = nil, **options)
        name = name.to_sym
        options.symbolize_keys!
        default = options.delete(:default) || nil

        attribute name, cast_type, default: default
        self.form_fields_for_input = form_fields_for_input.merge(name => options || {})
      end

      class_eval(ruby_script)
      def new(input_hash)
        # At this point, the Class has been dynamically defined and has the necessary attribute accessors for inputs declared in the script
        assign_attributes(input_hash)
      end
    end
  end
end
