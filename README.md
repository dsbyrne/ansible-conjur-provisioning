# ansible-conjur-provisioning
Launches applications via Ansible with secrets provided from Conjur

# Setup
```
$ ./init.sh
$ cd docker
$ make
```
Make sure to input values for the following variables:
- `provisioning/secret_access_key` -> AWS secret access key
- `provisioning/access_key_id` -> AWS key ID
- `provisioning/region` -> AWS region
- `provisioning/bootstrap_private_key` -> Private key to initially launch machines with. Must match 'key_name' in [main.yml](roles/launch-ec2/tasks/main.yml).


# Running
```
$ cd docker
$ make run ssh
root $ cd /mnt/ansible-ec2
root $ summon ansible-playbook launch.yml
```

