# NixConf

This is my personal configuration for **NixOS**, **Linux**, and **Darwin**.

This repository defines both system-level NixOS configurations and user-level Home Manager environments, with simple-yet-clean modularity and cross-platform support.

---

## 📁 Repository Structure

```
.
├── flake.lock
├── flake.nix
├── home-manager
│   ├── modules        # Home Manager modules
│   └── users          # Home Manager user configs
├── hosts              # NixOS/Nix-Darwin System definitions
│   ├── giniro
│   ├── neptune
│   ├── qemu
│   ├── shirou
│   └── wsl
├── LICENSE
├── modules            # System-level modules
│   ├── darwin         # Darwin-specific system modules
│   ├── linux          # NixOS-specific system modules
│   └── shared         # Platform Agnostic modules
├── README.md
└── users              # System-level User Definitions
````

---

## 🚀 Getting Started

### Prerequisites

You must have:

- **Nix** installed  
- **Flakes enabled**  
  → https://nixos.wiki/wiki/Flakes

### Clone the repository

```bash
git clone git@github.com:theunpleasantowl/nixconf.git
cd nixconf
````

---

## 🖥️ System Configuration

Rebuild a NixOS host:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Examples:

```bash
sudo nixos-rebuild switch --flake .#neptune
```

Other useful commands:

```bash
# Test without switching
sudo nixos-rebuild test --flake .#neptune

# Build only
sudo nixos-rebuild build --flake .#neptune
```

---

## 🐧 WSL

Build the WSL tarball builder:

```bash
nix build .#wsl
```

Generate the tarball (requires root):

```bash
sudo ./result/bin/nixos-wsl-tarball-builder
```

Import into WSL from PowerShell:

```powershell
wsl --import NixOS .\NixOS\ .\nixos.wsl
```

---

## 💻 QEMU VM

Launch the QEMU VM directly:

```bash
nix run .#qemu
```

The VM runs with 4 GB RAM, 4 cores, virtio graphics, and GNOME. SSH is forwarded on host port 2222.

---

## 🏠 Home Manager (Linux + macOS)

Standalone Home Manager builds:

```bash
home-manager switch --flake .#hibiki
```

The Home Manager configurations in this repository are structured to be dual-use: the very same modules can be imported for system-level user definitions on NixOS or applied standalone in a user-level Home Manager environment.

---

# 👤 Managing Users

System-level user definitions are defined in `./users`.
Stand-alone home-manager definitions are defined in `./flake.nix`.


### Add a new home-manager configuration

1. Create a directory for the user:

```bash
mkdir -p home-manager/users/alice
```

2. Add a Home Manager config:

```nix
{ inputs, system, lib, pkgs, config, username ? null, ... }: {
  imports = [
    ../../modules/shared
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    ../../modules/linux
  ];

  home.stateVersion = "25.11";
}
```

3. Register it in the flake outputs:

```nix
homeConfigurations.alice = mkHome {
  user = users.alice;
  system = systems.linux;
};
```

---

# 🖥️ Adding a New Host

1. Create a host directory:

```bash
mkdir -p hosts/newhost
```

2. Add `default.nix`:

```nix
{ ... }: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
```

3. Generate hardware config:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/newhost/hardware-configuration.nix
```

4. Add to `flake.nix`:

```nix
nixosConfigurations.newhost = mkNixOS {
  hostname = "newhost";
  user = users.hibiki;
  modules = [
    nixSettings
    ./modules/linux/steam.nix
  ];
};
```

---

# 🐞 Debugging & Maintenance

### Show NixOS evaluation output

```bash
nix eval .#nixosConfigurations.neptune.config.system.build.toplevel
```

### Show full trace

```bash
sudo nixos-rebuild switch --flake .#neptune --show-trace
```

### Build Home Manager without switching

```bash
home-manager build --flake .#hibiki
```

### Validate flake

```bash
nix flake check
```

### Update all flake inputs

```bash
nix flake update
```

### Update a single input

```bash
nix flake update nixpkgs
```

---

# 📄 License

This repository is licensed under the **MIT License**.
See the [`LICENSE`](LICENSE) file for details.

---
