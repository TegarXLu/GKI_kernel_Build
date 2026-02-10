#!/usr/bin/env bash

# ==============
#    Functions
# ==============

# simplify_gh_url <github-repository-url>
simplify_gh_url() {
  local URL="$1"
  echo "$URL" | sed "s|https://github.com/||g" | sed "s|.git||g"
}

# Kernel scripts function
config() {
  $KSRC/scripts/config --file $DEFCONFIG_FILE $@
}

# Logging function
log() {
  echo -e "[LOG] $*"
}

error() {
  local err_txt
  err_txt=$(
    cat << EOF
*Kernel CI*
ERROR: $*
EOF
  )
  echo -e "[ERROR] $*"
  send_msg "$err_txt"
  upload_file "$WORKDIR/build.log"
  exit 1
}
