sudo service nginx stop
bundle exec rake daemons:stop

sudo service redis-server restart
sudo service rabbitmq-server restart

sudo /etc/init.d/mysql stop
sudo /etc/init.d/mysql start

bundle exec rake assets:clean
bundle exec rake assets:clobber
bundle exec rake assets:precompile

bundle exec rake daemons:start
sudo service nginx start

bundle exec rake daemons:status
