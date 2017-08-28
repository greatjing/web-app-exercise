require 'rails_helper'

RSpec.describe "API_V1::Reservation", :type => :request do
  before do
    @train1 = Train.create!( :number => "0822" )
    @train2 = Train.create!( :number => "0828" )

    @user = User.create!( :email => "test@example.com", :password => "12345678" )
    @reservation = Reservation.create!( :train_id => @train1.id, :seat_number => "1A",
                                        :customer_name => "test", :customer_phone => "12345678" )
  end

  example "GET /api/v1/reservations/{booking_code}" do
    get "/api/v1/reservations/#{@reservation.booking_code}"

    expect(response).to have_http_status(200)
    expect(response.body).to eq({ :booking_code => @reservation.booking_code,
                                  :train_number => @reservation.train.number,
                                  :train => {
                                    :number => @train1.number,
                                    :logo_url => nil,
                                    :logo_file_size => nil,
                                    :logo_content_type => nil,
                                    :available_seats => ["1B", "1C", "2A", "2B", "2C", "3A", "3B", "3C", "4A", "4B", "4C", "5A", "5B", "5C", "6A", "6B", "6C" ],
                                    :created_at => @train1.created_at
                                  },
                                  :seat_number => "1A",
                                  :customer_name => "test",
                                  :customer_phone => "12345678"
                                }.to_json)
  end

  example "DELETE /api/v1/reservations/{booking_code}" do
    delete "/api/v1/reservations/#{@reservation.booking_code}"

    expect(response).to have_http_status(200)
    expect(response.body).to eq({ :message => "已取消" }.to_json)
    expect(Reservation.count).to eq(0)
  end

  example "PATCH /api/v1/reservations/{booking_code}" do
    patch "/api/v1/reservations/#{@reservation.booking_code}", :params => { :customer_name => "update_name", :customer_phone => "87654321" }
    expect(response).to have_http_status(200)
    expect(response.body).to eq({ :message => "更新成功" }.to_json )

    @reservation.reload
    expect(@reservation.customer_name).to eq("update_name")
    expect(@reservation.customer_phone).to eq("87654321")
  end

  # describe "POST /api/v1/reservations" do
  #   example "POST success without auth_token" do
  #     post "/api/v1/reservations", :params => { :train_number => @train1.number, :seat_number => "1B",
  #                                               :customer_name => "creater", :customer_phone => "12345"}
  #     current_reservation = Reservation.last
  #     # byebug
  #     expect(response).to have_http_status(200)
  #     expect(response).to eq({ :booking_code => current_reservation.booking_code, :reservation_url => api_v1_reservations_url(current_reservation.booking_code) }.to_json)
  #
  #     expect(current_reservation.customer_name).to eq("creater")
  #     expect(current_reservation.customer_phone).to eq("12345")
  #     expect(current_reservation.user_id).to eq(nil)
  #   end
  # end


end
