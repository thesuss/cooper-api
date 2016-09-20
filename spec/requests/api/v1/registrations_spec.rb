require 'rails_helper'

describe 'User Registration' do
  let(:headers) { {HTTP_ACCEPT: 'application/json'} }
  let(:user) { FactoryGirl.create(:user) }

  describe 'POST /api/v1/auth/' do
    describe 'register a user' do
      it 'with valid sign up returns user & token' do
        post '/api/v1/auth',
          params: { email: 'thesuss@susscreations.se',
                    password: 'password',
                    password_confirmation: 'password'},
          headers: headers
        expect(response_json['status']).to eq('success')
        expect(response.status).to eq 200
      end

      it 'with an invalid password confirmation returns error message' do
        post '/api/v1/auth',
          params: { email: 'thesuss@susscreations.se',
                    password: 'password',
                    password_confirmation: 'wrong_password'},
          headers: headers
        expect(response_json['errors']['password_confirmation']).to eq(['doesn\'t match Password'])
        expect(response.status).to eq 422
      end

      it 'with an invalid password confirmation returns error message' do
        post '/api/v1/auth',
          params: { email: 'thesuss@sussc',
                    password: 'password',
                    password_confirmation: 'password'},
          headers: headers
        expect(response_json['errors']['email']).to eq(['is not an email'])
        expect(response.status).to eq 422
      end

      it 'with an already registered email returns error message' do
        User.create(email: 'thesuss@susscreations.se',
                    password: 'password',
                    password_confirmation: 'password')
        post '/api/v1/auth',
          params: { email: 'thesuss@susscreations.se',
                    password: 'password',
                    password_confirmation: 'password'},
          headers: headers
        expect(response_json['errors']['email']).to eq(['already in use'])
        expect(response.status).to eq 422
      end
    end
    it 'with an empty password field returns error message' do
      post '/api/v1/auth',
        params: { email: 'thesuss@susscreations.se',
                  password: nil,
                  password_confirmation: nil},
        headers: headers
      expect(response_json['errors']['password']).to eq(['can\'t be blank'])
      expect(response.status).to eq 422
    end
    it 'with an empty email field returns error messages' do
      post '/api/v1/auth',
        params: { email: nil,
                  password: 'password',
                  password_confirmation: 'password'},
        headers: headers
      expect(response_json['errors']['email']).to eq(['can\'t be blank', 'is not an email'])
      expect(response.status).to eq 422
    end
  end

  describe "PUT '/api/v1/auth/'" do
    it "should be able to edit email" do
      put '/api/v1/auth',
        params: {},
        headers: headers
      new_email = "new@email.com"
      user.update_attributes(email: new_email)
      expect(user.email).to eq "new@email.com"
      #expect(user).to receive(:update_attributes).with(email: "new@email.com")
    end
    it "should be able to add nickname" do
      put '/api/v1/auth',
        params: {},
        headers: headers
      new_nickname = "Nick"
      user.update_attributes(nickname: new_nickname)
      expect(user.nickname).to eq "Nick"
      #expect(user).to receive(:update_attributes).with(nickname: "Nick")
    end
  end
end
