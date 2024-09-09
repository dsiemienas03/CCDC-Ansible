#!/usr/bin/env bash 
read -p "Palo IP: " PALO_IP
read -p "Palo PW: " PALO_PW
read -p "Cisco FTD IP: " FTD_IP
read -p "Cisco FMC IP: " FMC_IP
read -p "Cisco Password: " CISCO_PW

# sudo apt update
# sudo apt install -y ansible-core python3-pip

# sudo ansible-galaxy collection install paloaltonetworks.panos
# pip install -r requirements.txt

# ssh-keygen -t rsa -b 4096 -C "ansible@localhost" -f ~/.ssh/id_rsa -N ""

#Line below came from chatgpt
API_KEY=$(curl -s -k -H "Content-Type: application/x-www-form-urlencoded" -X POST "https://$PALO_IP/api/?type=keygen" -d "user=admin&password=$PALO_PW" | grep -oP '(?<=<key>)[^<]+')

echo $API_KEY
# Output to fw.yml 
cat > data/inv.yml <EOF
palo:
  hosts:
    $PALO_IP:
  vars:
    ip_address: $PALO_IP
    api_key: $API_KEY
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
    $FTD_IP:
      username: admin
      password: {{ ADD PASSWORD HERE }}
      fw: fw2
  vars:
    FTD_IP: $FTD_IP
EOF

cat ~/.ssh/id_rsa.pub
cat data/inv.yml

# sudo ansible-vault encrypt inv.yml
