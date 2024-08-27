FROM ubuntu:noble-20240605

# Add user
RUN set -ex ;\
    useradd ansible -ms /bin/bash

WORKDIR /home/ansible

RUN set -ex ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends \
    apt-utils

RUN set -ex ;\
    apt-get update --no-install-recommends ;\
    echo pwd ;\
    apt-get install -y --no-install-recommends \ 
    ansible \
    python3 \
    python3-pip \
    vim ;\
    apt-get purge -y --auto-remove ;\
    rm -rf /var/lib/apt/lists/*

USER ansible
RUN set -ex ;\
    mkdir ansible ;\
    mkdir ansible/palo ;\
    mkdir ansible/cisco ;\
    mkdir ansible/pfsense ;\
    mkdir ansible/config ;\
    mkdir dsu

COPY config/* ./ansible/config/
COPY --chown=ansible:ansible dsu/** ./dsu/
RUN set -ex ;\
    ansible-galaxy collection build dsu/ ;\
    ansible-galaxy collection install --offline dsu-ccdc-1.0.0.tar.gz
# COPY palo/* ./ansible/palo/
# COPY cisco/* ./ansible/cisco/
# COPY pfsense/* ./ansible/pfsense/

RUN set -ex ;\
    pip3 install --break-system-packages --no-cache-dir \
        -r ansible/config/requirements.txt ;\
        \
    ansible-galaxy collection install \
        -r ansible/config/requirements.yml


ENTRYPOINT [ "/bin/bash", "-c" ]
CMD "top"
