set -e
mise install
mkdir -p ~/bin
pushd ~/bin > /dev/null
ln -s ~/dots/run.sh dotman
popd > /dev/null
