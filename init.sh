#!/usr/bin/env bash
set -e

if [ ! -f /root/.conjurrc ]; then
	conjur init -h conjur
fi

if [ ! -f /root/.netrc ]; then
	conjur authn login
fi

conjur policy load --as-group security_admin policy/ansible.yml
conjur policy load --as-group security_admin policy/entitlements.yml
