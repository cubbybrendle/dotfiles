source /usr/local/opt/chruby/share/chruby/chruby.sh

unset RUBY_AUTO_VERSION

function chruby_auto() {
  local dir="$PWD/" version

  until [[ -z "$dir" ]]; do
    dir="${dir%/*}"

    if { read -r version <"$dir/.ruby-version"; } 2>/dev/null || [[ -n "$version" ]]; then
      version="${version%%[[:space:]]}"

      if [[ "$version" == "$RUBY_AUTO_VERSION" ]]; then return
      else
        RUBY_AUTO_VERSION="$version"
        chruby "$version"
        return $?
      fi
    fi
  done

  if [[ -n "$RUBY_AUTO_VERSION" ]]; then
    chruby_reset
    unset RUBY_AUTO_VERSION
  fi
}

source ${0:h}/lib/chnode.zsh

unset CHNODE_AUTO_VERSION

function chnode_auto() {
  local dir="$PWD/" version

  until [[ -z "$dir" ]]; do
    dir="${dir%/*}"

    if { read -r version <"$dir/.node-version"; } 2>/dev/null || [[ -n ${version:-} ]]; then
      if [[ $version == "${CHNODE_AUTO_VERSION:-}" ]]; then return
      else
        CHNODE_AUTO_VERSION="$version"
        chnode "$version"
        return $?
      fi
    fi
  done

  if [[ -n "${CHNODE_AUTO_VERSION:-}" ]]; then
    chnode_reset
    unset CHNODE_AUTO_VERSION
  fi
}

preexec_functions+=("chruby_auto" "chnode_auto")

export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"
