# configure software
setup_config ~/.config/snakemake/default/config.yaml "storage-s3-endpoint-url: https://openstack.cebitec.uni-bielefeld.de:8080\ndefault-storage-provider: s3\nsoftware-deployment-method: conda\ndefault-resources: []"

setup_cmd snakemake "pixi global install snakemake --with snakemake-storage-plugin-s3"
setup_cmd s5cmd

$DEPLOY_PROFILES=("common/98_koesterlab_common.sh" "denbi/99_koesterlab_cebitec.sh")

alias update_profiles_local="update_given_profiles localhost common/98_koesterlab_common.sh denbi/99_koesterlab_cebitec.sh"

show_login_message \
  "Do NOT store data in your home, use s3://koesterlab/<project>, access with s5cmd and by setting --default-storage-prefix s3://koesterlab/<project>" \
  "Do NOT put non-public human or personal data anywhere in here (also not into the s3)!"

