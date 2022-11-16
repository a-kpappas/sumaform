# include:
include:
  - default
  - openqa.openqa_pkgs

test_openqa:
  cmd.run:
    - name: echo testing > out.txt
