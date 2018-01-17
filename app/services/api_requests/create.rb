class ApiRequests::Create

  def self.call(api_request_params:)
    api_request = ApiRequest.new(api_request_params)
    api_request.save
    api_request
  end

end