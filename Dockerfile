FROM ubuntu:noble-20240801

# Add user
RUN set -ex ;\
    useradd ansible -ms /bin/bash

WORKDIR /home/ansible

RUN set -ex ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common ;\
    apt-get install -y --no-install-recommends \ 
    ansible \
    curl \
    git \
    python3 \
    python3-pip \
    vim \
    tmux ;\
    rm -rf /var/lib/apt/lists/*

# Install extra python stuff cause python
RUN set -ex ;\
    add-apt-repository ppa:deadsnakes/ppa ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends \
    python3-all-venv \
    python3.11 \
    python3.11-venv ;\
    apt-get purge -y --auto-remove ;\
    rm -rf /var/lib/apt/lists/*

# RUN set -ex ;\
#     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py ;\
#     python3.11 get-pip.py

USER ansible
RUN set -ex ;\
    mkdir config ;\
    mkdir data ;\
    mkdir dsu ;\
    mkdir playbooks ;\
    mkdir .ssh ;\
    chmod 700 data ;\
    chmod 700 .ssh ;\
    chown ansible:ansible data ;\
    chown ansible:ansible .ssh

COPY --chown=ansible:ansible config/ ./config
COPY --chown=ansible:ansible fw-setup.sh .

SHELL ["/bin/bash", "-c"]

RUN python3.11 -m venv .venv
RUN set -ex ;\
    source .venv/bin/activate ;\
    pip install --break-system-packages --no-cache-dir \
    -r config/requirements.txt ;\
    \
    ansible-galaxy collection install \
    -r config/requirements.yml

COPY --chown=ansible:ansible playbooks/ ./playbooks/
COPY --chown=ansible:ansible .ansible.cfg .
COPY --chown=ansible:ansible dsu/ ./dsu/

RUN set -ex ;\
    ls -ls ;\
    ansible-galaxy collection build dsu/ccdc/ ;\
    ansible-galaxy collection install --offline dsu-ccdc-1.0.0.tar.gz ;\
    rm -rf dsu-ccdc-1.0.0.tar.gz ;\
    echo "source .venv/bin/activate" >> /home/ansible/.bashrc

ENTRYPOINT ["top", "-b"]
# CMD "top"
