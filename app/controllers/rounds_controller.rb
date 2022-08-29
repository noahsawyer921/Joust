class RoundsController < ApplicationController
  before_action :set_round, only: %i[ show edit update destroy ]

  # GET /rounds or /rounds.json
  def index
    @rounds = Round.all
  end

  # GET /rounds/1 or /rounds/1.json
  def show
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
  end

  # POST /rounds or /rounds.json
  def create
    @round = Round.new(round_params)

    respond_to do |format|
      if @round.save
        format.html { redirect_to round_url(@round), notice: "Round was successfully created." }
        format.json { render :show, status: :created, location: @round }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rounds/1 or /rounds/1.json
  def update
    respond_to do |format|
      if @round.update(round_params)
        format.html { redirect_to round_url(@round), notice: "Round was successfully updated." }
        format.json { render :show, status: :ok, location: @round }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1 or /rounds/1.json
  def destroy
    @round.destroy

    respond_to do |format|
      format.html { redirect_to rounds_url, notice: "Round was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def rounds_for_bracket
    if params.has_key?(:bracket_id)
      respond_to do |format|
        format.html { redirect_to rounds_url, notice: "Tried to access a json API as html. Add .json to the end of your url." }
        format.json { render json: Round.where(bracket_id: params[:bracket_id]), status: :ok}
      end
    else
      respond_to do |format|
        format.html { head :no_content }
        format.json { head :no_content, status: :unprocessable_entity }
      end
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_round
      @round = Round.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def round_params
      params.require(:round).permit(:bracket_id, :active, :round_num)
    end
end
