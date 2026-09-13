# Toggleable cybersecurity/pentesting stack for self-study. Off by default —
# flip it on per-host with `mercnix.cybersecurity.enable = true;` (see
# Malenia in modules/flake/hosts.nix for an example).
#
# Mainstream, commonly-taught tools across the usual categories: recon,
# web app testing, password attacks, wireless, exploitation, and
# reverse-engineering/forensics basics. Trim or extend this list as your
# coursework/CTF practice calls for specific tools — nixpkgs covers most
# of the standard "pentest 101" toolkit.
{ ... }:
{
  flake.modules.nixos.stack-cybersecurity =
    { config, lib, pkgs, ... }:
    let
      cfg = config.mercnix.cybersecurity;
    in
    {
      options.mercnix.cybersecurity.enable = lib.mkEnableOption "the cybersecurity/pentesting learning stack";

      config = lib.mkIf cfg.enable {
        # programs.wireshark.enable installs wireshark-cli (tshark) by
        # default; override to the full GUI app, and set up the group +
        # dumpcap capabilities so it can capture without running as root.
        programs.wireshark = {
          enable = true;
          package = pkgs.wireshark;
        };
        users.users.mercury.extraGroups = [ "wireshark" ];

        environment.systemPackages = with pkgs; [
          # Recon / scanning
          nmap
          netcat-gnu
          socat

          # Web app testing
          burpsuite
          sqlmap
          nikto
          gobuster
          ffuf

          # Password attacks
          john
          hashcat
          hydra

          # Wireless
          aircrack-ng

          # Sniffing
          tcpdump

          # Exploitation / reverse engineering / forensics
          metasploit-framework
          exploitdb
          radare2
          binwalk
          exiftool
        ];
      };
    };
}
