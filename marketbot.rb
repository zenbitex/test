require 'active_support'
require 'active_support/deprecation'
require 'net/http'
require 'json'
require 'peatio_client'
x = 2
@client = PeatioAPI::Client.new access_key: 'gOfaIC7okZZHatCLP6bxFoyxcVBKx262BLcMrHZf', secret_key: 'EqQBpg0TizwzJha0ZzyOn7V31GyEE9Ms1hXlNg7O', endpoint: 'https://beaxchange.com', timeout: 60

def makeOrders

  p @client.post '/api/v2/orders', market: 'btcaud', side: 'sell', volume: @anynumberb, price: @btcsell #1100
  p @client.post '/api/v2/orders', market: 'btcaud', side: 'buy', volume: @anynumberb, price: @btcbuy #900

  p @client.post '/api/v2/orders', market: 'ltcaud', side: 'sell', volume: @anynumberl, price: @ltcsell
  p @client.post '/api/v2/orders', market: 'ltcaud', side: 'buy', volume: @anynumberl, price: @ltcbuy

  #p @client.post '/api/v2/orders', market: 'etheur', side: 'sell', volume: @anynumbere, price: @ethsell
  #p @client.post '/api/v2/orders', market: 'etheur', side: 'buy', volume: @anynumbere, price: @ethbuy

  puts "placed all initial orders"
  sleep 20
  puts "matching all orders"

  p @client.post '/api/v2/orders', market: 'btcaud', side: 'buy', volume: @anynumberb, price: @btcsell #1100
  p @client.post '/api/v2/orders', market: 'btcaud', side: 'sell', volume: @anynumberb, price: @btcbuy #900

  p @client.post '/api/v2/orders', market: 'ltcaud', side: 'buy', volume: @anynumberl, price: @ltcsell
  p @client.post '/api/v2/orders', market: 'ltcaud', side: 'sell', volume: @anynumberl, price: @ltcbuy

  #p @client.post '/api/v2/orders', market: 'etheur', side: 'buy', volume: @anynumbere, price: @ethsell
  #p @client.post '/api/v2/orders', market: 'etheur', side: 'sell', volume: @anynumbere, price: @ethbuy
  sleep 20
  puts "clearing all orders to restart"
  p @client.post '/api/v2/orders/clear'
end

@btcPriceOld = 0;
#@ethPriceOld = 0;
@ltcPriceOld = 0;

until x==9 do

url = 'https://api.coinmarketcap.com/v1/ticker/bitcoin/?convert=EUR'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@btc = response[0]["price_eur"].to_f

url = 'https://api.coinmarketcap.com/v1/ticker/litecoin/?convert=EUR'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@ltc = response[0]["price_eur"].to_f

#my_ordersurl = 'https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=EUR'
#uri = URI(url)
#response = Net::HTTP.get(uri)
#response = JSON.parse(response)
#@eth = response[0]["price_eur"].to_f

#0.7% btc
#eth 1.06 %
#ltc 2.23%
#xrp 9%
#dsh 1.03%

@sellbtcspread=0.0035
@buybtcspread=0.0035
#@buyethspread=0.0053
#@sellethspread=0.0053
@buyltcspread=0.01115
@sellltcspread=0.01115

def redBTC
  puts "RED -------------------------------------"
  @btcbuy = @btc-(@btc*@buybtcspread)
  @btcsell = @btc+(@btc*@sellbtcspread)
end

def redLTC
  puts "RED -------------------------------------"
  @ltcbuy = @ltc-(@ltc*@buyltcspread)
  @ltcsell = @ltc+(@ltc*@sellltcspread)
end

def greenBTC
  puts "GREEN -------------------------------------"
  @btcbuy = @btc+(@btc*@buybtcspread)
  @btcsell = @btc-(@btc*@sellbtcspread)
end

#def greenETH
#  puts "GREEN -------------------------------------"
#  @ethbuy = @eth+(@eth*@buyethspread)
#  @ethsell = @eth-(@eth*@sellethspread)
#end

def greenLTC
  puts "GREEN -------------------------------------"
  @ltcbuy = @ltc+(@ltc*@buyltcspread)
  @ltcsell = @ltc-(@ltc*@sellltcspread)
end

#if btc>btcold then red else green
if @btcPriceOld < @btc
  redBTC
else
  greenBTC
end

#if btc>btcold then red else green
#if @ethPriceOld < @eth
#  redETH
#else
#  greenETH
#end

#if btc>btcold then red else green
if @ltcPriceOld < @ltc
  redLTC
else
  greenLTC
end

@btcPriceOld = @btc
#@ethPriceOld = @eth
@ltcPriceOld = @ltc
# xrpbuy = xrp+(xrp*buyxrpspread)
# xrpsell = xrp+(xrp*sellxrpspread)

# dshbuy =dsh+(dsh*buydshspread)
# dshsell = dsh+(dsh*selldshspread)

@anynumberb=rand(0.1..5.0).round(2)
@anynumberl=rand(0.1..5.0).round(2)
#@anynumbere=rand(0.1..5.0).round(2)

makeOrders

end

