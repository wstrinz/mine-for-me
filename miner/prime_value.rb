require 'yaml'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def bitcoin_price
  js = open('https://mtgox.com/api/1/BTCUSD/ticker').read
  js = JSON.parse(js)
  js["return"]["avg"]["value"].to_f
end

def interactive
  puts <<-EOF
Profit calculator for beeeeer.org Primecoin mining

Enter your address -
  EOF

  gets
end

if File.exist?("settings.yml")
  settings = YAML.load_file("settings.yml")
  address = settings["primecoin_address"]
  address = interactive unless address
else
  address = interactive
end


# btc_to_usd = 720
btc_to_usd = bitcoin_price()
xpm_to_btc = 0.004

page = open("http://beeeeer.org/user/#{address}").read
payments = JSON.parse(page.scan(/sharehistory=(\[.+\]);/).first.first)

revenue = payments.map{|p| p["reward"]}.reduce(:+)
avg_payout = revenue / payments.size

time_period = (payments.first["time"] - payments.last["time"]).to_f

xpm_per_second = revenue / time_period

per_min = xpm_per_second * 60
per_hour = xpm_per_second * 60 * 60
per_day = xpm_per_second * 60 * 60 * 24
per_month = xpm_per_second * 60 * 60 * 24 * 30

btc_per_month = per_month * xpm_to_btc
usd_per_month = per_month * xpm_to_btc * btc_to_usd

out = <<-EOF

Total Payout: #{revenue}
avg payout: #{avg_payout}

XPM ( = #{xpm_to_btc} BTC )
  per min: #{per_min}
  per hour: #{per_hour}
  per day: #{per_day}
  per month: #{per_month}

BTC ( = #{btc_to_usd} USD )
  btc per month: #{btc_per_month}

USD
  usd per month: #{usd_per_month}

EOF

puts out
# require 'pry'
# binding.pry