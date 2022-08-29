class VotesController < ApplicationController
  before_action :set_vote, only: %i[ show edit update destroy ]
  # GET /votes or /votes.json
  def index
    @votes = Vote.all
    
  end

  # GET /votes/1 or /votes/1.json
  def show
  end

  # GET /votes/new
  def new
    @vote = Vote.new
  end

  # GET /votes/1/edit
  def edit
  end

  # POST /votes or /votes.json
  def create
    @vote_this_matchup = Vote.find_by(user_id: params.dig(:vote, :user_id), matchup_id: params.dig(:vote, :matchup_id))
    if @vote_this_matchup
      @vote = @vote_this_matchup
      respond_to do |format|
        if params.has_key?(:next_matchup)
          format.html { redirect_to matchup_url(params[:next_matchup]), notice: "You have already cast a vote." }
          format.json { render :show, status: 400, location: @vote }
        elsif  params.has_key?(:next_round)
          format.html { redirect_to round_url(params[:next_round]), notice: "You have already cast a vote" }
          format.json { render :show, status: 400, location: @vote }
        else
          format.html { redirect_to bracket_url(Bracket.find_by(id: Choice.find_by(id: @vote.choice_id).bracket_id)), notice: "You have already cast a vote." }
          format.json { render :show, status: 400, location: @vote }
        end
      end
    else
      @vote = Vote.new(vote_params)

      respond_to do |format|
        if @vote.save
          if params.has_key?(:next_matchup)
            format.html { redirect_to matchup_url(params[:next_matchup]), notice: "Vote was successfully cast." }
            format.json { render :show, status: :created, location: @vote }
          elsif  params.has_key?(:next_round)
            format.html { redirect_to round_url(params[:next_round]), notice: "Vote was successfully cast." }
            format.json { render :show, status: :created, location: @vote }
          else
            format.html { redirect_to bracket_url(Bracket.find_by(id: Choice.find_by(id: @vote.choice_id).bracket_id)), notice: "Vote was successfully cast." }
            format.json { render :show, status: :created, location: @vote }
          end
            
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @vote.errors, status: :unprocessable_entity }
        end
      end
    end

    
  end

  # PATCH/PUT /votes/1 or /votes/1.json
  def update
    respond_to do |format|
      if @vote.update(vote_params)
        format.html { redirect_to vote_url(@vote), notice: "Vote was successfully updated." }
        format.json { render :show, status: :ok, location: @vote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1 or /votes/1.json
  def destroy
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url, notice: "Vote was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vote_params
      params.require(:vote).permit(:matchup_id, :choice_id, :user_id)
    end
end
