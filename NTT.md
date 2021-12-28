# NTT Data customizations

## Execution

### SSH Keys

TODO

### Configuration

TODO

### Playbook

Execute the following command

      /ansible-playbook -i inventories/opensearch/hosts opensearch.yml --extra-vars "admin_password=Test_123 kibanaserver_password=Test_6789" --private-key=~/.ssh/my-ssh-key

## LOGSTASH OSS

We added a specific role to deploy Logstash OSS

### Clean Logstash OSS installation

First stop the service

      service logstash stop

Cleanup current installation with the following commands

     rm -f /tmp/logstash.tar.gz
     rm -rf /usr/share/logstash
     rm -f /etc/systemd/system/logstash.service
     systemctl daemon-reload 
