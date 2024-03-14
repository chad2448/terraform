terraform {
  required_providers {
    concourse = {
      source = "terraform-provider-concourse/concourse"
      version = "8.0.1"
    }
  }
}

provider "concourse" {
  url      = var.url
  team     = var.team
  target   = var.target
  username = var.username
  password = var.password
}

data "concourse_teams" "teams" {
}

# Create a team in concurse
resource "concourse_team" "new_team" {
  team_name = "${var.new-team-name}"

  owners = [
    "group:github:${var.git-org-name}",
    "group:github:${var.git-org-name}:${var.git-team-name}",
    "user:github:${var.git-username}",
  ]

  viewers = [
    "user:github:${var.git-username}",
    "user:local:test"
  ]
}

## Creat a pipeline
resource "concourse_pipeline" "team_pipe" {
  team_name     = "${var.new-team-name}"
  pipeline_name = "${var.new-pipeline-name}"

  is_exposed = true
  is_paused  = true

  pipeline_config        = file("./pipelines/${var.pipeline-config-1}")
  pipeline_config_format = "yaml"
}

resource "concourse_pipeline" "check_status" {
  team_name     = "${var.new-team-name}"
  pipeline_name = "check-status"

  is_exposed = true
  is_paused  = false

  pipeline_config        = file("./pipelines/check-status.yml")
  pipeline_config_format = "yaml"

  vars = {
    repository = "${var.repository}"
  }
}

resource "concourse_pipeline" "deploy_vm" {
  team_name     = "${var.new-team-name}"
  pipeline_name = "deploy-vm"

  is_exposed = true
  is_paused  = false

  pipeline_config        = file("./pipelines/create-vm.yml")
  pipeline_config_format = "yaml"

  vars = {
    pm_api_url             = "${var.pm_api_url}"
    pm_user                = "${var.pm_user}"
    pm_password            = "${var.pm_password}"
    container_pass         = "${var.container_pass}"
    target_node            = "${var.target_node}"
    ostemplate             = "${var.ostemplate}"
    tags                   = "${var.tags}"
    nameserver             = "${var.nameserver}"
    hostname               = "${var.hostname}"
    environment_access_key = "${var.environment_access_key}"
    environment_secret_key = "${var.environment_secret_key}"
  }  
}