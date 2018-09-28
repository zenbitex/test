FROM="EUR"
TO="AUD"
#FILES=$(find | grep 'text.txt\|test.txt')
# FILES=$(text.txt | test.txt)
FILES=$(find /home/deploy/peatio/current | grep '.travis.application.yml\|.travis.currencies.yml\|travis.markets.yml\|market.rb\|order.rb\|accounts_directives.js.coffee\|withdraw.js.coffee\|assets_controller.rb\|mailer_helper.rb\|market.rb\|api_v2.en.html.slim\|api_v2.zh-CN.html.slim\|websocket_api.html.slim\|index.html.slim\|daily_stats.html.erb\|banks.yml.example\|currencies.yml\|currencies.yml.example\|currencies.yml~\|deposit_channels.yml\|client.cs.yml\|client.el.yml\|client.en.yml\|client.it.yml\|client.ko.yml\|client.ru_RU.yml\|client.zh-CN.yml\|client.zh-TW.yml\|server.cs.yml\|server.en.yml\|server.en.yml~\|server.ko.yml\|server.ru_RU.yml\|server.zh-CN.yml\|markets.yml\|markets.yml.example\|markets.yml~\|withdraw_channels.yml\|dump.rdb\|helpers.rb\|sweat_factory.rb\|emu.rake\|order.rake\|order.rake~\|replay.rake\|stats.rake\|deposit.html\|deposit_cny.html\|withdraw.html\|withdraw_cny.html\|deposits_spec.rb\|member_spec.rb\|members_spec.rb\|order_books_spec.rb\|orders_spec.rb\|tickers_spec.rb\|trades_spec.rb\|assets_controller_spec.rb\|fund_sources_controller_spec.rb\|markets_controller_spec.rb\|order_asks_controller_spec.rb\|order_bids_controller_spec.rb\|account.rb\|fund_source.rb\|orders.rb\|payment_addresses.rb\|trade.rb\|withdraw.rb\|withdraw_spec.rb\|market_spec.rb\|market_trade_history_spec.rb\|withdraw_spec.rb\|banks.yml\|currencies.yml\|deposit_channels.yml\|markets.yml\|withdraw_channels.yml\|bank_spec.rb\|fund_source_spec.rb\|global_spec.rb\|market_spec.rb\|engine_spec.rb\|executor_spec.rb\|order_book_manager_spec.rb\|order_book_spec.rb\|order_ask_spec.rb\|order_bid_spec.rb\|order_spec.rb\|trade_spec.rb\|matching_spec.rb\|slave_book_spec.rb\|matching_helper.rb')
echo ""
echo "$FROM => $TO"
echo "-----------------------------------------------"
for SUBJECT_FILE in ${FILES//\\n/ } ; do
    echo "$SUBJECT_FILE"
    vim "$SUBJECT_FILE" -c "%s/$FROM/$TO/gc" -c "wq"
done
echo "-----------------------------------------------"
echo ""
echo "Done!"

