#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

class Checknodehealth < Sensu::Plugin::Check::CLI

 def run
    val1=''
    val2=''
    samp = `curl -i -u guest:guest http://localhost:15672/api/healthchecks/node`
    samp.each_line do |lin|
     if lin.include?('status')
       val1 = lin.split(':')
       val2 = val1[1].split('}')
       puts val2[0]  
     end
    end
   exit
  end

end
