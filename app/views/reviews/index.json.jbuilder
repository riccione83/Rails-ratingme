json.array!(@reviews) do |review|
  json.extract! review, :id, :user_id, :lat, :lon, :title, :description, :question1, :question2, :question3, :isAdvertisement, :adImageLink
  json.url review_url(review, format: :json)
end
