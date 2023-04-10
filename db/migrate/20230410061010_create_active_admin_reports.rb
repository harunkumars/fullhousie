class CreateActiveAdminReports < ActiveRecord::Migration[6.1]
  def change
    create_table :active_admin_reports do |t|
      t.string :name, default: ''
      t.text :description, default: ''
      t.text :ruby_script, default: ''

      t.timestamps
    end
    add_index :active_admin_reports, %i[name]
  end
end
