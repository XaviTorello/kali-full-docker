# Kali Linux

It provides a Kali Linux container with the latest full metapackage pre-installed ready to work!

Integrated with docker-compose and standalone builds

Be patient, this will install all Kali tools (just for the first install, at image generation time). Final image size `~10GB`.

## Tools

- Kali full metapackage will ~all available tools
- `Tor` service, `proxychains` and `proxychains-ng` (aka `proxychains2`)
  - service not started by default
    - `service tor start`
  - configured to provide a new IP every 10 seconds
    - configurable via `MaxCircuitDirtiness` at `/etc/tor/torrc`
- [SecLists](https://github.com/danielmiessler/SecLists) at `/usr/share/seclists`
- w3af (dropped out of Kali repos)
- [code-server](https://github.com/codercom/code-server)
  - a VSCode served at `tcp/8443` (http://localhost:8443)
- [ngrok](http://ngrok.com)
- python virtualenvs via `virtualenvwrapper`
  - projects placed at /`root/projects`
- base packages
  - wget, curl, telnet, git, iputils-tracepath, net-tools
  - build-essentials
  - tmux, tmate
  - xterm, zsh
  - zstd
  - ltrace, strace
  - vim, less, colordiff, colortail
  - strace ltrace
  - unzip, unrar
  - python3-setuptools python3-pip
  - bash-completion
  - oh-my-git integration
  - nodejs, npm and yarn

  
## Usage

Just launch the container using our simple bash compose handler:

```
bash run.sh
```

This will prepare a temporal container (will be auto-destroyed at the end) with the latest available version of Kali

