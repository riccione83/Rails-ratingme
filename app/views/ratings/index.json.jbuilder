json.array!(@ratings) do |rating|
  json.extract! rating, :id, :review_id, :user_id, :user_name, :point, :description, :rate_question1, :rate_question2, :rate_question3
  json.url rating_url(rating, format: :json)
end
