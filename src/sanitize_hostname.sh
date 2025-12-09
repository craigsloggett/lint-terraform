#!/bin/sh

# sanitize_hostname - Sanitize a HCP Terraform hostname so it can be used to
#                     authenticate to the organization.
#
# This script will take the hostname of an HCP Terraform organization and
# print the santized version to stdout.
#
# > Environment variable names should have the prefix TF_TOKEN_
# > added to the hostname, with periods encoded as underscores.
# > Hyphens are also valid within host names but usually invalid
# > as variable names and may be encoded as _double underscores_.
#
# Examples:
#
# $ # Using HashiCorp's HCP Terraform platform.
# $ ./sanitize_hostname.sh app.terraform.io
#
# $ # Using a custom domain for your self-hosted HCP Terraform organization.
# $ ./sanitize_hostname.sh dev.tfe.example.com
#
# Dependencies:
#   - tr
#   - sed
main() {
  set -eu

  # Ensure the hostname has been passed to the script.
  : "${1:?"<-- the required 'hostname' argument was not provided."}"

  # Check if the required utilities are installed.
  for utility in tr sed; do
    command -v "${utility}" >/dev/null || {
      printf '%s\n' "Error: ${utility} is not installed." >&2
      exit 1
    }
  done

  hostname="${1}"
  sanitized_hostname="$(
    printf '%s\n' "${hostname}" |
      tr '.' '_' |
      sed 's/-/__/g'
  )"

  printf '%s\n' "${sanitized_hostname}"
}

main "$@"
