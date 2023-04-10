ActiveAdmin.register ActiveAdminReportRun do
  menu false
  belongs_to :active_admin_report
  actions :index, :show, :destroy

  includes %i[admin_user active_admin_report]

  parent_info_line_1 = Proc.new do
    column :name do |report|
      div do
        link_to report.name, show_code_admin_active_admin_report_path(report)
      end
    end
    column :description
    column :created_at
    column :updated_at
  end

  index(as: :table_with_info, content_blocks: { parent_content: parent_info_line_1 }) do
    selectable_column
    id_column
    column :active_admin_report do |run|
      div do
        link_to run.active_admin_report.name, show_code_admin_active_admin_report_path(run.active_admin_report)
      end
    end
    column :admin_user
    column :reports do |run|
      div do
        run.reports.map do |r|
          li a(href: r.url){ r.filename }
        end
      end if run.reports.present?
    end
    column :job_reference
    column(:run_status) do |run|
      status_tag run.run_status_completed?, label: run.run_status
    end
    column :ran_at
    actions
  end

  show do
    columns do
      column(max_width: '70%') do
        code do
          div(style: 'white-space: pre-wrap; overflow-wrap: break-word;') do
            resource.log
          end
        end
      end
      column do
        panel 'Report(s)' do
          resource.reports.map do |r|
            li a(href: r.url){ r.filename }
          end
        end
      end if resource.reports.present?
    end
  end

  action_item :show_code, only: :index do
    link_to 'Show Code', show_code_admin_active_admin_report_path(params[:active_admin_report_id]) if params[:active_admin_report_id]
  end
  action_item :execute, only: :index do
    dropdown_menu 'Execute Options' do
      item 'Execute Now', execute_now_admin_active_admin_report_path(params[:active_admin_report_id])
      item 'Execute Later', execute_later_admin_active_admin_report_path(params[:active_admin_report_id])
    end if params[:active_admin_report_id]
  end

  sidebar('Info', only: :show) do
    attributes_table do
      rows :active_admin_report, :admin_user, :ran_at, :created_at, :updated_at
    end
  end

  controller do
    include ActiveStorage::SetCurrent
  end
end
