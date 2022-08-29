class InitialVotesController < ApplicationController
  before_action :set_initial_vote, only: %i[ show edit update destroy ]

  # GET /initial_votes or /initial_votes.json
  def index
    @initial_votes = InitialVote.all
  end

  # GET /initial_votes/1 or /initial_votes/1.json
  def show
  end

  # GET /initial_votes/new
  def new
    @initial_vote = InitialVote.new
  end

  # GET /initial_votes/1/edit
  def edit
  end

  # POST /initial_votes or /initial_votes.json
  def create
    @previous_initial_vote = InitialVote.find_by(user_id: params.dig(:initial_vote, :user_id), bracket_id: params.dig(:initial_vote, :bracket_id), choice_id: params.dig(:initial_vote, :choice_id))

    if @previous_initial_vote
      @initial_vote = @previous_initial_vote
      respond_to do |format|
        format.html { redirect_to bracket_url(@initial_vote.bracket_id), notice: "Duplicate vote, not created." }
        format.json { render :show, status: 400, location: @initial_vote }
      end
    else

      @initial_vote = InitialVote.new(initial_vote_params)

      respond_to do |format|
        if @initial_vote.save
          format.html { redirect_to bracket_url(@initial_vote.bracket_id), notice: "Initial vote was successfully created." }
          format.json { render :show, status: :created, location: @initial_vote }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @initial_vote.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /initial_votes/1 or /initial_votes/1.json
  def update
    respond_to do |format|
      if @initial_vote.update(initial_vote_params)
        format.html { redirect_to initial_vote_url(@initial_vote), notice: "Initial vote was successfully updated." }
        format.json { render :show, status: :ok, location: @initial_vote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @initial_vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /initial_votes/1 or /initial_votes/1.json
  # DELETE /initial_votes {id: id_to_delete}
  def destroy

    if logged_in?
      if @initial_vote.user_id != session[:current_user_id]
        return nil
      end
    end
    @initial_vote.destroy
    respond_to do |format|
      format.html { redirect_to initial_votes_url, notice: "Initial vote was successfully destroyed." }
      format.json { head :no_content, status: :ok }
    end
  end

  def initial_votes_for_session
    if in_game? and logged_in?
      respond_to do |format|
        format.html { redirect_to root_url, notice: "Tried to access json API as html." }
        format.json { render :initial_votes_for_session, status: :ok}
      end
    else
      respond_to do |format|
        format.html { redirect_to initial_votes_url, notice: "Not in bracket or not logged in." }
        format.json { head :no_content }
      end
    end
  end

  def create_initial_vote_for_session
    @initial_vote = InitialVote.new
    @initial_vote.choice_id = params[:choice_id]
    @initial_vote.user_id = session[:current_user_id]
    @initial_vote.bracket_id = session[:current_bracket_id]
    #Example request fetch("http://localhost:3000/initial_vote_for_session", {method: "POST", headers: {'Content-Type': 'application/json', "X-CSRF-Token": document.querySelector("[name='csrf-token']").content},credentials:"include", body:JSON.stringify({choice_id:1})})

    respond_to do |format|
        if @initial_vote.save
          format.html { redirect_to bracket_url(@initial_vote.bracket_id), notice: "Initial vote was successfully created." }
          format.json { render :show, status: :created, location: @initial_vote }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @initial_vote.errors, status: :unprocessable_entity }
        end
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_initial_vote
      @initial_vote = InitialVote.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def initial_vote_params
      params.require(:initial_vote).permit(:user_id, :choice_id, :bracket_id)
    end
end
