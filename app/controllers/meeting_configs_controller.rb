class MeetingConfigsController < ApplicationController
  def index
    if params[:bearychat_id].present?
      @config = MeetingConfig.find_or_initialize_by(bearychat_id: params[:bearychat_id])
    else
      redirect_to '/'
    end
  end
end
