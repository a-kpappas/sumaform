include:
  - default

# install_openqa_bootstrap:
#   pkg.latest:
#     - pkgs:
#       - openQA-bootstrap
#     - require:
#       - sls: repos

openQA_prereqs:
  pkg.installed:
    - pkgs:
      - git
      - wicked
    - require:
      - sls: repos

get_script:
  git.latest:
    - name: https://github.com/a-kpappas/openQA.git
    - target: /root/openQA
    - rev: workaround_single_instance
    - branch: workaround_single_instance

execute_bootstrap:
  cmd.run:
    - name: /root/openQA/script/openqa-bootstrap

openQA_postreqs:
  pkg.installed:
    - pkgs:
      - qemu-hw-display-virtio-gpu
      - qemu-hw-display-virtio-gpu-pci
      - qemu-hw-display-virtio-vga
      - openvswitch
      - os-autoinst-openvswitch
    - require:
      - sls: repos


{% set cpus = 4 %}
{% for i in range(cpus) %}
openqa-worker@{{i}}:
  service.running:
    - enable: True
{% endfor %}

fix_developer_console:
  file.replace:
    - name: '/etc/openqa/workers.ini'
    - pattern: '^#(WORKER_HOSTNAME = )(.*)'
    - repl: '\1 localhost'
    - show_changes: True


# Make openvswitch bridge br1 persistent
/etc/sysconfig/network/ifcfg-br1:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents:
      - BOOTPROTO='static'
      - IPADDR='10.0.2.2/15'
      - STARTMODE='auto'
      - OVS_BRIDGE='yes'
     {% for i in range(cpus) %}
      - OVS_BRIDGE_PORT_DEVICE_{{ i }}='tap{{ i }}'
     {% endfor %}

# Configure tap devices for openvswitch
{% for i in range(cpus) %}
/etc/sysconfig/network/ifcfg-tap{{ i }}:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents:
      - BOOTPROTO='none'
      - IPADDR=''
      - NETMASK=''
      - PREFIXLEN=''
      - STARTMODE='hotplug'
      - TUNNEL='tap'
      - TUNNEL_SET_GROUP='kvm'
      - TUNNEL_SET_OWNER='_openqa-worker'
{% endfor %}

# Configure os-autoinst-openvswitch bridge configuration file
/etc/sysconfig/os-autoinst-openvswitch:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents:
      - OS_AUTOINST_USE_BRIDGE='br1'


openvswitch_service:
  service.running:
    - name: openvswitch
    - enable: True
    - reload: True
    - watch:
      - file: /etc/sysconfig/network/ifcfg-br1

wicked ifup br1:
  cmd.wait:
    - watch:
      - file: /etc/sysconfig/network/ifcfg-br1




# Enable os-autoinst-openvswitch helper or restart it if ifcfg-br1 and/or gre_tunnel_preup.sh has changed
os-autoinst-openvswitch:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/sysconfig/os-autoinst-openvswitch
    - onchanges_any:
      - file: /etc/sysconfig/network/ifcfg-br1
      - file: /etc/sysconfig/os-autoinst-openvswitch
