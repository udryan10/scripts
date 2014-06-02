#!/usr/bin/ruby
# input parameters to filter on based on a key, value pair
# usage:
# ruby riak-query.rb '{"puppet_role" : "tomcat7", "environment" : "production"}'      

require 'riak' 
require 'json'

@@client = Riak::Client.new(
  :nodes =>
  [
    {
    :host => 'host.com',
    :protocol => 'http',
    :http_port => 8098,
    },
  ]
)


filter_input = JSON.parse(ARGV[0])
map_command = "function(riakObject){var data=JSON.parse(riakObject.values[0].data); if("
puts filter_input

i = 0 
filter_input.each do |index,item|
  map_command += " && " unless i == 0
  map_command += "data.#{index}.toLowerCase() ===\"#{item}\""
  i+=1
end

map_command += "){ return [[riakObject.key,"

i = 0 
filter_input.each do |index,item|
  map_command += "," unless i == 0 
  map_command += "data.#{index}"
  i+=1
end

map_command += "]];} else{ return [];} }"

puts map_command

vms = Riak::MapReduce.new(@@client).add("vms").map(map_command,:keep => true).run
puts vms.to_json
