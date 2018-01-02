# DM-VVV2-Provision-Blank
Provision scripts to setup an empty vagrant host ready to bring in an existing project.

If you don't already have a vvv-custom.yml, create it by copying _~/vagrant-local/vvv-config.yml_ to _~/vagrant-local/vvv-custom.yml_.

Add the following lines to the ``sites:`` section (note: tabs may not copy correctly; you may need to reformat this):

```
  existingproject:
    nginx_upstream: php71
    repo: https://github.com/DeliciousMedia/DM-VVV2-Provision-Blank.git
    hosts:
      - existingproject.test
```

If it isn't there already, include PHP 7.1 or PHP 7.2 by adding `` - php71`` or  `` - php72`` under the ``utilities:`` section.

Start the machine with ``vagrant up --provision`` or if it is already running, provision using ``vagrant reload --provision``.
