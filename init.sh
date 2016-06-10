#!/usr/bin/env bash
set -e

conjur policy load --as-group security_admin policy/provisioning.yml
conjur policy load --as-group security_admin policy/entitlements.yml

API_KEY="$(conjur host rotate_api_key -h provisioner)" bash -c "conjur authn login -p \$API_KEY host/provisioner"