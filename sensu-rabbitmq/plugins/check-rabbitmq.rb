#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'

class Checkrabbitmqserver < Sensu::Plugin::Check::CLI

 def run
   procs = `ps aux`
   running = false
   procs.each_line do |proc|
   running = true if proc.include?('beam')
  if running
   puts 'OK - rabbitmq-server is running'
   exit 0
  else
   puts 'WARNING - rabbitmq-server is NOT running'
   exit 1
 end
end
