class AddEndTimeToMeetingConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :meeting_configs, :end_time_number, :integer
    add_column :meeting_configs, :start_time_number, :integer
  end
end
