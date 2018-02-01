#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

class Checkconnectionreader < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 1000

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 150000

 
  def run
    val1=''
    val2=''
    samp = `sudo rabbitmqctl status`
    samp.each_line do |lin|
     if lin.include?('connection_readers')
      val1 = lin.split(',')
      val2 = val1[1].split('}')
     end
    end
    unknown "invalid" if config[:crit] < 10 or config[:warn] < 10

    message "#{val2[0].to_i} is value"
    
    critical if val2[0].to_i > config[:crit]
    warning if val2[0].to_i > config[:warn]
    ok
  end
end
