#!/usr/bin/ruby
# usage: 
#      cat hosts.txt | xargs -n1 -P4 ./batch-ssh.rb # run 4 processes
#      echo "foo.com" | xargs -n1 ./batch-ssh.rb

require 'net/ssh'

user = 'user'
password = 'password'

command = "ls"

ARGV.each do |a|
  begin
    Net::SSH.start( a, user, :password => password ) do |ssh|
      result = ssh.exec!(command)
      puts "=" * 20 + a + "=" * 20
      puts result
      puts "=" * 20 + a + "=" * 20
    end
  rescue => e
    puts "Caught exception: #{e.message}"
  end
end
