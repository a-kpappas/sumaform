include:
  {% if grains['hostname'] and grains['domain'] %}
  - openqa.hostname
  {% endif %}
  - openqa.network
  - openqa.firewall
  - openqa.avahi
  {% if 'build_image' not in grains.get('product_version') | default('', true) %}
  - repos
  {% endif %}
  - openqa.time

minimal_package_update:
  pkg.latest:
    - pkgs:
      - salt-minion
{% if grains['os_family'] == 'Suse' %}
      - zypper
      - libzypp
      # WORKAROUND: avoid a segfault on old versions
      {% if '12' in grains['osrelease'] %}
      - libgio-2_0-0
      {% endif %}
{% endif %}
    - order: last
