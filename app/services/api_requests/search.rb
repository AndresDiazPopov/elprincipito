class ApiRequests::Search

  def self.call(login: nil, user: nil)
    api_requests = ApiRequest.all
    
    api_requests = api_requests.where(login: login) if login

    api_requests = api_requests.where(user: user) if user

    api_requests
  end

end