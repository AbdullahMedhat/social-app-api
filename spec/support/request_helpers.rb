module Request
  module Authentication
    def sign_in_as(user)
      post '/auth/sign_in', email: user.email, password: user.password
    end

    def response_headers
      response.headers.slice('uid', 'client', 'access-token')
    end
  end
end
