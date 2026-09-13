# Toggleable DevOps stack for self-study. Off by default — flip it on
# per-host with `mercnix.devops.enable = true;`.
#
# Containers, IaC, orchestration, and cloud CLI — the mainstream tools
# you'd actually meet on the job: Docker + Compose, Kubernetes tooling,
# Terraform/Ansible/Packer, and the AWS CLI.
{ ... }:
{
  flake.modules.nixos.stack-devops =
    { config, lib, pkgs, ... }:
    let
      cfg = config.mercnix.devops;
    in
    {
      options.mercnix.devops.enable = lib.mkEnableOption "the DevOps learning stack";

      config = lib.mkIf cfg.enable {
        virtualisation.docker.enable = true;
        users.users.mercury.extraGroups = [ "docker" ];

        environment.systemPackages = with pkgs; [
          # Containers
          docker-compose
          lazydocker

          # Kubernetes
          kubectl
          kubernetes-helm
          k9s
          kind
          minikube

          # Infrastructure as code / config management
          terraform
          terragrunt
          packer
          ansible

          # Cloud CLI
          awscli2

          # General-purpose glue
          jq
          yq-go
        ];
      };
    };
}
