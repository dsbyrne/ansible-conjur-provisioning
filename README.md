# ansible-conjur-provisioning

Launches applications via Ansible with secrets provided from Conjur

# Setup

```
$ docker-compose up -d
```


# Running

## Initialize Conjur in the Ansible container

```
$ docker exec -it ansibleconjurprovisioning_ansible_1 bash
/mnt/ansible-ec2# ./init.sh
```

* Login as `admin/secret`

## Populate ec2 credentials

Input values for the following variables:

* **provisioning/secret_access_key** AWS secret access key
* **provisioning/access_key_id** AWS key ID
* **provisioning/region** AWS region
* **provisioning/bootstrap_private_key** Private key to initially launch machines with.

```
/mnt/ansible-ec2# policy=provisioning
/mnt/ansible-ec2# conjur variable values add $policy/region us-east-1
Value added
/mnt/ansible-ec2# conjur variable values add $policy/access_key_id 29ad52b21de281245ed19276
Value added
/mnt/ansible-ec2# conjur variable values add $policy/secret_access_key 433e03425f3101dc8c0a610a1e9d6f0f6efe898643dd1ccd
Value added
/mnt/ansible-ec2# cat /root/.ssh/conjur_dev_spudling.pem | conjur variable values add $policy/bootstrap_private_key
Value added
/mnt/ansible-ec2# conjur variable values add $policy/key_name spudling
Value added
```

## Configure ec2 subnet and security group

```
/mnt/ansible-ec2# cat << CONFIG > local.yml
GROUP_ID: sg-e760f99c
VPC_SUBNET_ID: subnet-f0c019a8
CONFIG
```

## Login as the `ansible` host

```
/mnt/ansible-ec2# API_KEY="$(conjur host rotate_api_key -h provisioner)" bash -c "conjur authn login -p \$API_KEY host/provisioner"
/mnt/ansible-ec2# conjur authn whoami 
{"account":"cucumber","username":"host/provisioner"}
```

## Launch the host

```
/mnt/ansible-ec2# summon -- summon -f local.yml ansible-playbook launch.yml
```

