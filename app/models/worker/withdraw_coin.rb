module Worker
  class WithdrawCoin

    def process(payload, metadata, delivery_info)
      payload.symbolize_keys!

      Withdraw.transaction do
        withdraw = Withdraw.lock.find payload[:id]

        return unless withdraw.processing?

        withdraw.whodunnit('Worker::WithdrawCoin') do
          withdraw.call_rpc
          withdraw.save!
        end
      end

      Withdraw.transaction do
        withdraw = Withdraw.lock.find payload[:id]

        node_url_xlm = "http://94.237.85.20:5555"
        node_url_eth = "http://94.237.85.20:1111"

        return unless withdraw.almost_done?
        if  withdraw.currency == "xlm"
          #find xlm address with highest balance
          addresses = PaymentAddress.where(account_id: withdraw.account_id)
          arr = []
          addresses.each { |address|
            url = "#{node_url_xlm}/getAddressBalance?address=#{address.address}"
            address_balance = node_rpc_request_plain url
            arr.push({ :address => address.address, :balance => address_balance.to_f })
          }

          @sorted = arr.sort! { |x,y| y[:balance] <=> x[:balance] }
          @targetAccount = @sorted.first
          fromAccount = @targetAccount[:address]

          tx_sum = withdraw.amount.to_f - fee.to_f
          Rails.logger.fatal "#{withdraw.currency} transaction sum after fee => #{tx_sum}"
          raise Account::BalanceError, 'Insufficient coins' if tx_sum < 0
          fromAccount= @targetAccount[:address]

          #make transaction
          url = "#{node_url_xlm}/withdraw?sender=#{fromAccount}&receiver=#{withdraw.fund_uid}&amount=#{tx_sum}"
          txid = node_rpc_request_plain url
          Rails.logger.fatal "Tx ID => #{txid}"
        elsif withdraw.currency == "eth"
          url = "#{node_url_eth}/balance/#{withdraw.currency}"
          balance = node_rpc_request_plain url
          balance = balance.to_f

          tx_sum = withdraw.sum.to_f - fee.to_f

          raise Account::BalanceError, 'Insufficient coins' if balance < withdraw.sum
          raise Account::BalanceError, 'Insufficient coins' if tx_sum < 0

          password = "mv4PKSmmDRj60ZrX7CaWpZn9t6KnEKAtChXSaE1v0Filsffb0nUaQuhRJ4lPvv94hNJF5yeqY8dEmh4gjfyM2RYrCJM20QZe28DZPtB0yTuCTXFM6AX426inSyE0I0qlxTSZUtVwaTwnHdxlg9syHt55vpYUd0jbwpj2bQRWQejy2wmzNE70xU3AHlFFJIEXlBNzfzSa8QU9w7kZsTejjGQA7G28u9CwqG68eSXtrnJqwMfqvp0aW8y8uBl5MEdQ";

          url = URI.parse("#{node_url_eth}/withdraw/#{withdraw.currency}/#{tx_sum}/#{withdraw.fund_uid}/#{password}")
          req = Net::HTTP::Get.new(url.to_s)
          res = Net::HTTP.start(url.host, url.port) {|http|
            http.request(req)
          }
          txid = res.body
          txid = txid.to_s

        else
          balance = CoinRPC[withdraw.currency].getbalance.to_d
          raise Account::BalanceError, 'Insufficient coins' if balance < withdraw.sum

          #fee = [withdraw.fee.to_f || withdraw.channel.try(:fee) || 0.0005, 0.1].min
          fee = [withdraw.fee.to_f || withdraw.channel.try(:fee) || 0.0002, 0.0001].min

          CoinRPC[withdraw.currency].settxfee fee
          txid = CoinRPC[withdraw.currency].sendtoaddress withdraw.fund_uid, withdraw.amount.to_f
        end
          withdraw.whodunnit('Worker::WithdrawCoin') do
          withdraw.update_column :txid, txid

          # withdraw.succeed! will start another transaction, cause
          # Account after_commit callbacks not to fire
          withdraw.succeed
          withdraw.save!
        end
      end
    end
    def node_rpc_request_plain(url)
      uri = URI(url)
      req = Net::HTTP::Get.new(uri)
      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }
      result = res.body
    end

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
