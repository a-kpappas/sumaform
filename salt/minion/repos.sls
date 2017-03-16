include:
  - default

# install docker repos only for testing and sles-minion, only 1 of the 2 sles minion
{% if grains['os'] == 'SUSE' and grains['container_build_host'] %}
docker-update-repo:
  file.managed:
    - name: /etc/zypp/repos.d/SUSE_Updates_SLE-Module-Containers_12_x86_64.repo
    - source: salt://minion/repos.d/SUSE_Updates_SLE-Module-Containers_12_x86_64.repo
    - template: jinja
    - require:
      - sls: default
docker-pool-repo:
  file.managed:
    - name: /etc/zypp/repos.d/SUSE_Pool_SLE-Module-Containers_12_x86_64.repo
    - source: salt://minion/repos.d/SUSE_Pool_SLE-Module-Containers_12_x86_64.repo
    - template: jinja
    - require:
      - sls: default
refresh-minion-repos:
  cmd.run:
    - name: zypper --non-interactive --gpg-auto-import-keys refresh

{% else %}

no-minion-repos:
  test.nop: []

{% endif %}
