require 'rails_helper'

RSpec.describe 'GET /tasks', type: :request do
    
let(:user) { Fabricate(:user) }
let(:user2) { Fabricate(:user) }
let(:url) { '/login' }
let(:params) do
    {
        user: {
            email: user.email,
            password: user.password
        }
    }
end
let(:params2) do
  {
    user: {
          email: user2.email,
          password: user2.password
      }
  }
end


context 'you must be authorized to perform any crud on tasks' do
  it "doesn't allow any unauthorized requests to the tasks controller" do
    get '/tasks' 
    expect(response.status).to eq 401
    get '/tasks/1'
    expect(response.status).to eq 401
    post '/tasks', params: { task: {content: 'words'}} 
    expect(response.status).to eq 401
    patch '/tasks/1', params: {task: {content: 'words'}}
    expect(response.status).to eq 401
    delete '/tasks/1'
    expect(response.status).to eq 401
  end

end

  context 'authenticated users can only create/update their own resources' do
    let(:tasksURL) { '/tasks' }
    before do
      
      post '/login', params: params
      @token = response.headers['Authorization'] 
      post '/login', params: params2
      @token2 = response.headers['Authorization'] 
    end

    it 'returns a 404 for unfound tasks' do 
      get '/tasks/1000', headers: { Authorization: @token}
      expect(response.status).to eq 404
    end

    it 'allows an user to view only their own tasks' do
      get tasksURL, headers: { Authorization: @token }
      body1 = JSON.parse(response.body)
      # p body1
      expect(body1.length).to eq 2
      expect(body1.first['user_id']).to eq 1
      expect(body1.last['user_id']).to eq 1

      get tasksURL, headers: { Authorization: @token2}
      body2 = JSON.parse(response.body)
      # p body2
      expect(body2.length).to eq 2
      expect(body2.first['user_id']).to eq 2
      expect(body2.last['user_id']).to eq 2
    end

    it 'prevents an user from updating a task which is not theirs' do
      patch '/tasks/3', params: {task: {content: "words"}}, headers: {Authorization: @token}
      expect(response.status).to eq 401
    end

    it 'allows an user to update their task' do
      patch '/tasks/1', params: {task: {content: "Laundry"}}, headers: {Authorization: @token}
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body["content"]).to eq("Laundry")
    end

    it 'stops someone who is not the user from deleting a task' do
      delete '/tasks/3', headers: { Authorization: @token}
      expect(response.status).to eq 401
    end

    it 'prevents someone from viewing a task which is not theirs' do
      get '/tasks/1', headers: { Authorization: @token2 }
      expect(response.status).to eq 401
    end

  end
end