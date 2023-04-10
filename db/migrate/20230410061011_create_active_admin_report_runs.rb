class CreateActiveAdminReportRuns < ActiveRecord::Migration[6.1]
  def change
    create_table :active_admin_report_runs do |t|
      t.datetime :ran_at
      t.belongs_to :admin_user, null: true
      t.belongs_to :active_admin_report, null: true
      t.text :log, default: ''
      t.integer :run_status, default: 0
      t.string :job_reference, default: ''

      t.timestamps
    end
  end
end
