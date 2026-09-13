# MercNix

Hunter Welch's "forever flake" — a multi-system NixOS configuration meant to
grow for years, across every machine he owns. Nix is the only package
manager here: no Flatpak, no Snap, no Homebrew.

This is also a deliberate learning project: the homelab (Vyke) and the
toggleable stacks below exist so day-to-day tinkering doubles as hands-on
practice with the tools real infra/security/sysadmin jobs actually use.

## Layout — flake-parts / dendritic

```
flake.nix              -- inputs + `import-tree ./modules`, nothing else
modules/
  flake/
    hosts.nix           -- the ONLY file that assembles features into real hosts
  nixos/                -- one file = one reusable NixOS feature
  home/                 -- one file = one reusable home-manager feature
hosts/
  <HostName>/            -- machine-specific files only (hardware-configuration.nix,
                            GPU driver bits) — never auto-imported
```

Every file under `modules/` is a [flake-parts](https://flake.parts) module,
auto-imported by [`import-tree`](https://github.com/vic/import-tree). Each
one contributes a named entry to `flake.modules.nixos.<name>` or
`flake.modules.homeManager.<name>`. `modules/flake/hosts.nix` is the single
place that reads those named entries back out and wires them into
`flake.nixosConfigurations` / `flake.homeConfigurations`.

**Adding a feature:** drop a new file in `modules/nixos/` or `modules/home/`
that sets `flake.modules.nixos.<your-name>` (or `.homeManager.<your-name>`),
then add `config.flake.modules.nixos.<your-name>` to whichever host(s) in
`modules/flake/hosts.nix` should get it. Nothing else to touch — that's the
whole point of the pattern.

Machine-generated files like `hardware-configuration.nix` live under
`hosts/` (outside `modules/`) on purpose: they're not reusable features, so
they're referenced directly by path from `hosts.nix` instead of going
through the dendritic tree.

## Hosts

| Host    | Role                                | Status                |
| ------- | ----------------------------------- | ---------------------- |
| Malenia | Desktop                             | Active                 |
| Radahn  | Laptop                              | Active                 |
| Vyke    | Homelab / server                    | Placeholder — see below |
| Morgott | Darwin / macOS (home-manager only)  | Placeholder, unused     |
| Mohg    | Steam Deck (Jovian-NixOS)           | Placeholder, unused     |

Every NixOS host gets, universally, via `modules/nixos/core.nix`:
JetBrains Mono Nerd Font as the default font (icons included — the Nerd
Font patch bakes them in), and Tailscale, so every device can reach every
other device's remote apps over the same tailnet regardless of physical
location.

## Desktop (Malenia, Radahn)

The only shell/compositor/greeter combo: [Noctalia](https://docs.noctalia.dev)
(shell/bar) on [Umbriel](https://docs.noctalia.dev/umbriel/) (compositor),
with the Noctalia Greeter for login. Both start automatically on login —
no manual launch step. Plugin support is on with the official + community
sources enabled; add plugin ids under `programs.noctalia.settings.plugins.enabled`
in `modules/home/desktop-shell.nix` as you pick them up.

## Homelab (Vyke) — the Nix answer to "Proxmox"

There's no single Nix package that *is* Proxmox, because Proxmox itself is
really three things bundled together, and on NixOS each of those is its own
composable piece (`modules/nixos/homelab-virt.nix`):

- **libvirt/QEMU** — the actual hypervisor for full VMs (same engine
  Proxmox runs under the hood). `virt-manager` is installed for a desktop
  GUI over SSH/X-forwarding if you want it.
- **Podman** — the container runtime, Proxmox's "CT" equivalent but
  lighter. NixOS's own declarative `containers.<name>` (systemd-nspawn) is
  also available for anything you'd rather define entirely in Nix.
- **Cockpit** — the web dashboard, with the `cockpit-machines`,
  `cockpit-podman`, and `cockpit-storaged` pages installed. This is the
  part that actually feels like Proxmox's UI: `https://vyke:9090` (or over
  Tailscale from anywhere).

On top of that, `modules/nixos/media-stack.nix` sets up the full arr stack
plus what feeds and serves it:

| Service      | Port | Role                    |
| ------------ | ---- | ------------------------ |
| Prowlarr     | 9696 | Indexer manager          |
| Sonarr       | 8989 | TV                       |
| Radarr       | 7878 | Movies                   |
| Lidarr       | 8686 | Music                    |
| Readarr      | 8787 | Books                    |
| Bazarr       | 6767 | Subtitles                |
| qBittorrent  | 8080 | Download client          |
| Jellyfin     | 8096 | Media server             |

All of these open their firewall port on Vyke only — reach them over
Tailscale rather than exposing the box to the open internet. Vyke is still
a placeholder pending real hardware (see `modules/flake/hosts.nix` for the
exact, ready-to-uncomment block); everything above is written and waiting.

## Toggleable learning stacks

Three optional package sets, each behind its own NixOS option, off by
default: `mercnix.cybersecurity.enable`, `mercnix.devops.enable`,
`mercnix.sysadmin.enable`. See `modules/nixos/stack-*.nix` for exactly
what each one installs (mainstream, commonly-taught tools per area — Burp
Suite/nmap/hashcat/etc. for cybersecurity; Docker/Kubernetes/Terraform/
Ansible for devops; htop/borgbackup/fail2ban/etc. for sysadmin).

They're currently all switched on for Malenia and off for Radahn/Vyke —
flip them per host in `modules/flake/hosts.nix`:

```nix
extraModules = [
  { mercnix.devops.enable = true; }
];
```

## Rebuilding

```sh
sudo nixos-rebuild switch --flake .#$(hostname)
```

Or, before committing to a switch:

```sh
sudo nixos-rebuild build --flake .#Malenia   # builds without activating
nix flake check                              # evaluates every output
```

## Tips for growing this template

- **Commit before every rebuild.** Flakes only see git-tracked files —
  an untracked new file silently doesn't exist as far as the build is
  concerned. `git add -A` first, always.
- **One file, one concern.** When in doubt about where something goes,
  it's almost always a new file under `modules/nixos/` or `modules/home/`,
  not an addition to an existing one. That's what keeps the dendritic
  pattern paying off as this grows for years.
- **`nixos-option` and `search.nixos.org/options`** are your friends for
  checking an option's current shape before writing it — module options
  do shift between nixpkgs releases, especially for young projects like
  Noctalia/Umbriel.
- **Secrets don't belong in this repo as plaintext** (it's meant to go on
  GitHub). When you get to storing WireGuard keys, VPN credentials, etc.,
  look at [sops-nix](https://github.com/Mic92/sops-nix) or
  [agenix](https://github.com/ryantm/agenix) rather than inlining them.
- **Test service changes on Vyke, not the desktop you're using right
  now.** A bad `nixos-rebuild switch` on Malenia mid-session is a rough
  afternoon; a bad one on the homelab is just a reboot away from fixed.
