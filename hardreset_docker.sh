export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export RAILS_ENV=production

sudo service nginx stop
bundle exec rake daemons:stop
#mysql -uroot -p -e "drop database peatio_production"

#bundle exec rake db:setup
bundle exec rake assets:clobber
bundle exec rake assets:clean
bundle exec rake assets:precompile
bundle exec rake daemons:start
sudo service nginx start
bundle exec rake daemons:status
