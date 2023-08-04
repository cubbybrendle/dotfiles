# Create and activate Python venvs

function create_venv() {
    venv_name="${1:-${PWD##*/}}"
    venv_path="${HOME}/.venvs/${venv_name}"
    
    if [ -d "${venv_path}" ]; then
        echo "venv ${venv_name} already exists."
    else
        python3 -m venv "${venv_path}"
        echo "venv ${venv_name} created at ${venv_path}"
    fi
}

function venv() {
    venv_name="${1:-${PWD##*/}}"
    venv_path="${HOME}/.venvs/${venv_name}"
    
    if [ -d "${venv_path}" ]; then
        source "${venv_path}/bin/activate"
    else
        echo "venv ${venv_name} doesn't exist."
    fi
}