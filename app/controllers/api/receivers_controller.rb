class Api::ReceiversController < ApplicationController
  def index
    render json: receivers,
           status: :ok
  end

  private
    def receivers
      params[:state] ? Receiver.where(state: params[:state]) : Receiver.all
    end
end
