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
