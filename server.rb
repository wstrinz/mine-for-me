require 'sinatra'

configure do
  set :wallet, "1Fd6pkrvZsrtmfpaonP5cjKrEwf8mGdZWy"
end

get '/' do
  @wallet = settings.wallet
  erb :mine
end