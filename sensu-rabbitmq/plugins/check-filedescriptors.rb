#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

class Check_fd < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 1024

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 66000

  def run
   val1=''
   val2=''
   samp = `curl -i -u guest:guest http://localhost:15672/api/nodes`
   samp.each_line do |lin|
    if lin.include?('fd_total')
     val1 = lin.split(',')
     val2 =  val1[2].split(':')
     puts "file descriptors available : #{val2[1]}"
    end
   end
   unknown "invalid" if config[:crit] < 10 or config[:warn] < 10

   critical if val2[0].to_i > config[:crit]
   warning if val2[0].to_i > config[:warn]
   ok
  

 end
end
    
