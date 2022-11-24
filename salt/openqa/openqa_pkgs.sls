include:
  - default

# install_openqa_bootstrap:
#   pkg.latest:
#     - pkgs:
#       - openQA-bootstrap
#     - require:
#       - sls: repos

install_git:
  pkg.latest:
    - pkgs:
      - git
    - require:
      - sls: repos
# install_openqa_workers:
#   pkg.latest:
#     - pkgs:
#       - openQA-worker
#     - require:
#       - sls: repos

get_script:
  git.latest:
    - name: https://github.com/a-kpappas/openQA.git
    - target: /root/openQA
    - rev: workaround_single_instance
    - branch: workaround_single_instance

execute_bootstrap:
  cmd.run:
    - name: /root/openQA/script/openqa-bootstrap

# {% set cpus = 4 %}
# {% for i in range(cpus) %}
# openqa-worker@{{i}}:
#   service.running:
#     - enable: True
# {% endfor %}
