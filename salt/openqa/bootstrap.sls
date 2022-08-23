execute_bootstrap:
  cmd.run:
    - name: /usr/share/openqa/script/openqa-bootstrap
    require:
      - sls: pkgs
