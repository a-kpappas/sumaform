# include:
include:
  - default
  - openqa.openqa_pkgs

test_openqa:
  cmd.run:
    - name: echo testing > out.txt

monitor_dhcp_file:
  file.managed:
    - name: /etc/sysconfig/network/dhcp

dhcp_hostname:
  file.replace:
    - name: '/etc/sysconfig/network/dhcp'
    - pattern: '(^DHCLIENT_SET_HOSTNAME=)(".*")'
    - repl: '\1"yes"'
    - show_changes: True

wicked:
  service.running:
  - reload: True
  - watch:
    - file: /etc/sysconfig/network/dhcp

