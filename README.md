# NekoTV OS
An immutable Linux distro for Smart TVs and HTPCs.


### Justfile Documentation

This `Justfile` contains various commands and configurations for building and managing container images and virtual machine images using Podman and other utilities.

#### Environment Variables

- `image_name`: The name of the image (default: "image-template").
- `default_tag`: The default tag for the image (default: "latest").
- `bib_image`: The Bootc Image Builder (BIB) image (default: "quay.io/centos-bootc/bootc-image-builder:latest").

#### Aliases

- `build-vm`: Alias for `build-qcow2`.
- `rebuild-vm`: Alias for `rebuild-qcow2`.
- `run-vm`: Alias for `run-vm-qcow2`.


#### Commands

###### `check`

Checks the syntax of all `.just` files and the `Justfile`.

###### `fix`

Fixes the syntax of all `.just` files and the `Justfile`.

###### `clean`

Cleans the repository by removing build artifacts.

##### Build Commands

###### `build`

Builds a container image using Podman.

```bash
just build $target_image $tag
```

Arguments:
- `$target_image`: The tag you want to apply to the image (default: `$image_name`).
- `$tag`: The tag for the image (default: `$default_tag`).

##### Building Virtual Machines and ISOs

###### `build-qcow2`

Builds a QCOW2 virtual machine image.

```bash
just build-qcow2 $target_image $tag
```

###### `build-raw`

Builds a RAW virtual machine image.

```bash
just build-raw $target_image $tag
```

###### `build-iso`

Builds an ISO virtual machine image.

```bash
just build-iso $target_image $tag
```

###### `rebuild-qcow2`

Rebuilds a QCOW2 virtual machine image.

```bash
just rebuild-qcow2 $target_image $tag
```

###### `rebuild-raw`

Rebuilds a RAW virtual machine image.

```bash
just rebuild-raw $target_image $tag
```

###### `rebuild-iso`

Rebuilds an ISO virtual machine image.

```bash
just rebuild-iso $target_image $tag
```

##### Run Virtual Machines

###### `run-vm-qcow2`

Runs a virtual machine from a QCOW2 image.

```bash
just run-vm-qcow2 $target_image $tag
```

###### `run-vm-raw`

Runs a virtual machine from a RAW image.

```bash
just run-vm-raw $target_image $tag
```

###### `run-vm-iso`

Runs a virtual machine from an ISO.

```bash
just run-vm-iso $target_image $tag
```

###### `spawn-vm`

Runs a virtual machine using systemd-vmspawn.

```bash
just spawn-vm rebuild="0" type="qcow2" ram="6G"
```

##### Lint and Format

###### `lint`

Runs shell check on all Bash scripts.

###### `format`

Runs shfmt on all Bash scripts.

## Community Examples

- [m2Giles' OS](https://github.com/m2giles/m2os)
- [bOS](https://github.com/bsherman/bos)
- [Homer](https://github.com/bketelsen/homer/)
- [Amy OS](https://github.com/astrovm/amyos)
- [VeneOS](https://github.com/Venefilyn/veneos)
