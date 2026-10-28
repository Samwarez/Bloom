# Bloom

Bloom installs and manages [PetalOS](https://github.com/Samwarez/PetalOS) on portable drives. It has a soft pink desktop interface, verified release downloads, independently encrypted OS/settings/Private storage, OS-only updates, and drive wiping.

## Download and run

Get the Linux amd64 portable archive from [Bloom releases](https://github.com/Samwarez/Bloom/releases). Extract the whole folder and run the launcher as your normal desktop user:

```sh
sha256sum -c bloom-0.4.4-linux-amd64.tar.gz.sha256
tar -xzf bloom-0.4.4-linux-amd64.tar.gz
./bloom-0.4.4-linux-amd64/bloom
```

Keep the extracted folder together. No package installation or FUSE is required. The initial supported target is Debian 13 and compatible amd64 desktops with merged `/usr`. Your desktop must provide `pkexec` and an administrator authorization agent. Bloom asks for administrator authorization when a drive operation starts.

The Debian package is an alternative:

```sh
sudo apt install ./bloom-installer_0.4.4_all.deb
bloom
```

VPN and other settings imports support source folders linked to another filesystem, such as a linked Downloads folder. Select the original regular file when the file itself is a shortcut.

On the SYSTEM settings page, **Browse SYSTEM folders…** opens your normal file manager with a private RAM working copy. Authorize and unlock once, then browse and drag files without repeated prompts or runtime transfers. Use `Files` for general files, `Network/Profiles` for VPN profiles, and `Wallpapers` for PNGs. Return to Bloom to **Save changes and lock** or **Discard and lock**. All changed settings are validated before writes. Private and administrator credentials stay excluded. The working copy is limited to 128 MiB; see the app instructions for scope and cleanup details.

Bloom and PetalOS have separate releases. In Bloom, choose a published PetalOS version and build, download it, then review the selected drive and operation. The default OS repository is `Samwarez/PetalOS`. Only published builds appear; a private repository requires session-only GitHub access. See [PetalOS releases](https://github.com/Samwarez/PetalOS/releases).

## Protection tiers

All tiers use LUKS2, AES-256-XTS with two 256-bit keys, and Argon2id. They change passphrase-guessing and unlock costs; ongoing disk encryption uses the same cipher.

| Tier | Intended use | Argon2id memory | Initial unlock work per volume |
| --- | --- | --- | --- |
| Fast — Legacy Friendly | Older computers | 32–64 MiB | About 1 second |
| Balanced — Recommended | Modern computers; default | 256–512 MiB | About 2 seconds |
| Paranoid — Maximum Protection | Expensive offline guessing | 1–2 GiB | About 5 seconds |

Bloom calibrates CPU/RAM costs before erasing a drive and refuses unmet memory floors. OS and settings unlock sequentially from one SYSTEM prompt; Private uses a separate passphrase. Choose for the oldest computer you intend to boot. Use distinct, randomly generated passphrases. Every tier requires at least 15 characters for SYSTEM and administrator passwords, and 24 for Private. A live, local strength meter flags common words and predictable patterns while you type. Spaces are allowed; no special character mix is required. Length alone does not measure entropy, and the meter is an estimate, not a guarantee. Existing drives keep their current passwords.

AES-256 has a strong margin against known quantum key-search attacks in every tier. No tier guarantees protection against every adversary or a compromised computer. This version supports passphrases only. Read the [encryption design](docs/bloom-encryption.md) and [complete app instructions](local/installer/README.md).

## Source and builds

The source tree retains the tested `local/installer` layout and the small shared PetalOS helpers needed by Bloom. The internal Python package name `petal_installer` and OS catalog names are compatibility interfaces.

```sh
python3 -B -m unittest discover -s local/installer/tests
python3 -B local/installer/build-package.py --output dist
python3 -B local/installer/build-portable.py --output dist
```

The portable builder needs Debian trixie amd64, GCC/static libc development files, and the runtime packages listed in `build-portable.py`. It reads checksum-verified package files without installing anything. The release workflow provides a clean Debian builder, runs all tests including GTK under Xvfb, and checks the resulting portable runtime before publishing. Distribution license texts and exact package versions accompany the portable runtime.

Source commands:

```sh
scripts/bloom --help
scripts/bloom releases
scripts/bloom variants --version VERSION
scripts/bloom download --version VERSION --variant base --destination ./petalos-download
scripts/bloom verify ./petalos-download
```

Releases are development builds for testing. Previous disposable-VM checks covered installation, OS-only updates preserving settings/Private ciphertext, cancellation, wipe/readback and signed UEFI startup. A synthetic boot probe is not full desktop or hardware acceptance. Sam has separately reported a successful desktop administrator prompt and quick wipe. The source tests never select or modify physical disks.

Original project code has no blanket license grant assigned yet. Retained third-party code and redistributed Debian components remain subject to their respective licenses; see [NOTICE](NOTICE.md).
