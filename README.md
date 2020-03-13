# b

I check this repo out at `/b`, and am starting to treat it as a kind of monorepo.

This used to be my dotfiles repo. The entrypoint to all of that stuff now lives at
`etc/nix/home.nix`.

## Setup (NixOS)

1. Clone this to `/b`
2. `cp /etc/nixos/configuration.nix{,.bak}`
2. `ln -sf /b/etc/nix/nixos.nix /etc/nixos/configuration.nix`

## Setup (Darwin)

First, create a few directories at `/` (this script is untested):

```bash
setup_root_mount() {
  path=$1
  name=$2
  echo $path | sudo tee -a /etc/synthetic.conf
  /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -B
  echo "LABEL=$name /$path apfs rw" | sudo tee -a /etc/fstab
  sudo diskutil apfs addVolume disk1 APFSX $name -mountpoint /$path
  sudo diskutil enableOwnership /$path
  sudo chown -R $(whoami) /$path
  passphrase=$(ruby -rsecurerandom -e 'puts SecureRandom.hex(32)')
  uuid="$(diskutil info /nix | awk '$2 == "UUID:" { print $3 }')"
  echo $passphrase | sudo diskutil apfs enableFileVault /$path -user disk -stdinpassphrase
  security add-generic-password \
    -l $name \
    -a $uuid \
    -s $uuid \
    -D "Encrypted Volume Password" \
    -w $passphrase \
    -T "/System/Library/CoreServices/APFSUserAgent" \
    -T "/System/Library/CoreServices/CSUserAgent"
}
setup_root_mount b B
setup_root_mount nix Nix
setup_root_mount run Run
```

Now:

1. Clone this to `/b`
2. Install nix
3. Install nix-darwin
4. `darwin-rebuild switch -I darwin-config=/b/etc/nix/darwin.nix`

Or on a shopify laptop:

Add to `~/.nix-channels`:

```
https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
https://github.com/rycee/home-manager/archive/f5c9303cedd67a57121f0cbe69b585fb74ba82d9.tar.gz home-manager
```

1. Clone this to `/b`
1. Run `dev update`
1. `nix-channel --update`
1. `export NIX_PATH=darwin-config=/b/etc/nix/darwin.nix:$NIX_PATH`
1. `nix-build '<darwin>' -A installer --out-link /tmp/nix-darwin && /tmp/nix-darwin/bin/darwin-installer`
1. `darwin-rebuild switch`

## Usage

`b up`
