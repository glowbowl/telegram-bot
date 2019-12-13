# encoding: UTF-8
require 'net/http'
require 'json'

def get_cordinates(city)
  uri_cordinates = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{city}.json?access_token=pk.eyJ1IjoiYW5kcml5c2hrcm9idXQiLCJhIjoiY2p3d3Zicm52MGF6ODRhcG13ZDcxMTAyZCJ9.VybceQpwU5yWONCwQnEgSQ&limit=1")
  res_cordinates = Net::HTTP.get_response(uri_cordinates)

  parsed_cordinates = JSON.parse(res_cordinates.body)
  return parsed_cordinates
end

def get_weather_cordinates(latitude, longitude)
  uri_weather = URI("https://api.darksky.net/forecast/19b4df529329fbc77ac6a2493d56e423/#{latitude},#{longitude}?lang=uk&units=si")
  res_weather = Net::HTTP.get_response(uri_weather)

  parsed_weather = JSON.parse(res_weather.body)
  return parsed_weather
end

def get_weather(address)

  days = {0 => "Неділя",
    1 => "Понеділок",
    2 => "Вівторок",
    3 => "Середа",
    4 => "Четвер",
    5 => "П'ятниця",
    6 => "Субота"}

  city = URI.escape( address, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

  cordinates = get_cordinates(city)

  latitude = cordinates["features"][0]["center"][1]
  longitude = cordinates["features"][0]["center"][0]

  weather = get_weather_cordinates(latitude, longitude)

  w_day_name = days[Time.at(weather["currently"]["time"]).wday]

  w_type = weather["currently"]["precipType"]

  

  case w_type
    when /snow/
      answer = "Погода на #{w_day_name}\n#{address} - #{weather["currently"]["summary"]}🌨☃️\nТемпература - (#{weather["currently"]["temperature"]}℃)"
    when /rain/
      answer = "Погода на #{w_day_name}\n#{address} - #{weather["currently"]["summary"]}🌧☔️\nТемпература - (#{weather["currently"]["temperature"]}℃)"
    when /sleet/
      answer = "Погода на #{w_day_name}\n#{address} - #{weather["currently"]["summary"]}⛈❄️☔️\nТемпература - (#{weather["currently"]["temperature"]}℃)"
    else
      answer = "Погода на #{w_day_name}\n#{address} - #{weather["currently"]["summary"]}🌤\nТемпература - (#{weather["currently"]["temperature"]}℃)"
      puts w_type
      puts latitude
      puts longitude
  end
  return answer
end
