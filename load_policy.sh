#!/usr/bin/env bash
set -e

NAMESPACE=ansible

HOST_IP=$1
[ -z $POLICY_ID ] || exit 1

TIME_TO_LIVE=$2
[ -z $TIME_TO_LIVE ] && TIME_TO_LIVE=P1D

POLICY_ID=$NAMESPACE/$HOST_IP

# Load the policy
cat /mnt/ansible-ec2/policy/new_instance.yml \
  | sed -e 's;%POLICY_ID%;'"$HOST_IP"';g' -e 's;%TIME_TO_LIVE%;'"$TIME_TO_LIVE"';g' \
  | conjur policy load --as-group provisioning --namespace $NAMESPACE

# Populate policy variables
summon --yaml "BOOTSTRAP_KEY: "'!'"var provisioning/bootstrap_private_key" \
  bash -c 'conjur variable values add "'$POLICY_ID'/private_key" "$(echo "$BOOTSTRAP_KEY")"'
conjur variable values add "$POLICY_ID/host" "$HOST_IP"
conjur variable values add "$POLICY_ID/login" ubuntu

# Expire the bootstrap private key (trigger rotation)
conjur variable expire --now "$POLICY_ID/private_key"

conjur role grant_to -a policy:$POLICY_ID group:security_admin
conjur role revoke_from policy:$POLICY_ID group:provisioning