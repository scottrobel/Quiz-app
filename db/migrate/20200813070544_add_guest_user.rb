class AddGuestUser < ActiveRecord::Migration[6.0]
  def change
    User.create!(email: "guest@guest.com", password: "REDACTED", user_type: "guest_user")
  end
end
