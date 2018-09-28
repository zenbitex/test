require 'active_support'
require 'active_support/deprecation'
require 'net/http'
require 'json'
require 'peatio_client'
x = 2

@client = PeatioAPI::Client.new access_key: 'apNM7IAz3U7ClPcsV3RwGD4szj5JzaJcr5N17h7n', secret_key: 's8xIJlGkvlx9kVqcFN6wJzSuTnCqFJET0x5plzcD', endpoint: 'https://beaxchange.com', timeout: 60

def makeOrders

  #p @client.post '/api/v2/orders', market: 'btceur', side: 'sell', volume: @anynumberb, price: @btcsell #1100
  #p @client.post '/api/v2/orders', market: 'btceur', side: 'buy', volume: @anynumberb, price: @btcbuy #900

  #p @client.post '/api/v2/orders', market: 'ltceur', side: 'sell', volume: @anynumberl, price: @ltcsell
  #p @client.post '/api/v2/orders', market: 'ltceur', side: 'buy', volume: @anynumberl, price: @ltcbuy

  #p @client.post '/api/v2/orders', market: 'etheur', side: 'sell', volume: @anynumbere, price: @ethsell
  #p @client.post '/api/v2/orders', market: 'etheur', side: 'buy', volume: @anynumbere, price: @ethbuy

  puts "placed all initial orders"
  sleep 5 
  puts "matching all orders"
  
  p @client.post '/api/v2/orders', market: 'btcxlm', side: 'buy', volume: @anynumberbj, price: @btc_xlm_sell #1100
  p @client.post '/api/v2/orders', market: 'btcxlm', side: 'sell', volume: @anynumberbj, price: @btc_xlm_buy #900

  p @client.post '/api/v2/orders', market: 'ltcxlm', side: 'buy', volume: @anynumberlj, price: @ltc_xlm_sell
  p @client.post '/api/v2/orders', market: 'ltcxlm', side: 'sell', volume: @anynumberlj, price: @ltc_xlm_buy

  p @client.post '/api/v2/orders', market: 'ethxlm', side: 'buy', volume: @anynumberej, price: @eth_xlm_sell
  p @client.post '/api/v2/orders', market: 'ethxlm', side: 'sell', volume: @anynumberej, price: @eth_xlm_buy

  p @client.post '/api/v2/orders', market: 'ethltc', side: 'buy', volume: @anynumberel, price: @eth_ltc_sell
  p @client.post '/api/v2/orders', market: 'ethltc', side: 'sell', volume: @anynumberel, price: @eth_ltc_buy

  p @client.post '/api/v2/orders', market: 'btceth', side: 'buy', volume: @anynumberbe, price: @btc_eth_sell
  p @client.post '/api/v2/orders', market: 'btceth', side: 'sell', volume: @anynumberbe, price: @btc_eth_buy

  p @client.post '/api/v2/orders', market: 'btcltc', side: 'buy', volume: @anynumberbl, price: @btc_ltc_sell
  p @client.post '/api/v2/orders', market: 'btcltc', side: 'sell', volume: @anynumberbl, price: @btc_ltc_buy

  sleep 5
  puts "clearing all orders to restart"
  p @client.post '/api/v2/orders/clear'
end

@btc_ltc_old = 0;
@btc_eth_old = 0;
@btc_xlm_old = 0;
@eth_ltc_old = 0;
@eth_xlm_old = 0;
@ltc_xlm_old = 0;

until x==9 do

url = 'https://api.coinmarketcap.com/v1/ticker/bitcoin/?convert=xlm'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@btc_xlm = response[0]["price_xlm"].to_f

url = 'https://api.coinmarketcap.com/v1/ticker/litecoin/?convert=xlm'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@ltc_xlm = response[0]["price_xlm"].to_f

url = 'https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=xlm'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@eth_xlm = response[0]["price_xlm"].to_f

url = 'https://api.coinmarketcap.com/v1/ticker/bitcoin/?convert=ETH'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@btc_eth = response[0]["price_eth"].to_f

url = 'https://api.coinmarketcap.com/v1/ticker/bitcoin/?convert=LTC'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@btc_ltc = response[0]["price_ltc"].to_f

url = 'https://api.coinmarketcap.com/v1/ticker/ethereum/?convert=LTC'
uri = URI(url)
response = Net::HTTP.get(uri)
response = JSON.parse(response)
@eth_ltc = response[0]["price_ltc"].to_f

#0.7% btc
#eth 1.06 %
#ltc 2.23%
#xrp 9%
#dsh 1.03%

@spread = 0.005

def sell_btc_xlm
  puts "SELL BTC xlm -------------------------------------"
  @btc_xlm_buy = @btc_xlm-(@btc_xlm*@spread)
  @btc_xlm_sell = @btc_xlm+(@btc_xlm*@spread)
end

def sell_btc_eth
  puts "SELL BTC ETH -------------------------------------"
  @btc_eth_buy = @btc_eth-(@btc_eth*@spread)
  @btc_eth_sell = @btc_eth+(@btc_eth*@spread)
end

def sell_btc_ltc
  puts "SELL BTC LTC -------------------------------------"
  @btc_ltc_buy = @btc_ltc-(@btc_ltc*@spread)
  @btc_ltc_sell = @btc_ltc+(@btc_ltc*@spread)
end

def sell_eth_ltc
  puts "SELL ETH LTC -------------------------------------"
  @eth_ltc_buy = @eth_ltc-(@eth_ltc*@spread)
  @eth_ltc_sell = @eth_ltc+(@eth_ltc*@spread)
end

def sell_eth_xlm
  puts "SELL ETH xlm -------------------------------------"
  @eth_xlm_buy = @eth_xlm-(@eth_xlm*@spread)
  @eth_xlm_sell = @eth_xlm+(@eth_xlm*@spread)
end

def sell_ltc_xlm
  puts "SELL ETH xlm -------------------------------------"
  @ltc_xlm_buy = @ltc_xlm-(@ltc_xlm*@spread)
  @ltc_xlm_sell = @ltc_xlm+(@ltc_xlm*@spread)
end




def buy_btc_xlm
  puts "BUY BTC xlm -------------------------------------"
  @btc_xlm_buy = @btc_xlm+(@btc_xlm*@spread)
  @btc_xlm_sell = @btc_xlm-(@btc_xlm*@spread)
end

def buy_btc_eth
  puts "BUY BTC ETH -------------------------------------"
  @btc_eth_buy = @btc_eth+(@btc_eth*@spread)
  @btc_eth_sell = @btc_eth-(@btc_eth*@spread)
end

def buy_btc_ltc
  puts "BUY BTC LTC -------------------------------------"
  @btc_ltc_buy = @btc_ltc+(@btc_ltc*@spread)
  @btc_ltc_sell = @btc_ltc-(@btc_ltc*@spread)
end

def buy_eth_ltc
  puts "BUY ETH LTC -------------------------------------"
  @eth_ltc_buy = @eth_ltc+(@eth_ltc*@spread)
  @eth_ltc_sell = @eth_ltc-(@eth_ltc*@spread)
end

def buy_eth_xlm
  puts "BUY ETH xlm -------------------------------------"
  @eth_xlm_buy = @eth_xlm+(@eth_xlm*@spread)
  @eth_xlm_sell = @eth_xlm-(@eth_xlm*@spread)
end

def buy_ltc_xlm
  puts "BUY ETH xlm -------------------------------------"
  @ltc_xlm_buy = @ltc_xlm+(@ltc_xlm*@spread)
  @ltc_xlm_sell = @ltc_xlm-(@ltc_xlm*@spread)
end

#if btc>btcold then red else green 
if @btc_ltc_old < @btc_ltc
  sell_btc_ltc
else 
  buy_btc_ltc
end

#if btc>btcold then red else green
if @btc_eth_old < @btc_eth
  sell_btc_eth
else
  buy_btc_eth
end

#if btc>btcold then red else green
if @btc_xlm_old < @btc_xlm
  sell_btc_xlm
else
  buy_btc_xlm
end

if @eth_ltc_old < @eth_ltc
  sell_eth_ltc
else
  buy_eth_ltc
end

if @eth_xlm_old < @eth_xlm
  sell_eth_xlm
else
  buy_eth_xlm
end

if @ltc_xlm_old < @ltc_xlm
  sell_ltc_xlm
else
  buy_ltc_xlm
end

@btc_ltc_old = @btc_ltc
@btc_eth_old = @btc_eth
@btc_xlm_old = @btc_xlm
@eth_ltc_old = @eth_ltc
@eth_xlm_old = @eth_xlm
@ltc_xlm_old = @ltc_xlm

# xrpbuy = xrp+(xrp*buyxrpspread)
# xrpsell = xrp+(xrp*sellxrpspread)

# dshbuy =dsh+(dsh*buydshspread)
# dshsell = dsh+(dsh*selldshspread)

@anynumberbl=rand(0.005..0.02).round(2)
@anynumberbe=rand(0.005..0.02).round(2)
@anynumberbj=rand(0.005..0.02).round(2)
@anynumberel=rand(0.005..0.02).round(2)
@anynumberej=rand(0.005..0.02).round(2)
@anynumberlj=rand(0.005..0.02).round(2)

makeOrders

end

