class AddColToMeetingMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :meeting_messages, :channel_id, :string
  end
end
