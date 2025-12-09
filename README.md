# lint-terraform

A composite action for linting Terraform configuration.

## Usage

```yaml
name: Lint

on: pull_request

permissions:
  contents: read

jobs:
  terraform:
    name: Terraform
    runs-on: ubuntu-24.04
    steps:
      - name: Checkout
        uses: actions/checkout@v6

      - name: Lint Terraform Configuration
        uses: craigsloggett/lint-terraform@v1
```

### Inputs

| Input                    | Required? | Default            | Description                                                                |
| ------------------------ | --------- | ------------------ | -------------------------------------------------------------------------- |
| `terraform-version`      | `false`   | `1.14.1`           | The version of Terraform to use when running `terraform fmt` and `tflint`. |
| `tflint-version`         | `false`   | `0.60.0`           | The version of TFLint to use when running `tflint`.                        |
| `hcp-terraform-hostname` | `false`   | `app.terraform.io` | The hostname of the HCP Terraform organization storing private modules.    |

### Secrets

| Input                     | Required? | Description                                                                |
| ------------------------- | --------- | -------------------------------------------------------------------------- |
| `hcp-terraform-api-token` | `false`   | The API token used to lint Terraform modules in a Private Module Registry. |
