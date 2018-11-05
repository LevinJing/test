require 'json'
class BearychatService
  TOKEN = '580521db768e89d62db6a33c6a308e9f'
  HOST = 'http://116.85.47.65/meeting_configs?bearychat_id='
  BASEURL = 'https://api.bearychat.com/v1'

  class << self
    def load()
      Rails.cache.fetch("Connected") do
        rtm_connect()
      end
    end

    def finish_meeting(channel_id)
      send_text_msg channel_id, meeting_finish_text(channel_id)
    end

    def meeting_finish_text(channel_id)
      today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      messages = MeetingMessage.where(created_at: today_range, channel_id: channel_id)
      troubles = messages.map do |data|
        unless data.trouble_tips.blank?
          "【@<=#{data.uid}=>】#{data.trouble_tips}"
        end
      end.compact.join("\n")
      risks = messages.map do |data|
        unless data.risk_tips.blank?
          "【@<=#{data.uid}=>】#{data.risk_tips}"
        end
      end.compact.join("\n")
      info = BearychatService.channel_info(channel_id)
      uids_text = (info['member_uids'] - messages.pluck(:uid) - ['=bxdqO']).map do |uid|
        "@<=#{uid}=>"
      end.join(', ')
      texts = ['今天的阻碍事件有：']
      texts << troubles
      texts << "今天的风险事件有："
      texts << risks
      texts << "未参会人员有：#{uids_text}"
      texts << "请各位参会人员查看他人的站会内容，如有问题请在会后详聊。"
      texts.join("\n")
    end

    def send_text_msg(channel_id, text)
      url = "#{BASEURL}/message.create"
      p 'send_text_msg', text
      RestClient.post(url, {
        vchannel_id: channel_id,
        text: text,
        attachments: text,
        token: TOKEN
      })
    end

    def send_config_url(data)
      channel_id = data['channel_id']
      data["text"] = 'dsa'
    end

    def channel_info(channel_id)
      url = "#{BASEURL}/channel.info?token=#{TOKEN}&channel_id=#{channel_id}"
      JSON.parse(RestClient.get(url))
    end

    def rtm_connect
      begin
        url = "https://rtm.bearychat.com/start?token=#{TOKEN}"
        result = RestClient.post(url, {})
        result = JSON.parse(result.body)
        websocket_connect(result['result']['ws_host']) if result['result']['ws_host']
        true
      rescue => exception
        
      end
    end

    def ws_reconnent
      Rails.cache.delete("Connected")
      rtm_connect()
    end

    def websocket_connect(url)
      WebSocket::Client::Simple.connect url do |ws|
        ws.on :open do
          puts "connect!"
        end

        ws.on :close do
          p "断开了！！！！！！"
          ws_reconnent()
        end

        ws.on :error do |e|
          p e, '='*100
        end

        ws.on :message do |message|
          p message, message.type
          if message.type.to_s == 'close'
            BearychatService::rtm_connect()
            return
          end
          begin
            data = JSON.parse(message.data)
            Handler.dispatch(data)
          rescue => exception
            p exception, 'excception'
          end
        end

        # loop do
        #   ws.send STDIN.gets.strip
        # end
      end
    end
  end
end

class Handler
  def self.dispatch(data)
    return if data["type"] != 'channel_message'
    channel_id = data["vchannel_id"]
    p data
    if data["text"] == "设置"
      text = "#{"@<=#{data["uid"]}=>"} 请在这里编辑你的站会配置：#{BearychatService::HOST}#{data["channel_id"]}"
      BearychatService.send_text_msg(channel_id, text)
    else
      time = Time.zone.now.strftime('%H%M').to_i
      return if MeetingConfig.where('start_time_number <= ? and end_time_number >= ?', time, time).where(bearychat_id: channel_id).empty?
      MeetingMessage.auto_save(data)
    end  
  end
end
