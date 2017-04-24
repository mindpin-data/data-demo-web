#! /usr/bin/env bash

bundle install

rake assets:precompile

rake db:create RAILS_ENV=production

rake db:migrate RAILS_ENV=production