json.data do
  json.extract! @user, :id, :login_id, :name, :school, :role, :created_at, :updated_at
end
