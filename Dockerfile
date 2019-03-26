FROM kalilinux/kali-linux-docker:latest

MAINTAINER Xavi Torelló <info@xaviertorello.cat>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

# Install Kali Full
RUN rm -fR /var/lib/apt/ && \
    apt-get clean && \
    apt-get update -y && \
    apt-get install -y software-properties-common kali-linux-full --fix-missing && \
    echo 'VERSION_CODENAME=kali-rolling' >> /etc/os-release

# Add NodeJS repo
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -

# Some system tools
RUN apt-get install -y git colordiff colortail unzip vim tmux xterm zsh curl telnet strace ltrace tmate less build-essential wget python3-setuptools python3-pip tor proxychains proxychains4 zstd net-tools bash-completion iputils-tracepath nodejs npm yarnpkg

# Oh-my-git!
RUN git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && \
    echo source ~/.oh-my-git/prompt.sh >> /etc/profile

# secLists!
RUN git clone https://github.com/danielmiessler/SecLists /usr/share/seclists

# w3af
RUN git clone https://github.com/andresriancho/w3af.git /opt/w3af && \
    apt-get install -y libssl-dev libxml2-dev libxslt1-dev zlib1g-dev python-dev python-pybloomfiltermmap ; \
    /opt/w3af/w3af_console ; \
    bash /tmp/w3af_dependency_install.sh ; \
    echo 'export PATH=/opt/w3af:$PATH' >> /etc/profile

# ngrok
RUN curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip | gunzip - > /usr/bin/ngrok && \
    chmod +x /usr/bin/ngrok

# code-server
RUN mkdir -p /opt/code-server && \
    curl -Ls https://api.github.com/repos/codercom/code-server/releases/latest | grep "browser_download_url.*linux" | cut -d ":" -f 2,3 | tr -d \"  | xargs curl -Ls | tar xz -C /opt/code-server --strip 1 && \
    echo 'export PATH=/opt/code-server:$PATH' >> /etc/profile

# virtualenv config
RUN pip install virtualenvwrapper && \
    echo 'export WORKON_HOME=$HOME/.virtualenvs' >> /etc/profile && \
    echo 'export PROJECT_HOME=$HOME/projects' >> /etc/profile && mkdir /root/projects && \
    echo 'export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh' >> /etc/profile && \
    bash /usr/local/bin/virtualenvwrapper.sh && \
    echo 'source /usr/local/bin/virtualenvwrapper.sh' >> /etc/profile

# Tor refresh every 5 requests
RUN echo MaxCircuitDirtiness 10 >> /etc/tor/torrc && \
    update-rc.d tor enable

# Use random proxy chains / round_robin_chain for pc4
RUN sed -i 's/^strict_chain/#strict_chain/g;s/^#random_chain/random_chain/g' /etc/proxychains.conf && \
    sed -i 's/^strict_chain/#strict_chain/g;s/^round_robin_chain/round_robin_chain/g' /etc/proxychains4.conf

# Update DB and clean'up!
RUN updatedb && \
    apt-get autoremove -y && \
    apt-get clean 

# Welcome message
RUN echo "echo 'Kali full container!\n\n- If you need proxychains over Tor just activate tor service with:\n$ service tor start\n'" >> /etc/profile

CMD ["/bin/bash", "--init-file", "/etc/profile"]
