GNOME_CONFIG=$HOME/junk.conf #/etc/gdm3/custom.conf
SYSTEM_CTL=$HOME/junkctl.conf #/etc/sysctl.conf

lol_setup () {
  if [[ "$1" == "start" ]]; then
    set_up_lol_config
  elif [[ "$1" == "stop" ]]; then
    tear_down_lol_config
  fi
}

set_up_lol_config () {
  enable_syscall
  enable_wayland

  reboot
}

tear_down_lol_config () {
  disable_syscall
  disable_wayland

  reboot
}

# setup
enable_wayland () {
  echo "WaylandEnable=true" >> "$GNOME_CONFIG"
}

enable_syscall () {
  echo "abi.vsyscall32=0" >> "$SYSTEM_CTL"
}

# teardown
disable_wayland () {
  remove_enabled_wayland_line
  add_disabled_wayland_line
}

add_disabled_wayland_line () {
  echo "WaylandEnable=false" >> "$GNOME_CONFIG"
}

remove_enabled_wayland_line () {
  sed -i /"WaylandEnable=true"/d "$GNOME_CONFIG"
}

remove_disabled_wayland_line () {
  sed -i /"WaylandEnable=false"/d "$GNOME_CONFIG"
}

disable_syscall () {
  remove_syscall_enabled_line
}

remove_syscall_enabled_line () {
  sed -i /"abi.vsyscall32=0"/d "$SYSTEM_CTL"
}

# shared
reboot () {
  echo "rebooting..."
}

## experimental

add_to_gnome_config_file () {
  content=$1

  append_content_for_file "$content" "$GNOME_CONFIG"
}

add_to_system_ctl_file () {
  content=$1

  append_content_for_file "$content" "$SYSTEM_CTL"
}

remove_content_from_gnome_config_file () {
  content=$1

  remove_content_from_file "$content" "$GNOME_CONFIG"
}

remove_content_from_file () {
  content=$1
  file=$2

  sed -i /"$content"/d "$file"
}

append_content_for_file () {
  content=$1
  file=$2

  echo "$content" >> "$file"
}