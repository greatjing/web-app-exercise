require 'rails_helper'

RSpec.describe "API_V1::Auth", :type => :request do
  example "register" do
    post "/api/v1/signup", params: { :email => "test2@example.com", :password => "12345678" }

    # 检查返回状态码
    expect(response).to have_http_status(200)

    new_user = User.last
    # 检查新建的入库
    expect(new_user.email).to eq("test2@example.com")
    # 检查返回的json
    expect(response.body).to eq( { :user_id => new_user.id }.to_json )
  end

  example "register failed" do
    post "/api/v1/signup", params: { :email => "test3@example.com" }
    # 检查返回状态码
    expect(response).to have_http_status(200)
    # 检查json返回的错误信息
    expect(response.body).to eq( { :message => "Failed", :errors => { :password => ["can't be blank"] } }.to_json )
  end

end
