sudo service rabbitmq-server restart
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export RAILS_ENV=production

#wget --no-check-certificate https://princeberk.com:4000/martinj_princeberk/peatio_v2/raw/master/files/Gemfile.lock
#wget --no-check-certificate https://princeberk.com:4000/martinj_princeberk/peatio_v2/raw/master/files/Gemfile

bundle install --without development test --path vendor/bundle
sudo service nginx stop
bundle exec rake daemons:stop
bundle exec rake assets:clobber
bundle exec rake assets:clean
bundle exec rake assets:precompile
#bundle exec rake db:setup
bundle exec rake daemons:start
sudo service nginx start
bundle exec rake daemons:status
