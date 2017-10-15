mqtt_connection_observer.rb
====

Usage
----
    
    $ gem install mqtt
    $ git clone https://github.com/yoggy/mqtt_connection_observer.git
    $ cd mqtt_connection_observer
    $ cp config.yaml.sample config.yaml
    $ vi config.yaml

        mqtt_host:      iot.eclipse.org
        mqtt_port:      1883
        mqtt_use_auth:  false
        mqtt_username:  username
        mqtt_password:  password
        mqtt_topic:     topic_name
        check_interval: 10
    
    $ ./mqtt_connection_observer.rb config.yaml | tee log.txt
    
Copyright and license
----
Copyright (c) 2017 yoggy

Released under the [MIT license](LICENSE.txt)
