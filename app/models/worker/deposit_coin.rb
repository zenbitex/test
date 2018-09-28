module Worker
  class DepositCoin

    def process(payload, metadata, delivery_info)
      payload.symbolize_keys!

      sleep 0.5 # nothing result without sleep by query gettransaction api

      channel_key = payload[:channel_key]
      txid = payload[:txid]

      channel = DepositChannel.find_by_key(channel_key)
      if channel_key == 'stellarcoin'
         raw = get_raw_eth txid
         raw.symbolize_keys!
         deposit_xlm!(channel, txid, 1, raw)
      elsif channel_key == 'ether'
        raw = get_raw_eth txid
        raw.symbolize_keys!
        deposit_eth!(channel, txid, 1, raw)
      end
      raw     = get_raw channel, txid
      raw[:details].each_with_index do |detail, i|
        detail.symbolize_keys!
        deposit!(channel, txid, i, raw, detail)
      end
    end

    def deposit!(channel, txid, txout, raw, detail)
      return if detail[:account] != "payment" || detail[:category] != "receive"

      ActiveRecord::Base.transaction do
        unless PaymentAddress.where(currency: channel.currency_obj.id, address: detail[:address]).first
          Rails.logger.info "Deposit address not found, skip. txid: #{txid}, txout: #{txout}, address: #{detail[:address]}, amount: #{detail[:amount]}"
          return
        end

        return if PaymentTransaction::Normal.where(txid: txid, txout: txout).first

        tx = PaymentTransaction::Normal.create! \
          txid: txid,
          txout: txout,
          address: detail[:address],
          amount: detail[:amount].to_s.to_d,
          confirmations: raw[:confirmations],
          receive_at: Time.at(raw[:timereceived]).to_datetime,
          currency: channel.currency

        deposit = channel.kls.create! \
          payment_transaction_id: tx.id,
          txid: tx.txid,
          txout: tx.txout,
          amount: tx.amount,
          member: tx.member,
          account: tx.account,
          currency: tx.currency,
          confirmations: tx.confirmations

        deposit.submit!
      end
    rescue
      Rails.logger.error "Failed to deposit: #{$!}"
      Rails.logger.error "txid: #{txid}, txout: #{txout}, detail: #{detail.inspect}"
      Rails.logger.error $!.backtrace.join("\n")
    end

    ################# DEPOSIT STELLAR ################################
    def deposit_xlm!(channel, txid, txout, raw)
      return if raw["type"] != "payment" && raw["type"] != "create_account"

      ActiveRecord::Base.transaction do
        unless PaymentAddress.where(currency: channel.currency_obj.id, address: raw["address"]).first
          Rails.logger.info 'Deposit address not found, skip. txid: #{raw["txid"]}, address: #{raw["address"]}, amount: #{raw["amount"]}'
          return
        end

        return if PaymentTransaction::Normal.where(txid: txid, txout: txout,).first

        tx = PaymentTransaction::Normal.create! \
          txid: txid,
          txout: 6,
          address: raw["address"],
          amount: raw["amount"].to_s.to_d,
          confirmations: raw["confirmations"],
          receive_at: Time.now.to_datetime,
          currency: channel.currency

        deposit = channel.kls.create! \
          payment_transaction_id: tx.id,
          txid: tx.txid,
          txout: 6,
          amount: tx.amount,
          member: tx.member,
          account: tx.account,
          currency: tx.currency,
          confirmations: tx.confirmations

            Rails.logger.info "Deposit #{deposit}"
        deposit.submit!
        deposit.accept!
      end
    rescue
      Rails.logger.error "Failed to deposit: #{$!}"
      Rails.logger.error "txid: #{txid}"
      Rails.logger.error $!.backtrace.join("\n")
    end

    ################# DEPOSIT ETHEREUM ################################
    def deposit_eth!(channel, txid, txout, raw)
      ActiveRecord::Base.transaction do
        unless PaymentAddress.where(currency: channel.currency_obj.id, address: raw[:to]).first
          Rails.logger.info "Deposit address not found, skip. txid: #{txid}, txout: #{txout}, address: #{raw[:to]}, amount: #{raw[:value].to_i(16) / 1e18}"
          return
        end
        return if PaymentTransaction::Normal.where(txid: txid, txout: txout).first
        ############################
        confirmations = CoinRPC["eth"].eth_blockNumber.to_i(16) - raw[:blockNumber].to_i(16)
        #############################
        tx = PaymentTransaction::Normal.create! \
          txid: txid,
          txout: txout,
          address: raw[:to],
          amount: (raw[:value].to_i(16) / 1e18).to_d,
          confirmations: confirmations,
          receive_at: Time.now.to_datetime,
          currency: channel.currency

        deposit = channel.kls.create! \
          payment_transaction_id: tx.id,
          txid: tx.txid,
          txout: tx.txout,
          amount: tx.amount,
          member: tx.member,
          account: tx.account,
          currency: tx.currency,
          confirmations: tx.confirmations

        deposit.submit!
        deposit.accept!
      end
    rescue
      Rails.logger.error "Failed to deposit: #{$!}"
      Rails.logger.error "txid: #{txid}, txout: #{txout}, detail: #{raw.inspect}"
      Rails.logger.error $!.backtrace.join("\n")
    end

    def get_raw(channel, txid)
      channel.currency_obj.api.gettransaction(txid)
    end

    ############## GET TRANSACTION DETAILS FOR STELLAR #################
    def get_raw_xlm(channel, txid)
      url = "http://94.237.85.20:5555/getLastTransaction?transaction=#{txid}"
      txid = node_rpc_request_json url
    end

    def get_raw_litecoin(channel, txid)
      Rails.logger.fatal channel.inspect
      Rails.logger.fatal "++++++++++++++++++++++"
      channel.currency_obj.api.getrawtransaction(txid, true)
    end

    ############## HELPER FOR MAKING REQUESTS TO NODEJS SERVER #################
    def node_rpc_request_plain(url)
      uri = URI(url)
      req = Net::HTTP::Get.new(uri)
      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }
      result = res.body
    end

    ############## HELPER FOR MAKING REQUESTS TO NODEJS SERVER AND PARSING JSON #################
    def node_rpc_request_json(url)
      uri = URI(url)
      req = Net::HTTP::Get.new(uri)
      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }
      result = JSON.parse(res.body)
    end
  end
end
