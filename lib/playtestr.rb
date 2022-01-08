require 'rubygems'
require 'bundler/setup'

require './lib/logger'

Dir.glob('./lib/playtestr/**/*.rb').each do |file|
  puts file
  require file
end
