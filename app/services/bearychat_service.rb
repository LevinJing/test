class BearychatService
  TOKEN = 'f784ff7ef67daa55ada1f27994b0b769'
  BASEURL = 'https://api.bearychat.com/v1'

  def initialize()
  end

  def token
    token = Rails.cache.fetch("TOKEN")
    return token if token
    url = "#{BASEURL}/rtm.start?token=#{TOKEN}"
    # uri = URI.parse(URI.encode(url.strip))
    result = RestClient.post(url, {})
    result = JSON.parse(result.body)
    websocket_connect(result['ws_host']) if result['ws_host']
  end

  def ws_on_message(message)
    p "\n", message, "\n"
  end

  def ws_reconnent

  end

  def websocket_connect(url)
    ws = Faye::WebSocket::Client.new(url)

    ws.on :open do |event|
      p [:open]
    end

    ws.on :message do |event|
      p [:message, event.data]
      ws_on_message(event.data)
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws_reconnent()
      ws = nil
    end
  end
end