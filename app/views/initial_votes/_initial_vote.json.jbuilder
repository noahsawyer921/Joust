json.extract! initial_vote, :id, :user_id, :choice_id, :bracket_id, :created_at, :updated_at
json.url initial_vote_url(initial_vote, format: :json)
