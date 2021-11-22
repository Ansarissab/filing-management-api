class Api::FilingsController < ApplicationController
  def index
    render json: Filer.all,
           status: :ok
  end
end
