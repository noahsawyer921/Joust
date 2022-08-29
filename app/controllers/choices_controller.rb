class ChoicesController < ApplicationController
  before_action :set_choice, only: %i[ show edit update destroy ]

  # GET /choices or /choices.json
  def index
    @choices = Choice.all
  end

  # GET /choices/1 or /choices/1.json
  def show
  end

  # GET /choices/new
  def new
    @choice = Choice.new
    if params.has_key?(:label)
      @choice.label = params[:label]
    end
    if session.has_key?(:current_user_id)
      @choice.user_id = :current_user_id
    end
    if session.has_key?(:current_bracket_id)
      @choice.bracket_id = :current_bracket_id
    end
  end

  # GET /choices/1/edit
  def edit
  end

  # POST /choices or /choices.json
  def create
    @choice = Choice.new(choice_params)

    if @choice.bracket.game_state != Bracket::STATES[:choices]
      return nil
    end

    respond_to do |format|
      if @choice.save
        format.turbo_stream {render turbo_stream: turbo_stream.append("choices", partial: "choices/choice", locals: {choice: @choice})}
        @choice.broadcast_append_to("choices_#{session[:current_bracket_id]}", target: "choices_#{session[:current_bracket_id]}")
        format.html { redirect_to bracket_waiting_ideas_url(session[:current_bracket_id]), notice: "Choice was successfully created." }
        format.json { render :show, status: :created, location: @choice }
      else
        format.html { redirect_to request.referrer, notice: "Invalid entry"}
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /choices/1 or /choices/1.json
  def update
    respond_to do |format|
      if @choice.update(choice_params)
        format.html { redirect_to choice_url(@choice), notice: "Choice was successfully updated." }
        format.json { render :show, status: :ok, location: @choice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choices/1 or /choices/1.json
  def destroy
    if !session_is_admin?(Bracket.find_by(id: @choice.bracket_id))
      return nil
    end
    @choice.destroy
    respond_to do |format|
      format.turbo_stream {render turbo_stream: turbo_stream.remove(@choice) }
      @choice.broadcast_remove_to("choices_#{session[:current_bracket_id]}", target: @choice)
      format.html { redirect_to choices_url, notice: "Choice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_choice
      @choice = Choice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def choice_params
      params.require(:choice).permit(:label, :user_id, :bracket_id, :reasoning)
    end
end
