namespace :meeting do
  
  desc "run"
  task :run => :environment do
    time = Time.zone.now
    return unless time.min % 5 == 0
    send_meeting_start_msg
  end

  desc 'finish'
  task :finish => :environment do
    time = Time.zone.now
    return unless time.min % 5 == 0
    send_meeting_end_msg
  end

  def send_meeting_end_msg
    time = Time.zone.now
    configs = MeetingConfig.where(end_time_number: time.strftime("%H%M").to_i)
    configs.each do |config|
      BearychatService.finish_meeting(config.bearychat_id)
    end 
  end

  def send_meeting_start_msg
    time = Time.zone.now  
    configs = MeetingConfig.where(start_time_number: time.strftime("%H%M").to_i)
    configs.each do |config|
      BearychatService.send_text_msg(config.bearychat_id, meeting_info_text(config))
    end 
  end

  def meeting_info_text(config)
    texts = ["Hi @<-channel-> ，我们开始今天的站会！请以数字开头回复如下问题："]
    texts << "1 #{config.yesterday_tips}"
    texts << "2 #{config.today_tips}"
    texts << "3 #{config.trouble_tips}"
    texts << "4 #{config.risk_tips}"
    texts.join("\n")
  end


end