# Kali Linux

It provides a Kali Linux container with the latest full metapackage pre-installed ready to work!

Integrated with docker-compose and standalone builds

Be patient, this will install all Kali tools (just for the first install, at image generation time). Final image size `~10GB`.

## Usage

Just launch the container using our simple bash compose handler:

```
bash run.sh
```

This will prepare a temporal container (will be auto-destroyed at the end) with the latest available version of Kali

