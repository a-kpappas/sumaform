{% if grains['additional_packages'] %}
install_additional_packages:
  pkg.latest:
    - pkgs:
{% for package in grains['additional_packages'] %}
      - {{ package }}
{% endfor %}
    - require:
      - sls: repos
{% endif %}

install_openqa_bootstrap:
  pkg.latest:
    - pkgs:
      - openQA-bootstrap
    - require:
      - sls: repos

install_openqa_workers:
  pkg.latest:
    - pkgs:
      - openQA-worker
    - require:
      - sls: repos
