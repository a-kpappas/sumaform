include:
  - repos

no-xen-tools:
  pkg.removed:
    - name: xen-tools-domU

# SLES JeOS doesn't ship the KVM and Xen modules
no_kernel_default_base:
  pkg.removed:
    - name: kernel-default-base

virthost_packages:
  pkg.installed:
        - patterns-openSUSE-{{ grains['hypervisor']|lower() }}_server
        - libvirt-client
        - qemu-tools
        - guestfs-tools
        - tar # WORKAROUND: missing supermin tar dependency bsc#1134334
        - kernel-default
        - tuned
        - irqbalance
        - openQA-bootstrap
    - require:
      - sls: repos
      - pkg: no-xen-tools
      - pkg: no_kernel_default_base


# WORKAROUND for bsc#1181264
{% if grains['osrelease'] == '15.3' and grains['hypervisor'] == 'kvm' %}
no-50-xen-hvm-x86_64.json:
  file.absent:
    - name: /usr/share/qemu/firmware/50-xen-hvm-x86_64.json
{% endif %}

# fake_systemd_detect_virt:
#   file.managed:
#     - name: /usr/bin/systemd-detect-virt
#     - source: salt://virthost/systemd-detect-virt
#     - mode: 655

# fake_virt_what:
#   file.managed:
#     - name: /usr/sbin/virt-what
#     - mode: 655
#     - contents: "# Fake from sumaform to mock physical machine"

{% if grains['hvm_disk_image'] %}
disk-image-template.qcow2:
  file.managed:
    - name: /var/testsuite-data/disk-image-template.qcow2
    - source: {{ grains['hvm_disk_image'] }}
    {% if grains['hvm_disk_image_hash'] %}
    - source_hash: {{ grains['hvm_disk_image_hash'] }}
    {% else %}
    - skip_verify: True
    {% endif %}
    - mode: 655
    - makedirs: True
{% endif %}

ifcfg-eth0:
  file.managed:
    - name: /etc/sysconfig/network/ifcfg-eth0
    - contents: |
        STARTMODE=auto
        BOOTPROTO=none

ifcfg-br0:
  file.managed:
    - name: /etc/sysconfig/network/ifcfg-br0
    - contents: |
        STARTMODE=onboot
        BOOTPROTO=dhcp
        BRIDGE=yes
        BRIDGE_PORTS=eth0



openqa-bootstrap:
  cmd.run:
    - name: /usr/share/openqa/script/openqa-bootstrap
    # - unless:
    #   - fun: service.status
    #     args:
    #       - ca-certificates.path
{% if grains['hypervisor']|lower() == 'xen' %}
{% if grains['xen_disk_image'] %}
disk-image-template-xenpv.qcow2:
  file.managed:
    - name: /var/testsuite-data/disk-image-template-xenpv.qcow2
    - source: {{ grains['hvm_disk_image'] }}
    {% if grains['hvm_disk_image_hash'] %}
    - source_hash: {{ grains['hvm_disk_image_hash'] }}
    {% else %}
    - skip_verify: True
    {% endif %}
    - mode: 655
    - makedirs: True
{% endif %}

set_xen_default:
  bootloader.grub_set_default:
    - name: Xen
    - onchanges:
        - pkg: virthost_packages

lower_dom0_memory:
  file.replace:
    - name: /etc/default/grub
    - pattern: ^GRUB_CMDLINE_XEN="[^"]*"
    - repl: GRUB_CMDLINE_XEN="dom0_mem=1024000"

rebuild_grub_cfg:
  cmd.run:
    - name: grub2-mkconfig -o /boot/grub2/grub.cfg
    - onchanges:
        - bootloader: set_xen_default
        - file: lower_dom0_memory
{% endif %}

reboot:
  module.run:
    - name: system.reboot
    - at_time: +2
    - order: last
