class MatchupsController < ApplicationController
  before_action :set_matchup, only: %i[ show edit update destroy ]

  # GET /matchups or /matchups.json
  def index
    @matchups = Matchup.all
  end

  # GET /matchups/1 or /matchups/1.json
  def show
  end

  # GET /matchups/new
  def new
    @matchup = Matchup.new
  end

  # GET /matchups/1/edit
  def edit
  end

  # POST /matchups or /matchups.json
  def create
    @matchup = Matchup.new(matchup_params)

    respond_to do |format|
      if @matchup.save
        format.html { redirect_to matchup_url(@matchup), notice: "Matchup was successfully created." }
        format.json { render :show, status: :created, location: @matchup }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matchups/1 or /matchups/1.json
  def update
    respond_to do |format|
      if @matchup.update(matchup_params)
        format.html { redirect_to matchup_url(@matchup), notice: "Matchup was successfully updated." }
        format.json { render :show, status: :ok, location: @matchup }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matchups/1 or /matchups/1.json
  def destroy
    @matchup.destroy

    respond_to do |format|
      format.html { redirect_to matchups_url, notice: "Matchup was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def next_matchup
    set_matchup
    Matchup.where("id > ?", @matchup.id).where(round_id: @matchup.round_id).first
  end
  helper_method :next_matchup
  def next_round
    set_matchup
    Round.where("id > ?", @matchup.round_id).where(bracket_id: @matchup.round.bracket_id).first
  end
  helper_method :next_round
  def first_choice_votes
    set_matchup
    return Vote.where(matchup_id: @matchup.id, choice_id: @matchup.first_choice_id)
  end
  helper_method :first_choice_votes
  def second_choice_votes
    set_matchup
    return Vote.where(matchup_id: @matchup.id, choice_id: @matchup.second_choice_id)
  end
  helper_method :second_choice_votes

  def get_matchup_current_vote(no_response: false)
    set_matchup
    if !logged_in?
      return nil
    end
    @vote = Vote.find_by(matchup_id: @matchup.id, user_id: session[:current_user_id])
    if !no_response
      if @vote
        respond_to do |format|
          format.html { redirect_to vote_url(@vote), notice: "Vote found" }
          format.json { render "votes/show", status: :ok, location: @vote }
        end
      else
        respond_to do |format|
          format.html { head 404 }
          format.json { head 404 }
        end
      end
    end
    @vote
  end

  def session_vote_on_matchup
    set_matchup
    if !logged_in?
      return nil
    end
    if Vote.find_by(matchup_id: @matchup.id, user_id: session[:current_user_id])
      respond_to do |format|
        format.html { head 409 }
        format.json { head 409 }
      end
    else
      @vote = Vote.new
      @vote.user_id = session[:current_user_id]
      @vote.choice_id = params[:choice_id]
      @vote.matchup_id = params[:matchup_id]
      @vote.save
      respond_to do |format|
        format.html { redirect_to vote_url(@vote), notice: "Vote cast" }
        format.json { render "votes/show", status: :created, location: @vote }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matchup
      if params[:id]
        @matchup = Matchup.find(params[:id])
      elsif params[:matchup_id]
        @matchup = Matchup.find(params[:matchup_id])
      end
    end

    # Only allow a list of trusted parameters through.
    def matchup_params
      params.require(:matchup).permit(:round_id, :first_choice_id, :second_choice_id)
    end
end
