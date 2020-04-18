class StirController < ApplicationController
  before_action :set_device

  def stir
    # wake device (params[:device_id])
    device = @devices[0] # only wake one device at a time for now
    respond_to do |format|
      if device&.stir
        flash[:notice] = "Waking #{device.name}..."
        format.html { redirect_to request.referer || root_path }
        format.json { render json: flash, status: :ok }
      else
        flash[:error] = "Invalid device or MAC address"
        format.html { redirect_to request.referer || root_path }
        format.json { render json: flash, status: :bad_request }
      end
    end
  end

  def poll
    device_states = DeviceTools.poll(@devices)
    respond_to do |format|
      format.json { render json: {results: device_states, status: :ok } }
    end
  end

  private

  def set_device
    if !current_user
      redirect_to login_path\
    elsif current_user.admin?
      scope = Device
    else
      scope = current_user.devices
    end

    if params[:device_id] == 'all'
      @devices = scope.all
    else 
      @devices = [scope.find_by(id: params[:device_id])]
    end
  end
end
