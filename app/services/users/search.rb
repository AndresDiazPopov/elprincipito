class Users::Search

  def self.call(text: nil, state: nil)
    users = User.all

    # Search by text
    users = users.where('email LIKE ?', "%#{text}%") if text

    users = users.where(state: User.states[state]) if state

    users
  end

end