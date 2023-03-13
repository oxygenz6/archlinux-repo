# Arch Repo Filesystem

This image builds Archlinux packages from provided PKGBUILD files, and then adds em to a Custom user repository.

The custom user repository is created within `/data/build` directory and it can be used as with any WebServer that's able to serve static files from filesystem.

## Usage

### Building Image

First we need to build Docker image from `Dockerfile`.

Nothing special happens in the Build Image phase, We create a user who does our buildings and add the `entrypoint.sh` which contains `build_packages` and `add_packages_to_repository` functions.

```sh
docker build . -t archlinux-repo
```

> Arm64 users might need to specify platform.
>
> ```sh
> docker build . -t archlinux-repo --platform linux/amd64
> ```

### Preparing `PKGBUILD` files

You need to create a directory within `/data/src/$arch` for each package you want to serve, and this directory must contain the `PKGBUILD` file for the package.

An example is included in `/data/src/x86_64/tun2socks-bin` directory

When you do have all the `PKGBUILD` files you need, You can start a container from the built image.

### Using container to create repository

We need to mount our `data` directory from Host to Container on `/data` volume.

```sh
docker run --rm -v `pwd`/data:/data archlinux-repo
```

- `--rm`: remove container afterwards
- `-v`: Mounts `./data` (Host) to `/data` (Container)

After the command is executed successfully, everything is almost ready
You can serve `/data/build` directory using a WebServer.

> Take a look at [here](https://wiki.archlinux.org/title/Pacman#Repositories_and_mirrors) to learn how to add your repo to your `pacman.conf`

## What does this image do?

It runs the `entrypoint.sh` which basically builds the packages (using `build_packages`) and then builds the repository's root in `/data/build/$arch` (using `add_packages_to_repository`)

> `build_packages` function, searches through directories within `/data/src` looking for `PKGBUILD`, and runs a for each loop over the result to build the `PACKAGE_NAME.pkg.tar.zst` file; After the output is generated, it moves the output to `/data/build/$arch/PACKAGE_NAME.pkg.tar.zst`.

> `add_packages_to_repository` function, adds all found `*.pkg.tar.zst` files to the `packages.db.tar.gz` (our repo database) file of the repository, It won't fail if the `packages.db.tar.gz` file does not exist yet.
