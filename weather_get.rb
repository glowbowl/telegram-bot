# encoding: UTF-8
require 'net/http'
require 'json'
def get_weather(address)
  city = URI.escape( address, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

  uri_cordinates = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{city}.json?access_token=pk.eyJ1IjoiYW5kcml5c2hrcm9idXQiLCJhIjoiY2p3d3Zicm52MGF6ODRhcG13ZDcxMTAyZCJ9.VybceQpwU5yWONCwQnEgSQ&limit=1")
  res_cordinates = Net::HTTP.get_response(uri_cordinates)

  parsed_cordinates = JSON.parse(res_cordinates.body)

  latitude = parsed_cordinates["features"][0]["center"][1]
  longitude = parsed_cordinates["features"][0]["center"][0]

  uri_weather = URI("https://api.darksky.net/forecast/19b4df529329fbc77ac6a2493d56e423/#{latitude},#{longitude}?lang=uk&units=si")
  res_weather = Net::HTTP.get_response(uri_weather)
  parsed_weather = JSON.parse(res_weather.body)
  return parsed_weather["currently"]["summary"]
  #puts parsed_weather
end
