# Nix Config

This repository contains my Nix configuration, organized using Nix Flakes. It aims to provide a reproducible and manageable environment for both system and home configurations.

## Structure

The configuration is divided into two main directories:

- **`nixos`**: Contains nixos configurations specific to various hosts.
- **`home`**: Contains home-manager configurations for user-scope settings and applications.

## Getting Started

### Prerequisites

Ensure you have the following installed:

- [Nix](https://nixos.org/download.html)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

### Cloning the Repository

Clone this repository to your local machine:

```bash
git clone git@github.com:theunpleasantowl/nixconf.git
cd nixconf
```

### Building the Configuration

To build the configuration for a specific host, navigate to the `hosts` directory and run:

```bash
nix build .#<host-name>
```

For example:

```bash
nix build .#my-laptop
```

To build the home configuration, navigate to the `home` directory:

```bash
nix build .#home
```

### Applying the Configuration

To apply the configuration, use the `nix switch` command for system configurations:

```bash
sudo nixos-rebuild switch --flake .#<host-name>
```

And for the home configuration:

```bash
home-manager switch --flake .#home
```

## Usage

- **Hosts**: Each host directory should contain a `flake.nix` file defining the system configuration for that specific machine.
- **Home**: The home directory contains a `flake.nix` file that manages user-level applications and settings.

## Contributing

Feel free to contribute to this configuration by submitting issues or pull requests. Make sure to follow the existing structure and maintain clarity in your changes.

## License

This configuration is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
