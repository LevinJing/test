class AddColsToMeetingConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :meeting_configs, :risk_tips, :text
    add_column :meeting_configs, :show_risk, :boolean
    add_column :meeting_configs, :show_trouble, :boolean
  end
end
