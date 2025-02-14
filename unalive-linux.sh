# This script is intended to be installed in '/etc/profile.d/'.
# It is not intended to be run directly/interactively.
# Hence why there is no shebang and the script does not have 755 mode.

# Display the mandatory warning. Make it bold, red and flashing.
echo -e "\e[1;5;31mWARNING: Unalive Linux is active! Good luck...\e[0m" >&2

# List all the possible library directories used by common systems.
# If your system uses a libdir which isn't here, please add it and send a PR!
unalive_possible_libdirs=(
  "/usr/lib/$(uname -m)-linux-gnu",
  "/usr/lib",
  "/usr/lib64",
  "/lib/$(uname -m)-linux-gnu",
  "/lib",
  "/lib64"
)

# Find the libdir which contains libc.so.6
unalive_libdir=""
for dir in "${unalive_possible_libdirs[@]}"; do
  if test -x "$dir"/libc.so.6; then
    unalive_libdir="$dir"
    break
  fi
done

# Provide the command_not_found_handle.
command_not_found_handle() {
  # Display the message.
  echo -e "\e[1;31mUh-oh! You know what's going to happen now...\e[0m" >&2
  # See if we can elevate using pkexec (polkit), otherwise use sudo.
  # Note that sudo doesn't have a rule to skip password authentication.
  local unalive
  if command -v pkexec 2>/dev/null; then
    unalive="pkexec"
  else
    unalive="sudo"
  fi
  # Find all libraries in the libdir and randomly choose one to remove.
  # Ideally, the polkit rule should be installed to avoid a password prompt.
  $unalive rm -fv "$(find "$unalive_libdir" -mindepth 1 -maxdepth 1 -type f -name \*.so\* | shuf -n1)"
}
