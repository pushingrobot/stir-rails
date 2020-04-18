class Admin::DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @user = User.find(params[:user_id])
    @device = @user.devices.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @user = User.find(params[:user_id])
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /devices/lookup/:input
  def lookup
    term = params[:term]
    hosts = Mapping.known_hosts(freshen: true)
    # found_devices = DeviceTools.lookup(lookup_params[:term].to_s.strip)

    respond_to do |format|
      format.json { render json: {results: hosts}, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
      @user = @device.user
    end

    # Only allow a list of trusted parameters through.
    def device_params
      params.require(:device).permit(:name, :host, :mac, :active, :icon, :state, :user_id)
    end

    def lookup_params
      params.permit(:term, :q, :_type)
    end
end
