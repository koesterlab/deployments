# configure software
export PATH="$HOME/.pixi/bin:$PATH"
export SNAKEMAKE_PROFILE="default"

setup_config() {
  (
    set -eu
    config=$1
    content=$2
    if ! [ -f $config ]
    then
      mkdir -p $(dirname $config)
      printf "$content" > $config
    fi
  )
}

setup_config ~/.pixi/config.toml "default-channels = [\"conda-forge\", \"bioconda\"]"

relogin=false

# install software
setup_cmd() {
  cmd=$1
  install_cmd=${2:-pixi global install $cmd}
  if ! [ -x "$(command -v $cmd)" ]
  then
    echo Installing "$cmd..."
    eval "$install_cmd"
    relogin=true
  fi
}

setup_cmd pixi "curl -fsSL https://pixi.sh/install.sh | sh"
setup_cmd snakemake "pixi global install snakemake --with snakemake-storage-plugin-s3"
setup_cmd s5cmd
setup_cmd conda "pixi global install conda && conda init && conda config --set auto_activate_base false"
setup_cmd starship "pixi global install starship && echo 'eval \"\$(starship init bash)\"' >> ~/.bashrc"
setup_cmd exa
setup_cmd rg "pixi global install ripgrep"
setup_cmd bat
setup_cmd sad
setup_cmd zoxide "pixi global install zoxide && echo \"eval \\"\$(zoxide init bash)\\"\" >> ~/.bashrc"

# admin commands
setup_user() {
  (
    set -eu
    username=$1
    pubkey=$2
    sshdir=/home/$username/.ssh
    authkeys=$sshdir/authorized_keys

    echo Adding user
    sudo useradd --groups koesterlab --shell /bin/bash -m $username
    echo Setup ssh dir
    sudo mkdir $sshdir
    echo Copy public key
    sudo bash -c "echo '$pubkey' > $authkeys"
    echo Setting public key permissions
    sudo chmod g-rwx,o-rwx $authkeys
    sudo chown $username:$username $authkeys
  )
}

update_given_profiles() {
  for f in "$@"
  do
    url=https://raw.githubusercontent.com/koesterlab/deployments/refs/heads/main/$f
    echo Updating profile $f...
    sudo bash -c "curl -L $url > /etc/profile.d/$(basename $f)"
  done
}


# show messages
show_login_message() {
  cat << EOF
=============================
Welcome to koesterlab compute
=============================
Hints:
* snakemake, pixi, and s5cmd are preinstalled
* Update pixi: pixi self-update
* Install software: pixi global install <software>
* Update software: pixi global update <software>
* Use the following commands for common tasks
   * tmux: decoupling of long running tasks from the SSH session
   * exa -l: listing files in a directory
   * rg (ripgrep): search in files with regexes (grep replacement)
   * bat: view files (cat replacement)
   * sad: replace text in files (sed replacement)
   * z (zoxide): smart navigation (cd replacement)
* Do NOT use conda to manage software (it is available, but just for snakemake internal use)
EOF
  for msg in "$@"
  do
    echo "* $msg"
  done

  if [ "$relogin" = true ] ; then
    echo "Please relogin to make all recent changes effective!"
  fi
}