json.array!(@invitations) do |invitation|
  json.extract! invitation, :id, :recipient_email, :string, :token
  json.url invitation_url(invitation, format: :json)
end
