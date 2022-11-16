include:
  - default
  
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

# execute_bootstrap:
#   cmd.run:
#     - name: /usr/share/openqa/script/openqa-bootstrap

# {% set cpus = 4 %}
# {% for i in range(cpus) %}
# openqa-worker@{{i}}:
#   service.running:
#     - enable: True
# {% endfor %}
