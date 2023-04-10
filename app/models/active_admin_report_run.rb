class ActiveAdminReportRun < ApplicationRecord
  belongs_to :admin_user, optional: true
  belongs_to :active_admin_report
  has_many_attached :reports

  enum run_status: {
    pending: 0,
    enqueued: 1,
    running: 2,
    completed: 3,
    failed: 4
  }, _prefix: true
end
