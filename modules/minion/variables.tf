variable "base_configuration" {
  description = "use module.base.configuration, see the main.tf example file"
  type        = map(string)
}

variable "name" {
  description = "hostname, without the domain part"
  type        = string
}

variable "roles" {
  description = "List of the host roles"
  default     = ["minion"]
}

variable "product_version" {
  description = "A valid SUSE Manager version (eg. 3.2-nightly, head) see README_ADVANCED.md"
  default     = "released"
}

variable "server_configuration" {
  description = "use module.<SERVER_NAME>.configuration, see the main.tf example file"
  type        = map(string)
}

variable "activation_key" {
  description = "an Activation Key to be used when onboarding this minion"
  default     = "null"
}

variable "auto_connect_to_master" {
  description = "whether this minion should automatically connect to the Salt Master upon deployment"
  default     = true
}

variable "evil_minion_count" {
  description = "change to a number to use the evil-minions load generator, see README_ADVANCED.md"
  default     = 0
}

variable "evil_minion_slowdown_factor" {
  description = "slowdown factor for evil-minions (floating point), see README_ADVANCED.md"
  default     = 0
}

variable "use_os_released_updates" {
  description = "Apply all updates from SUSE Linux Enterprise repos"
  default     = false
}

variable "use_os_unreleased_updates" {
  description = "Apply all updates from SUSE Linux Enterprise unreleased (Test) repos"
  default     = false
}

variable "apparmor" {
  description = "whether AppArmor access control should be installed"
  default     = false
}

variable "avahi_reflector" {
  description = "if using avahi, let the daemon be a reflector"
  default     = false
}

variable "additional_repos" {
  description = "extra repositories used for installation {label = url}"
  default     = {}
}

variable "additional_packages" {
  description = "extra packages which should be installed"
  default     = []
}

variable "quantity" {
  description = "number of hosts like this one"
  default     = 1
}

variable "swap_file_size" {
  description = "Swap file size in MiB, or 0 for none"
  default     = 0
}

variable "ssh_key_path" {
  description = "path of additional pub ssh key you want to use to access VMs, see README_ADVANCED.md"
  default     = "/dev/null"
  # HACK: "" cannot be used as a default because of https://github.com/hashicorp/hil/issues/50
}

variable "gpg_keys" {
  description = "salt/ relative paths of gpg keys that you want to add to your VMs, see README_ADVANCED.md"
  default     = []
}

variable "ipv6" {
  description = "IPv6 tuning: enable it, accept the RAs"
  default = {
    enable    = true
    accept_ra = true
  }
}

variable "additional_grains" {
  description = "custom grain string to be added to this minion's configuration"
  default     = ""
}

variable "image" {
  description = "One of: sles11sp4, sles12, sles12sp1, sles12sp2, sles12sp3, sles12sp4, sles15, centos7"
  type        = string
}

variable "provider_name" {
  description = "One of: libvirt, aws"
  type        = string
}

variable "provider_settings" {
  description = "Settings specific to the provider"
  type        = map(any)
  default     = null
}