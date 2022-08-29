class GameChannel < ApplicationCable::Channel
  def subscribed
    bracket = Bracket.find_by(code: params[:code])
    stream_for bracket
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
