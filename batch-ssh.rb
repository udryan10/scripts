#!/usr/bin/ruby
# usage: 
#      cat hosts.txt | xargs -n1 -P4 ./batch-ssh.rb # run 4 processes
#      echo "foo.com" | xargs -n1 ./batch-ssh.rb
require 'net/ssh'

user = 'user'
password = 'password'

command = "hostname"

ARGV.each do |a|
  begin
    Net::SSH.start( a, user, :password => password ) do |ssh|
      ssh.open_channel do |channel|
        channel.on_data do |ch, data|
          puts "=" * 20 + a + "=" * 20
          puts data
          puts "=" * 20 + a + "=" * 20
        end
        channel.request_pty
        channel.exec command
      end
    end
  rescue => e
    puts "Caught exception: #{e.message}"
  end
end
