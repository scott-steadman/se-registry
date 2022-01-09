#!/bin/sh

rbenv gemset delete `cat .ruby-version` new-rails
rm .rbenv-gemsets
