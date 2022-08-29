class BracketsController < ApplicationController
  before_action :set_bracket, only: %i[ show edit update destroy ]

  # GET /brackets or /brackets.json
  def index
    @brackets = Bracket.all
  end

  # GET /brackets/1 or /brackets/1.json
  def show
    @rounds = @bracket.rounds
  end

  # GET /brackets/new
  def new
    @bracket = Bracket.new
  end

  # GET /brackets/1/edit
  def edit
  end

  # POST /brackets or /brackets.json
  def create
    #@same_code_bracket = Bracket.find_by(code: params.dig(:bracket, :code))
    #@bracket = @same_code_bracket || Bracket.new(bracket_params)
    @bracket = Bracket.new
    @bracket.game_state = Bracket::STATES[:uninitialized] 
    @bracket.admin_id = nil
    code = (@bracket.hash % 1000000).to_s.rjust(6, padstr='0')
    while Bracket.find_by(code: code) do
      code = (code.hash % 1000000).to_s.rjust(6, padstr='0')
    end
    @bracket.code = code
    respond_to do |format|
      if @bracket.save
        session[:current_bracket_id] = @bracket.id
        format.html { redirect_to new_user_url, notice: "Bracket was successfully created." }
        format.json { render :show, status: :created, location: @bracket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bracket.errors, status: :unprocessable_entity }
      end
    end
  end

  def join
  end

  def join_with_code
    @bracket = Bracket.find_by(code: params[:code])
    respond_to do |format|
      if @bracket
        session[:current_bracket_id] = @bracket.id
        format.html { redirect_to new_user_url, notice: "Bracket was successfully joined." }
        format.json { render :show, status: :created, location: @bracket }
      else
        format.html { redirect_to join_url, notice: "No bracket with given code exists." }
      end
    end
  end


  # PATCH/PUT /brackets/1 or /brackets/1.json
  def update
    respond_to do |format|
      if @bracket.update(bracket_params)
        format.html { redirect_to bracket_url(@bracket), notice: "Bracket was successfully updated." }
        format.json { render :show, status: :ok, location: @bracket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bracket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brackets/1 or /brackets/1.json
  def destroy
    if !session_is_admin?(@bracket)
      return nil
    end

    @bracket.destroy
    respond_to do |format|
      format.html { redirect_to brackets_url, notice: "Bracket was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def active_round
    set_bracket
    Round.find_by(bracket_id: @bracket.id, active: true)
  end
  helper_method :active_round

  def active_round_for_bracket(bracket_id)
    Round.find_by(bracket_id: bracket_id, active: true)
  end
  helper_method :active_round_for_bracket

  def next_round
    set_bracket
    Round.find_by(bracket_id: @bracket.id, round_num: active_round.round_num + 1)
  end

  helper_method :next_round

  def activate_next_round
    set_bracket
    unready_all(no_response: true)
    if @bracket.game_state == Bracket::STATES[:choices]
      start_game
      @bracket.game_state = Bracket::STATES[:voting] 
      @bracket.save
    elsif @bracket.game_state == Bracket::STATES[:voting]
      build_first_round
      @bracket.game_state = Bracket::STATES[:matchup]
      @bracket.save
      GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:state], game_state: Bracket::STATES[:matchup]})
      GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:round], round: active_round.round_num})
    elsif @bracket.game_state == Bracket::STATES[:matchup] and active_round.matchups.count > 1 #TODO, change to check for game_state == waiting_for_round when game_state is added
      build_next_round
      GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:round], round: active_round.round_num})
    elsif @bracket.game_state == Bracket::STATES[:matchup] and active_round.matchups.count == 1
      display_winner
      @bracket.game_state = Bracket::STATES[:finish] 
      GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:state], game_state: Bracket::STATES[:finish]})
      @bracket.save
    #TODO, change to check for game_state == end to display the end screen when end screen and game_state are added
    end
  end
  helper_method :activate_next_round


  def initial_votes_count(choice)
    initial_votes = InitialVote.where(choice_id: choice.id, bracket_id: choice.bracket_id)
    initial_votes.count
  end
  helper_method :initial_votes_count

  def bracket_size
    set_bracket
    choices = Choice.where(bracket_id: @bracket.id)
    num_choices = choices.count
    n = 1
    while n * 2 <= num_choices
      n *= 2
    end
    n
  end
  helper_method :bracket_size

  #Builds the next round, populating it with matchups with the choices which recieved the most initial votes
  #Should be called from the activate_next_round method, where set_bracket should have already been called
  def build_first_round
    round = Round.new(bracket_id: @bracket.id, round_num: 0, active: false)
    round.save
    choice_list = @bracket.choices.sort_by{|choice| initial_votes_count(choice)}
    choice_list.reverse!
    choice_list = choice_list.first(bracket_size)
    size = bracket_size
    n = 0
    while n < size / 2
      matchup = Matchup.new(round_id: round.id, first_choice_id: choice_list[n].id, second_choice_id: choice_list[size - (n + 1)].id)
      if !matchup.save
        respond_to do |format|
          format.html { redirect_to bracket_url(@bracket), notice: "Error trying to create matchups." }
          format.json { head 400 }
        end
        return nil
      end
      n += 1
    end 
    round.active = true
    round.save
    round
  end
  #helper_method :build_first_round

  def first_choice_votes_for_matchup(matchup)
    return Vote.where(matchup_id: matchup.id, choice_id: matchup.first_choice_id).count
  end
  def second_choice_votes_for_matchup(matchup)
    return Vote.where(matchup_id: matchup.id, choice_id: matchup.second_choice_id).count
  end
  #Should be called from the activate_next_round method, where set_bracket should have already been called
  def build_next_round
    #Active_round should be true
    previous_round = active_round
    if !previous_round
      #Respond with a fail if no active round was found
      respond_to do |format|
        format.html { redirect_to bracket_url(@bracket), notice: "Tried to build next round, but no active round was found." }
        format.json { head 400 }
      end
      return nil
    end
    next_round = Round.new(bracket_id: @bracket.id, round_num: previous_round.round_num + 1, active: false)
    next_round.save
    previous_matchups = previous_round.matchups
    n = 0
    while n < previous_matchups.count
      first_choice_id = first_choice_votes_for_matchup(previous_matchups[n]) > second_choice_votes_for_matchup(previous_matchups[n]) ? previous_matchups[n].first_choice_id : previous_matchups[n].second_choice_id
      second_choice_id = first_choice_votes_for_matchup(previous_matchups[n+1]) > second_choice_votes_for_matchup(previous_matchups[n+1]) ? previous_matchups[n+1].first_choice_id : previous_matchups[n+1].second_choice_id      
      matchup = Matchup.new(round_id: next_round.id, first_choice_id: first_choice_id, second_choice_id: second_choice_id)
      if !matchup.save
          respond_to do |format|
            format.html { redirect_to bracket_url(@bracket), notice: "Saving matchup for building new round failed." }
            format.json { head 400 }
          end
          #Kill the round so it doesn't have to be manually deleted
          next_round.destroy
        return nil
      end
      n += 2
    end
    next_round.active = true
    next_round.save
    previous_round.active = false
    previous_round.save
    next_round
  end
  def session_details
    status = :ok
    if not (logged_in? and in_game?)
      status = 401
    end
    respond_to do |format|
        format.html { redirect_to brackets_url, notice: "Tried to access a json file as html, add .json" }
        format.json { render :session_details, status: status}
     end
  end

  def active_round_details
  end

  def active_round_matchups
  end

  def home
  end

  def ready_to_start
    set_bracket
    if params[:current_game_state].to_i == @bracket.game_state
      ready_current_session(no_response: true)
    end
    respond_to do |format|
        format.html { redirect_to game_url, notice: "starting" }
        format.json { head :ok }
     end
  end

  def game
  end

  def test_cast
    set_bracket
    GameChannel.broadcast_to(@bracket, "Hello")
  end

  def show_users
    set_bracket

  end

  def show_ideas
    set_bracket
  end

  def start_game
    set_bracket
    #Advance game state from adding choices (1) to waiting/initial votes (2)
    GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:state], game_state: Bracket::STATES[:voting]})
    @bracket.game_state = Bracket::STATES[:voting] 
    @bracket.save
    @bracket.broadcast_replace_to("start_#{session[:current_bracket_id]}", target: "start_#{session[:current_bracket_id]}", partial:"brackets/start_game", locals: {bracket: Bracket.find_by(id: session[:current_bracket_id])})
  end
  #Advance game state from joining users (0) to adding choices (1)
  def move_to_choices
    set_bracket
    if !session_is_admin?(@bracket)
      return nil
    end
    GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:state], game_state: Bracket::STATES[:choices]})
    @bracket.game_state = Bracket::STATES[:choices] 
    @bracket.save
    @bracket.broadcast_replace_to("users_#{session[:current_bracket_id]}", target: "move_to_choices", partial:"brackets/move_to_choices", locals: {bracket: Bracket.find_by(id: session[:current_bracket_id])})
    respond_to do |format|
      format.html { redirect_to bracket_waiting_ideas_url(@bracket), notice: "Advancing to ideas." }
      format.json { render :show, status: :created, location: round }
    end
  end

  def display_winner
    set_bracket
    first_votes = first_choice_votes_for_matchup(active_round.matchups.first)
    second_votes = second_choice_votes_for_matchup(active_round.matchups.first)
    if first_votes > second_votes
      respond_to do |format|
        @choice = active_round.matchups.first.first_choice
        format.html { head :ok }
        format.json { render "choices/show", status: :ok }
      end
    else
      respond_to do |format|
        @choice = active_round.matchups.first.second_choice
        format.html { head :ok }
        format.json { render "choices/show", status: :ok }
      end
    end
  end

  def game_details
    if in_game?
      set_bracket
      respond_to do |format|
        format.html { redirect_to root_url, notice: "tried to access json as html." }
        format.json { render :game_details, status: :created, location: @bracket }
      end
    else
      respond_to do |format|
        format.html { redirect_to bracket_url(@bracket), notice: "You are not in a game." }
        format.json { head 400 }
      end
    end
  end

  def choices_for_current_bracket
    set_bracket
    if in_game?
      respond_to do |format|
        format.html { redirect_to root_url, notice: "tried to access json as html." }
        format.json { render :choices_for_current_bracket, status: :created, location: @bracket }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_url, notice: "You are not in a game" }
        format.json { head 400 }
      end
    end
    
  end

  def ready_current_session(no_response: false)
    #This function should be used in a session
    if !in_game? or !logged_in?
      return nil
    end
    #Do not allow a user to ready up multiple times
    if Ready.find_by(ready_bracket_id: session[:current_bracket_id], ready_user_id: session[:current_user_id])
      if !no_response
        respond_to do |format|
          format.html { head 409  }
          format.json { head 409  }
        end
      end
      return nil
    end
    @ready = Ready.new
    @ready.ready_user_id = session[:current_user_id]
    @ready.ready_bracket_id = session[:current_bracket_id]
    if @ready.save
      set_bracket
      GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:ready], players_ready: ready_users})
      if ready_users == @bracket.users.count
        activate_next_round
      elsif !no_response
        respond_to do |format|
          format.html { head :created }
          format.json { head :created }
        end
      end
    end
  end

  def unready_current_session(no_response: false)
    #This function should be used in a session
    if !in_game? or !logged_in?
      return nil
    end
    ready = Ready.find_by(ready_bracket_id: session[:current_bracket_id], ready_user_id: session[:current_user_id])
    #Do not allow a user to ready up multiple times
    if !ready
      if !no_response
        respond_to do |format|
          format.html { head 409  }
          format.json { head 409  }
        end
      end
      return nil
    end
    if ready.destroy
      GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:ready], players_ready: ready_users})
    end
  end

  def unready_all(no_response: false)
    if !in_game?
      if !no_response
        respond_to do |format|
          format.html { head 409  }
          format.json { head 409  }
        end
      end
      return nil
    end
    Ready.where(ready_bracket_id: session[:current_bracket_id]).each do |ready|
      ready.destroy
      if !no_response
        respond_to do |format|
          format.html { head :ok }
          format.json { head :ok }
        end
      end
    end
    set_bracket
    GameChannel.broadcast_to(@bracket, {type: Bracket::BROADCASTS[:ready], players_ready: ready_users})
  end

  #Counting users who are ready
  def ready_users
    set_bracket
    Ready.where(ready_bracket_id: @bracket.id).count
  end
  helper_method :ready_users


  def leave(no_response: false)
    if in_game? and logged_in?
      current_bracket.users.delete(current_user)
      current_bracket.broadcast_remove_to("users_#{session[:current_bracket_id]}", target: current_user)
      if !no_response
        respond_to do |format|
          format.html { redirect_to root_url, notice: "You have successfully left your game." }
          format.json { head :ok }
        end
      end
    else
      if !no_response
        respond_to do |format|
          format.html { redirect_to root_url, notice: "Error trying to leave your game." }
          format.json { head 400 }
        end
      end
    end
    
  end
  helper_method :leave

  def help
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bracket
      if params.has_key?(:id)
        @bracket = Bracket.find(params[:id])
      elsif params.has_key?(:bracket_id)
        @bracket = Bracket.find(params[:bracket_id])
      elsif session[:current_bracket_id]
        @bracket = Bracket.find(session[:current_bracket_id])
      else
        @bracket = nil
      end
    end

    # Only allow a list of trusted parameters through.
    def bracket_params
      params.require(:bracket).permit()
    end
end
