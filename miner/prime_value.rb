require 'yaml'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def bitcoin_price
  if @bitcoin_price
    @bitcoin_price
  else
    js = open('https://mtgox.com/api/1/BTCUSD/ticker').read
    js = JSON.parse(js)
    @bitcoin_price = js["return"]["last"]["value"].to_f
  end
end

def xpm_price
  @xpm_price ||= JSON.parse(open("https://btc-e.com/api/2/xpm_btc/ticker").read)["ticker"]["last"]
end

def interactive
  puts <<-EOF
Profit calculator for beeeeer.org Primecoin mining

Enter your address -
  EOF

  gets
end

def summary_string(address,range=0..-1)

  btc_to_usd = bitcoin_price
  xpm_to_btc = xpm_price

  page = open("http://beeeeer.org/user/#{address}").read


  @payments ||= JSON.parse(page.scan(/sharehistory=(\[.+\]);/).first.first)
  payments = @payments[range]
  revenue = payments.map{|p| p["reward"]}.reduce(:+)
  time_period = (payments.first["time"] - payments.last["time"]).to_f

  avg_payout = revenue / payments.size
  xpm_per_second = revenue / time_period

  per_min = xpm_per_second * 60
  per_hour = xpm_per_second * 60 * 60
  per_day = xpm_per_second * 60 * 60 * 24
  per_month = xpm_per_second * 60 * 60 * 24 * 30

  btc_per_month = per_month * xpm_to_btc
  btc_per_day = per_day * xpm_to_btc

  usd_per_month = per_month * xpm_to_btc * btc_to_usd

  <<-EOF

Time period: #{time_period / 60} min    (#{time_period / 60 / 60} hours)

Total Payout: #{revenue}
Avg Payout: #{avg_payout}

XPM ( = #{xpm_to_btc} BTC )
  per min: #{per_min}
  per hour: #{per_hour}
  per day: #{per_day}
  per month: #{per_month}

BTC ( = #{btc_to_usd} USD )
  btc per day: #{btc_per_month / 30}
  btc per month: #{btc_per_month}

USD
  usd per day: #{usd_per_month / 30}
  usd per month: #{usd_per_month}

  EOF
end

if File.exist?("settings.yml")
  settings = YAML.load_file("settings.yml")
  address = settings["primecoin_address"]
  address = interactive unless address
else
  address = interactive
end

puts "Last 50 payouts"
puts summary_string(address,0..49)

puts "All Payouts"
puts summary_string(address)