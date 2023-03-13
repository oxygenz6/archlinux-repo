function build_packages() {
    starting_dir=$(pwd)
    for file in $(find /data/src/ -name "PKGBUILD"); do
        src_pkg_dir=$(dirname $file)
        cd $src_pkg_dir
        makepkg -scfC # Build package
        pkg_arch_build_dir=$(basename $(dirname $src_pkg_dir))
        mkdir -p /data/build/$pkg_arch_build_dir
        mv ./*.pkg.tar.zst /data/build/$pkg_arch_build_dir/ # Move to propert architecture repository directory
    done
    cd $starting_dir
}

function add_packages_to_repository() {
    starting_dir=$(pwd)
    for file in $(find /data/build/ -name "*.pkg.tar.zst"); do
        src_pkg_dir=$(dirname $file)
        relative_file_name=$(basename $file)
        cd $src_pkg_dir
        repo-add ./packages.db.tar.gz $relative_file_name # Add package to repo
    done
    cd $starting_dir
}

build_packages
add_packages_to_repository
