#!/bin/sh

# export_hcp_terraform_token
#
# Export the HCP Terraform token used to authenticate with the organization
# to GITHUB_ENV.

# sanitize_hostname
#
# Sanitize an HCP Terraform hostname so it can be used to authenticate to
# an HCP Terraform organization.
#
# This function will take the hostname of an HCP Terraform organization and
# export the santized hostname to stdout.
#
# > Environment variable names should have the prefix TF_TOKEN_
# > added to the hostname, with periods encoded as underscores.
# > Hyphens are also valid within host names but usually invalid
# > as variable names and may be encoded as _double underscores_.
sanitize_hostname() {
  hostname="${1}"
  sanitized_hostname="$(
    printf '%s\n' "${hostname}" |
      tr '.' '_' |
      sed 's/-/__/g'
  )"

  printf '%s\n' "${sanitized_hostname}"
}

main() {
  set -eu

  # Ensure the required environment variables have been set.
  : "${HCP_TERRAFORM_HOSTNAME:?"<-- this required environment variable was not set."}"
  : "${HCP_TERRAFORM_API_TOKEN:?"<-- this required environment variable was not set."}"

  # Check if the required utilities are installed.
  for utility in tr sed; do
    command -v "${utility}" >/dev/null || {
      printf '%s\n' "Error: ${utility} is not installed." >&2
      exit 1
    }
  done

  sanitized_hostname="$(sanitize_hostname "${HCP_TERRAFORM_HOSTNAME}")"
  tf_token_name="TF_TOKEN_${sanitized_hostname}"

  printf '%s=%s' "${tf_token_name}" "${HCP_TERRAFORM_API_TOKEN}" >>"${GITHUB_ENV}"
}

main "$@"
