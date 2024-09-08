read -p "Cisco FTD IP: " ftd_ip
read -p "Cisco FMC IP: " fmc_ip
read -p "Cisco FTD PW: " ftd_pw
read -p "Cisco FMC PW: " fmc_pw
curl -s -k -H Content-Type: application/x-www-form- xurlencoded -X POST https://10.20.244.201/api/fdm/latest/fdm/token -d grant_type=password&username=admin&password=$fmc_pw -o cisco.pw.yml
