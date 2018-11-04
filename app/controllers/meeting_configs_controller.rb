class MeetingConfigsController < ApplicationController
  def index
    if params[:bearychat_id].present?
      @data = BearychatService.channel_info(params[:bearychat_id])
      @config = MeetingConfig.find_or_initialize_by(bearychat_id: params[:bearychat_id])
    else
      redirect_to '/'
    end
  end

  def create
    @config = MeetingConfig.create!(config_params)
    # @config.update(end_time: @config.start_time + )
    flash[:success] = "MeetingConfig was successfully created"
    redirect_to meeting_configs_path(bearychat_id: @config.bearychat_id)
  end

  def update
    @config = MeetingConfig.find(params[:id])
    if @config.update!(config_params)
      flash[:success] = "MeetingConfig was successfully updated"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to meeting_configs_path(bearychat_id: @config.bearychat_id)
  end

  
  private
  def config_params
    if params[:meeting_config][:start_time].present?
      time_str = params[:meeting_config][:start_time]
      limit = params[:meeting_config][:time_limit].to_i
      start_time = time_str.gsub(':', '').to_i
      params[:meeting_config][:start_time_number] = start_time
      params[:meeting_config][:end_time_number] = (Time.parse(time_str) + limit.minute).strftime('%H%M').to_i 
    end
    params.require(:meeting_config).permit(:bearychat_id, :start_time, :end_time_number, :start_time_number, :time_limit, :yesterday_tips, :today_tips, :trouble_tips, :risk_tips, :show_risk, :show_trouble)
  end
end
