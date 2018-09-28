require 'active_support'
require 'active_support/deprecation'
require 'net/http'
require 'json'
require 'peatio_client'
require 'binance'

# binance api
# yq3n58ybqTBSi1KKCyGx3BB23OS6KRGzTm7Qvf6galMS21tSfhCdxVVpsOXqjiuL
# MqQU9JCAb5rYuDdqpa7OUN3RCovWjV5MJPMszUaDOdTUl33CBhINQxlhHvaEJF50

# peatio api
# IQfGpxF6abs6SrLSX1xWkqx3b7O1jPA5jo8fwZco
# WWrcUbbFRV5xyBwrCx2bbOu3b9hOscyUMvnibhfe

@peatio_client = PeatioAPI::Client.new access_key: 'r7epRTgn6vPtO6MqIo0bDe9VuJPeZoqO8qfDR9KS', secret_key: 'ol17xxQv4tudlvdiOw2FayydtJwHvEN9y0Y4a3Zw', endpoint: 'http://173.212.220.163', timeout: 60
@binance_client = Binance::Client::REST.new api_key: 'rBEdwLVMYUeA0ivg5WTsfYcWuEytFQTnbYc80p8yU9a6g5jU1qUtaW8oj6PfCtlK', secret_key: 'qAx2Hgx09qvn7AloxSDLV4q2IFbjfGv0hD2lBU5nk0U65fvuBp8QHzCJE9yixYoR'

while true
  pair = 'ltcbtc';

  puts '==============================================='
  puts '==================START LOOP==================='
  puts '==============================================='
  puts 'CURRENT PAIR: ' + pair.to_s.upcase

  puts '-----------------------------------------------'

  puts 'clear all orders posted'
  @peatio_client.post '/api/v2/orders/clear'

  puts '-----------------------------------------------'

  puts 'get latest orders from binance'
  order = @binance_client.twenty_four_hour symbol: pair.to_s.upcase
  puts order

  puts '-----------------------------------------------'

  puts 'orders from binance - try to match on peatio'
  sell = @peatio_client.post '/api/v2/orders', market: pair, side: 'sell', volume: order['bidQty'].to_f, price: order['bidPrice']
  puts sell

  @peatio_client.post '/api/v2/orders/clear'
  sleep(2)

  buy = @peatio_client.post '/api/v2/orders', market: pair, side: 'buy', volume: order['askQty'].to_f, price: order['askPrice']
  puts buy

  puts '-----------------------------------------------'

  puts 'sleep for 0.5 second to update trades'
  sleep(0.5)

  puts '-----------------------------------------------'

  my_trades =  @peatio_client.get '/api/v2/trades/my', market: pair

  # new values
  bidQtyNew = 0
  bidPriceNew = 0
  askQtyNew = 0
  askPriceNew = 0

  my_trades.each do |trade|
    # filled sell orders
    if Time.parse(trade['created_at']).to_i > Time.parse(sell['created_at']).to_i
      time = Time.parse(trade['created_at']).to_i - Time.parse(sell['created_at']).to_i
    elsif Time.parse(trade['created_at']).to_i < Time.parse(sell['created_at']).to_i
      time = Time.parse(sell['created_at']).to_i - Time.parse(trade['created_at']).to_i
    else
      time = 0
    end

    # filled buy orders
    if Time.parse(trade['created_at']).to_i > Time.parse(buy['created_at']).to_i
      time = Time.parse(trade['created_at']).to_i - Time.parse(buy['created_at']).to_i
    elsif Time.parse(trade['created_at']).to_i < Time.parse(buy['created_at']).to_i
      time = Time.parse(buy['created_at']).to_i - Time.parse(trade['created_at']).to_i
    else
      time = 0
    end

    if time <= 5
      puts trade
      if trade['order_id'].to_i == sell['id'].to_i
        # filled buy order on peatio
        puts 'buy order filled'
        bidQtyNew = bidQtyNew.to_f + trade['volume'].to_f
        bidPriceNew = trade['price'].to_f
      else
        # filled sell order on peatio
        puts 'sell order filled'
        askQtyNew = askQtyNew.to_f + trade['volume'].to_f
        askPriceNew = trade['price'].to_f
      end
    end
  end

  puts 'To buy: ' + bidQtyNew.to_s
  puts 'To sell: ' + askQtyNew.to_s

  # puts my_trades;

  # puts sell
  # puts buy

  puts '-----------------------------------------------'

  if bidQtyNew.to_f > 0 || askQtyNew.to_f > 0
    # p @binance_client.create_order! symbol: pair.to_s.upcase, side: 'BUY', type: 'LIMIT', time_in_force: 'GTC', quantity: bidQtyNew, price: bidPriceNew
    # p @binance_client.create_order! symbol: pair.to_s.upcase, side: 'SELL', type: 'LIMIT', time_in_force: 'GTC', quantity: askQtyNew, price: askPriceNew
    p 'matching on binance'
  else
    p 'matching orders so price can be updated'
    p @peatio_client.post '/api/v2/orders', market: pair, side: 'sell', volume: order['askQty'].to_f*0.1, price: order['askPrice']
    p @peatio_client.post '/api/v2/orders', market: pair, side: 'buy', volume: order['askQty'].to_f*0.1, price: order['askPrice']
    @peatio_client.post '/api/v2/orders/clear'
    sleep(2)
    p @peatio_client.post '/api/v2/orders', market: pair, side: 'buy', volume: order['bidQty'].to_f*0.4, price: order['bidPrice']
    p @peatio_client.post '/api/v2/orders', market: pair, side: 'sell', volume: order['bidQty'].to_f*0.4, price: order['bidPrice']
    @peatio_client.post '/api/v2/orders/clear'
  end


  puts '-----------------------------------------------'

  puts 'clear all orders posted'
  @peatio_client.post '/api/v2/orders/clear'

  puts '-----------------------------------------------'

  puts 'sleep for 5 second then continue again from start'
  sleep(5)

  puts '-----------------------------------------------'
end

