#!/bin/sh

mv rails rails-old
rbenv gemset init new-rails
gem install rails

bundle exec rails new registry --database postgresql --skip-bundle --skip-keeps

mv registry rails
rm -rf rails/.git

rsync -avu \
    --exclude=log/ \
    --exclude=vendor/ \
    --exclude=tmp/ \
    --exclude=public/coverage \
  rails-old/ rails/

touch rails/vendor/.keep rails/log/.keep

git st
