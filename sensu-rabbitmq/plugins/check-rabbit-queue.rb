#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

class Checkrabbitmqqueue < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 1

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 2



 def run
   val1=''
   val2=0
   val3=0
   samp = `curl -i -u guest:guest http://localhost:15672/api/queues`
   samp.each_line do |lin|
    if lin.include?('avg_ingress_rate')
     val1 = lin.split(',')
     val2 =  val1[47].split(':')
     val3 = val1[46].split(':')
     puts "avg_egress_rate  :#{val2[1]}"
     puts "avg_ingress_rate :#{val3[1]}"
 
    end
   end
  
   critical if val3[0].to_i > config[:crit]
   warning if val3[0].to_i > config[:warn]
   ok
   critical if val2[0].to_i > config[:crit]
   warning if val2[0].to_i > config[:warn]
   ok

  end
end
