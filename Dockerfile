FROM ubuntu:noble-20240605

# Add user
RUN set -ex ;\
    useradd ansible -ms /bin/bash

WORKDIR /home/ansible

RUN set -ex ;\
    apt-get update --no-install-recommends ;\
    echo pwd ;\
    apt-get install -y --no-install-recommends \ 
    ansible \
    python3 \
    python3-pip ;\
    apt-get purge -y --auto-remove ;\
    rm -rf /var/lib/apt/lists/*
    
RUN set -ex ;\
    mkdir ansible ;\
    mkdir ansible/palo ;\
    mkdir ansible/cisco ;\
    mkdir ansible/pfsense ;\
    mkdir ansible/config

COPY config/* ./ansible/config/
COPY ansible/* ./ansible/
# COPY palo/* ./ansible/palo/
# COPY cisco/* ./ansible/cisco/
# COPY pfsense/* ./ansible/pfsense/

RUN set -ex ;\
    pip3 install --break-system-packages --no-cache-dir \
        -r ansible/config/requirements.txt ;\
        \
    ansible-galaxy collection install \
        -r ansible/config/requirements.yml


ENTRYPOINT [ "top", "-c" ]
# CMD "top -c"
