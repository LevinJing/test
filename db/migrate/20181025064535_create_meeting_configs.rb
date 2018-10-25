class CreateMeetingConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :meeting_configs do |t|
      t.string :start_time
      t.integer :time_limit
      t.text :yesterday_tips
      t.text :today_tips
      t.text :trouble_tips
      t.string :bearychat_id

      t.timestamps
    end
  end
end
