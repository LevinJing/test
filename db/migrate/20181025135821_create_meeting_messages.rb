class CreateMeetingMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :meeting_messages do |t|
      t.integer :meeting_config_id
      t.string :uid
      t.text :yesterday_tips
      t.text :today_tips
      t.text :trouble_tips
      t.text :risk_tips

      t.timestamps
    end
  end
end
