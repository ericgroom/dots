set -e
asdf install
mkdir -p ~/bin
pushd ~/bin > /dev/null
ln -s ~/dots/dotman.exs dotman
popd > /dev/null
