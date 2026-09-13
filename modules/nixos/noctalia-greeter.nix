# The Noctalia Greeter is a greetd-based login screen matching Noctalia's
# look and feel. Enabling it wires up greetd automatically.
# https://docs.noctalia.dev/greeter/
{ inputs, ... }:
{
  flake.modules.nixos.noctalia-greeter = { ... }: {
    imports = [ inputs.noctalia-greeter.nixosModules.default ];

    programs.noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "umbriel";
        user.default = "mercury";
      };
    };
  };
}
