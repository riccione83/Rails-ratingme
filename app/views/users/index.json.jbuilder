json.array!(@users) do |user|
  json.extract! user, :id, :user_name, :user_password_hash, :user_email, :user_city
  json.url user_url(user, format: :json)
end
