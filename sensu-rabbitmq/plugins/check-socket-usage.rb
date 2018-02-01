#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

class Check_nodessocket < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 900

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 1000

  def run
   val1=''
   val2=''
   samp = `curl -i -u guest:guest http://localhost:15672/api/nodes`
   samp.each_line do |lin|
    if lin.include?('sockets_total')
     val1 = lin.split(',')
     val2 =  val1[3].split(':')
     puts "total available sockets : #{val2[1]}"
    end
   end
   unknown "invalid" if config[:crit] < 10 or config[:warn] < 10

   critical if val2[0].to_i > config[:crit]
   warning if val2[0].to_i > config[:warn]
   ok
  

 end
end
    
