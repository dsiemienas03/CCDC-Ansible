FROM ubuntu:noble-20240605

# Add user
RUN set -ex ;\
    useradd ansible -ms /bin/bash

WORKDIR /home/ansible

RUN set -ex ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common

# Insall ansible related stuff
RUN set -ex ;\
    apt-get update --no-install-recommends ;\
    apt-get install -y --no-install-recommends \ 
    ansible \
    python3 \
    python3-pip 
# Install other tools

RUN set -ex ;\
    add-apt-repository ppa:deadsnakes/ppa ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends \
    vim \
    curl \
    python3-all-venv \
    python3.11 \
    python3.11-venv \
    git ;\
    apt-get purge -y --auto-remove ;\
    rm -rf /var/lib/apt/lists/*

# RUN set -ex ;\
#     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py ;\
#     python3.11 get-pip.py

USER ansible
RUN set -ex ;\
    mkdir ansible ;\
    mkdir ansible/palo ;\
    mkdir ansible/cisco ;\
    mkdir ansible/pfsense ;\
    mkdir ansible/config ;\
    mkdir dsu ;\
    mkdir data ;\
    mkdir .ssh ;\
    chmod 700 data ;\
    chmod 700 .ssh ;\
    chown ansible:ansible data ;\
    chown ansible:ansible .ssh

COPY config/* ./ansible/config/
COPY --chown=ansible:ansible fw-setup.sh .

# COPY palo/* ./ansible/palo/
# COPY cisco/* ./ansible/cisco/
# COPY pfsense/* ./ansible/pfsense/

SHELL ["/bin/bash", "-c"]
RUN set -ex ;\
    python3.11 -m venv .venv ;\
    source .venv/bin/activate ;\
    pip install --upgrade pip ;\
    pip install --break-system-packages --no-cache-dir \
    -r ansible/config/requirements.txt ;\
    \
    ansible-galaxy collection install \
    -r ansible/config/requirements.yml

COPY --chown=ansible:ansible dsu/** ./dsu/

RUN set -ex ;\
    ansible-galaxy collection build dsu/ ;\
    ansible-galaxy collection install --offline dsu-ccdc-1.0.0.tar.gz ;\
    rm -rf dsu-ccdc-1.0.0.tar.gz 

ENTRYPOINT ["top", "-b"]
# CMD "top"
