class CitiesController < ApplicationController
  def index
    @cities = City.all
  end

  def update_temp
    city = City.find(params[:id])

    response = RestClient.get "http://v.juhe.cn/weather/index",
                              :params => { :cityname => city.juhe_id, :key => "2423989a04289d59792c50a90d890a8d"  }
    data = JSON.parse(response.body)

    city.update( :current_temp => data["result"]["sk"]["temp"] )
    #city.update ( :current_temp => data["result"]["sk"]["temp"] )

    redirect_to cities_path
  end
end
