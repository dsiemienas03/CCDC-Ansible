#!/usr/bin/env bash 
read -p "Palo IP: " palo_ip
read -p "Palo PW: " palo_pw
read -p "Cisco FTD IP: " ftd_ip
read -p "Cisco FMC IP: " fmc_ip

# sudo apt update
# sudo apt install -y ansible-core python3-pip

# sudo ansible-galaxy collection install paloaltonetworks.panos
# pip install -r requirements.txt

# ssh-keygen -t rsa -b 4096 -C "ansible@localhost" -f ~/.ssh/id_rsa -N ""


#Line below came from chatgpt
api_key=$(curl -s -k -H "Content-Type: application/x-www-form-urlencoded" -X POST "https://${palo_ip}/api/?type=keygen" -d "user=admin&password=${palo_pw}" | grep -oP '(?<=<key>)[^<]+')

# Output to fw.yml 
cat >> data/inv.yml <<EOF
palo:
  hosts:
    ${palo_ip}:
  vars:
    ip_address: ${palo_ip}
    api_key: ${api_key}
    fw: palo1

esxi:
  hosts:
    10.60.60.20:
      esxi_password: {{ ADD PASSWORD HERE }}
    10.60.60.21:
      esxi_password: {{ ADD PASSWORD HERE }}
  vars:
    ansible_user: root
    esxi_password: {{ ADD PASSWORD HERE }}

cisco:
  hosts:
    ${ftd_ip}:
      username: admin
      password: {{ ADD PASSWORD HERE }}
      fw: fw2
  vars:
    ftd_ip: ${ftd_ip}
EOF

cat ~/.ssh/id_rsa.pub
cat data/inv.yml

# sudo ansible-vault encrypt inv.yml
