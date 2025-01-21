# Copyright (c) 2018 Tuomas Kareinen

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# https://github.com/tkareine/chnode
# commit e89628c53f9545b16f572c17bafe57e4cc14a2d5

CHPYTHON_VERSION=0.3.1
: "${CHPYTHON_PYTHONS_DIR=$HOME/.pythons}"

chpython_reload() {
    local last_root=${CHPYTHON_ROOT:-}

    [[ -n $last_root ]] && chpython_reset

    CHPYTHON_PYTHONS=()

    [[ ! (-d $CHPYTHON_PYTHONS_DIR && -n "$(command ls -A "$CHPYTHON_PYTHONS_DIR")") ]] && return

    CHPYTHON_PYTHONS+=("$CHPYTHON_PYTHONS_DIR"/*)

    [[ -z $last_root ]] && return

    local dir
    for dir in "${CHPYTHON_PYTHONS[@]}"; do
        if [[ $dir == "$last_root" ]]; then
            if chpython_use "$dir"; then
                return
            else
                return 1
            fi
        fi
    done
}

chpython_reset() {
    local last_root=${CHPYTHON_ROOT:-}

    unset CHPYTHON_ROOT

    [[ -z $last_root ]] && return

    local new_path=:$PATH:
    new_path=${new_path//:$last_root\/bin:/:}
    new_path=${new_path#:}
    new_path=${new_path%:}
    PATH=$new_path

    hash -r
}

chpython_use() {
    local new_root=$1

    if [[ ! -x "$new_root/bin/python" ]]; then
        echo "chpython: $new_root/bin/python not executable" >&2
        return 1
    fi

    [[ -n ${CHPYTHON_ROOT:-} ]] && chpython_reset

    export CHPYTHON_ROOT=$new_root
    export PATH=$CHPYTHON_ROOT/bin${PATH:+:$PATH}

    hash -r
}

chpython_match() {
    local dir python given=$1
    shift
    for dir in "${CHPYTHON_PYTHONS[@]}"; do
        dir="${dir%%/}"
        python="${dir##*/}"
        case $python in
            "$given")
                match_output=$dir
                break
                ;;
            *"$given"*)
                match_output=$dir
                ;;
        esac
    done
}

chpython_list() {
    local dir python
    for dir in "${CHPYTHON_PYTHONS[@]}"; do
        dir="${dir%/}"
        python="${dir##*/}"
        if [[ $dir == "${CHPYTHON_ROOT:-}" ]]; then
            echo " * ${python}"
        else
            echo "   ${python}"
        fi
    done
}

chpython() {
    case ${1:-} in
        -h|--help)
            echo "Usage: chpython [-h|-r|-R|-V|PYTHON_VERSION]"
            ;;
        -r|--reset)
            chpython_reset
            ;;
        -R|--reload)
            chpython_reload
            ;;
        -V|--version)
            echo "chpython: $CHPYTHON_VERSION"
            ;;
        "")
            chpython_list
            ;;
        *)
            local match_output
            chpython_match "$1"

            if [[ -z $match_output ]]; then
                echo "chpython: unknown Python: $1" >&2
                return 1
            fi

            chpython_use "$match_output"
            ;;
    esac
}

chpython_reload
