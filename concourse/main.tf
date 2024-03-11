terraform {
  required_providers {
    concourse = {
      source = "terraform-provider-concourse/concourse"
      version = "8.0.1"
    }
  }
}

provider "concourse" {
  url  = var.url
  team = var.team
  target = var.target

  username = var.username
  password = var.password
}

variable "username" {}
variable "password" {}
variable "target" {}
variable "team" {}
variable "url" {}
variable "git-team-name" {}
variable "git-org-name" {}
variable "git-username" {}
variable "new-team-name" {}
variable "new-pipeline-name" {}
variable "pipeline-config-1" {}
variable "repository" {}
variable "pm_api_url" {}
variable "pm_user" {}
variable "pm_password" {}
variable "container_pass" {}
variable "target_node" {}
variable "ostemplate" {}
variable "tags" {}
variable "nameserver" {}
variable "hostname" {}

# data "concourse_teams" "teams" {
# }

# Create a team in concurse
resource "concourse_team" "chads_team" {
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
resource "concourse_pipeline" "chad_team_pipe" {
  # team_name     = "${var.new-team-name}"
  team_name     = "${var.team}"
  pipeline_name = "${var.new-pipeline-name}"

  is_exposed = true
  is_paused  = true

  pipeline_config        = file("./pipelines/${var.pipeline-config-1}")
  pipeline_config_format = "yaml"
}

resource "concourse_pipeline" "check_status" {
  #team_name     = "${var.new-team-name}"
  team_name     = "${var.team}"
  pipeline_name = "check-status"

  is_exposed = true
  is_paused  = true

  pipeline_config        = file("./pipelines/check-status.yml")
  pipeline_config_format = "yaml"

  vars = {
    repository = "${var.repository}"
  }
}

resource "concourse_pipeline" "deploy_vm" {
  #team_name     = "${var.new-team-name}"
  team_name     = "${var.team}"
  pipeline_name = "deploy-proxmox-vm"

  is_exposed = true
  is_paused  = true

  pipeline_config        = file("./pipelines/proxmox-tf/create-vm.yml")
  pipeline_config_format = "yaml"

  vars = {
    pm_api_url     = "${var.pm_api_url}"
    pm_user        = "${var.pm_user}"
    pm_password    = "${var.pm_password}"
    container_pass = "${var.container_pass}"
    target_node    = "${var.target_node}"
    ostemplate     = "${var.ostemplate}"
    tags           = "${var.tags}"
    nameserver     = "${var.nameserver}"
    hostname       = "${var.hostname}"
  }  
}

## Lookup all teams
# output "team_names" {
#   value = data.concourse_teams.teams.names
# }

# ## Lookup a team
# data "concourse_team" "my_team" {
#   team_name = "main"
# }

# output "my_team_name" {
#   value = data.concourse_team.my_team.team_name
# }

# output "my_team_owners" {
#   value = data.concourse_team.my_team.owners
# }

# output "my_team_members" {
#   value = data.concourse_team.my_team.members
# }

# output "my_team_pipeline_operators" {
#   value = data.concourse_team.my_team.pipeline_operators
# }

# output "my_team_viewers" {
#   value = data.concourse_team.my_team.viewers
# }

## Lookup a pipeline

# data "concourse_pipeline" "my_pipeline" {
#   team_name     = "main"
#   pipeline_name = "pipe-test"
# }

# output "my_pipeline_team_name" {
#   value = data.concourse_pipeline.my_pipeline.team_name
# }

# output "my_pipeline_pipeline_name" {
#   value = data.concourse_pipeline.my_pipeline.pipeline_name
# }

# output "my_pipeline_is_exposed" {
#   value = data.concourse_pipeline.my_pipeline.is_exposed
# }

# output "my_pipeline_is_paused" {
#   value = data.concourse_pipeline.my_pipeline.is_paused
# }

# output "my_pipeline_json" {
#   value = data.concourse_pipeline.my_pipeline.json
# }

# output "my_pipeline_yaml" {
#   value = data.concourse_pipeline.my_pipeline.yaml
# }