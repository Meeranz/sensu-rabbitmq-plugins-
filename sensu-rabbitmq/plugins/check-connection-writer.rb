#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

class Checkconnectionwriter < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 50000

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 60000

 
  def run
    val1=''
    val2=''
    val =0
    samp = `sudo rabbitmqctl status`
    samp.each_line do |lin|
     if lin.include?('connection_writers')
      val1 = lin.split(',')
      val2 = val1[1].split('}')
      val = val2[0].to_i
      puts val
     end
    end
    
    unknown "invalid" if config[:crit] < 10 or config[:warn] < 10
    critical if val2[0].to_i > config[:crit]
    warning if val2[0].to_i > config[:warn]
    ok
  exit   
  end
end

