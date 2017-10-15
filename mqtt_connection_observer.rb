#!/usr/bin/ruby
require 'mqtt'
require 'yaml'
require 'ostruct'
require 'digest/sha1'
require 'pp'

$stdout.sync = true
Dir.chdir(File.dirname($0))

$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG


def check()
  conn_opts = {
    remote_host: $conf.mqtt_host
  }

  if !$conf.mqtt_port.nil? 
    conn_opts["remote_port"] = $conf.mqtt_port
  end

  if $conf.mqtt_use_auth == true
    conn_opts["username"] = $conf.mqtt_username
    conn_opts["password"] = $conf.mqtt_password
  end

  begin
    MQTT::Client.connect(conn_opts) do |c|
      c.subscribe($conf.mqtt_topic)

      msg_send = Digest::SHA1.hexdigest("seed#{rand}")
      c.publish($conf.mqtt_topic, msg_send)

      Timeout.timeout(3) do
        (t, msg_recv) = c.get # [topic, msg]
        return true if msg_send == msg_recv
      end

    end
  rescue Exception => e
    return false
  end

  false
end

def usage
  puts "usage : #{$0} config.yaml"
  puts ""
  exit(1)
end

def main
  usage if ARGV.size != 1

  $conf = OpenStruct.new(YAML.load_file(ARGV[0]))

  loop do
    rv = check()
    if rv 
      $log.info("OK")
    else
      $log.error("NG")
    end

    sleep $conf.check_interval
  end
end

main

