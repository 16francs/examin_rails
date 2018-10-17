json.status :success

json.data do
  json.access_token @api_key[:access_token]
  json.user @user, :id, :role
end
