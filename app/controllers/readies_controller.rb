class ReadiesController < ApplicationController
  before_action :set_ready, only: %i[ show edit update destroy ]

  # GET /readies or /readies.json
  def index
    @readies = Ready.all
  end

  # GET /readies/1 or /readies/1.json
  def show
  end

  # GET /readies/new
  def new
    @ready = Ready.new
  end

  # GET /readies/1/edit
  def edit
  end

  # POST /readies or /readies.json
  def create
    @ready = Ready.new(ready_params)

    respond_to do |format|
      if @ready.save
        format.html { redirect_to ready_url(@ready), notice: "Ready was successfully created." }
        format.json { render :show, status: :created, location: @ready }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ready.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /readies/1 or /readies/1.json
  def update
    respond_to do |format|
      if @ready.update(ready_params)
        format.html { redirect_to ready_url(@ready), notice: "Ready was successfully updated." }
        format.json { render :show, status: :ok, location: @ready }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ready.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /readies/1 or /readies/1.json
  def destroy
    @ready.destroy

    respond_to do |format|
      format.html { redirect_to readies_url, notice: "Ready was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ready
      @ready = Ready.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ready_params
      params.require(:ready).permit(:bracket_id, :user_id)
    end
end
