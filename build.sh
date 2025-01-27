
eval "$(micromamba shell hook --shell bash)"

SCRIPT_DIR=$(dirname "$0")
CANON_SCRIPT_DIR=$(cd "$SCRIPT_DIR"; pwd)

micromamba activate emscripten-forge
pushd ~/emscripten-forge
python builder.py build explicit $CANON_SCRIPT_DIR/recipes/swift-sim --emscripten-wasm32 --no-skip-existing
popd
micromamba deactivate

micromamba activate react-swift
pushd $SCRIPT_DIR/react-swift
# node --version
# npm --version
npm install
rm -r dist
npm run build
popd

pushd $SCRIPT_DIR/swift/next-swift
rm -r ../swift/out
npm install
npm run build
popd
micromamba deactivate

micromamba activate pyjs-wasm-env
node --version
micromamba install swift-sim -y
micromamba update  swift-sim -y

SCRIPT_DIR=$(dirname "$0")

source $SCRIPT_DIR/pack.sh

micromamba deactivate
