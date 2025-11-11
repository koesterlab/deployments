# configure software
setup_config ~/.config/snakemake/default/config.yaml "storage-s3-endpoint-url: https://openstack.cebitec.uni-bielefeld.de:8080\ndefault-storage-provider: s3\nsoftware-deployment-method: conda\ndefault-resources: []"

setup_cmd snakemake "pixi global install snakemake --with snakemake-storage-plugin-s3"

DEPLOY_PROFILES=("common/98_koesterlab_common.sh" "denbi/99_koesterlab_cebitec.sh")

show_login_message \
  "Do NOT store data in your home, use s3://koesterlab/<project>, access with s5cmd and by setting --default-storage-prefix s3://koesterlab/<project>" \
  "Do not compute on the machine main. Instead, jump to compute01, compute02, ...." \
  "Put any workflows in project specific subfolders under /mnt/workspace/<project>/ on compute01, compute02, ...." \
  "Do NOT put non-public human or personal data anywhere in here (also not into the s3)!"

# TODO add rclone setup and instructions

