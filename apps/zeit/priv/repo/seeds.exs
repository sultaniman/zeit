alias Zeit.Users

{:ok, _user} = Users.create(%{
  email: "user@email.com",
  full_name: "User Name",
  provider: "google"
})
