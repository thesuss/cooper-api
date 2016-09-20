require 'rails_helper'

describe 'Sessions' do

  let(:user) { FactoryGirl.create(:user) }
  let(:headers) { {HTTP_ACCEPT: 'application/json'} }

  describe 'POST /api/v1/auth/sign_in' do
    it 'valid credentials returns user' do
      post '/api/v1/auth/sign_in',
        params: {email: user.email, password: user.password},
        headers: headers
      expect(response_json).to eq(
                                   {'data' =>
                                        {'id' => user.id,
                                         'provider' => 'email',
                                         'uid' => user.email,
                                         'name' => nil,
                                         'nickname' => nil,
                                         'image' => nil,
                                         'email' => user.email}}
                               )
    end

    it 'invalid password returns error message' do
      post '/api/v1/auth/sign_in',
        params: {email: user.email, password: 'wrong_password'},
        headers: headers
      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end

    it 'invalid email returns error message' do
      post '/api/v1/auth/sign_in',
        params: {email: 'wrong@email.com', password: user.password},
        headers: headers
      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end

    it 'with an empty password field returns error message' do
      post '/api/v1/auth/sign_in',
        params: {email: 'wrong@email.com', password: nil},
        headers: headers
      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end
    it 'with an empty email field returns error message' do
      post '/api/v1/auth/sign_in',
        #nil creates an error in devise
        params: {email: '', password: user.password},
        headers: headers
      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
      expect(response.status).to eq 401
    end

  end

end
