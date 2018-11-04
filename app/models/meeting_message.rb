class MeetingMessage < ApplicationRecord

  belongs_to :meeting_config

  def self.auto_save(data)
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    uid = data['uid']
    content = data['text']
    channel_id = data['channel_id']
    lines = content.split(/\n/).delete_if { |a| a.strip.blank? || !a.start_with?(/[1-4]/) }
    return if where(created_at: today_range, uid: uid).any?
    if lines.empty?
      text = "#{"@<=#{uid}=>"} 无效的站会信息，请注意每行用对应数字开头，一共四件事哦 "
      BearychatService.send_text_msg(channel_id, text)
      return
    end
    create!(
      {
        channel_id: data['channel_id'],
        uid: uid,
        meeting_config_id: MeetingConfig.find_by(bearychat_id: channel_id).id,
      }.merge(splited_content(lines))
    )
    text = "#{"@<=#{uid}=>"} 收到！"
    BearychatService.send_text_msg(channel_id, text)
    # Rails.cache.write("Connnected", 1)
  end

  def self.splited_content(lines)
    result = {}
    lines.each do |line|
      line.strip!
      content = line[1..-1]
      next if content.blank?
      column_name = case line[0].to_i
                    when 1 
                      :yesterday_tips
                    when 2
                      :today_tips
                    when 3
                      :trouble_tips
                    when 4
                      :risk_tips
                    else
                      next
                    end
      result[column_name] = content
    end
    result
  end
end
