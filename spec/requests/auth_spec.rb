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

  # 测试登录成功和失败情况
  before do
    @user = User.create!( :email => "test0@example.com", :password => "12345678" )
  end

  example "valid login and logout" do
    # 打开登录页
    post "/api/v1/login", params: { :auth_token => @user.authentication_token,
                                    :email => @user.email , :password => @user.password }
    # 校验返回的状态码
    expect(response).to have_http_status(200)

    # 校验返回的json
    expect(response.body).to eq(
    {
      :message => "OK",
      :auth_token => @user.authentication_token,
      :user_id => @user.id
    }.to_json
    )

    # 不传参数，点击注销
    post "/api/v1/logout"
    # 校验返回的状态码
    expect(response).to have_http_status(401)

    # 点击注销
    post "/api/v1/logout", params: { :auth_token => @user.authentication_token }
    # 校验返回状态码
    expect(response).to have_http_status(200)
    old_token = @user.authentication_token
    puts old_token
    puts "*****"
    puts @user.authentication_token
    # 校验token值变化
    expect(@user.authentication_token).to eq(old_token)
  end

  example "invalid auth token login" do
    post "/api/v1/login", params: { :auth_token => @user.authentication_token,
                                    :email => @user.email, :password => "123" }

    expect(response).to have_http_status(401)
    expect(response.body).to eq(
    { :message => "Email or Password is wrong" }.to_json
    )

  end


end
