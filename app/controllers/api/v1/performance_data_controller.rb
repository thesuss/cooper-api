class Api::V1::PerformanceDataController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    @data = PerformanceData.new(performance_data_params.merge(user: current_api_v1_user))

    if @data.save
      render json: { message: 'all good' }
    else
      render json: { error: @data.errors.full_messages }
    end
  end

  private

  def performance_data_params
    #Figure out a better way
    params.require(:performance_data).permit!
  end
end
