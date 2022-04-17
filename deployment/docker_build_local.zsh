DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

BUILD_VERSION="<BUILD_VERSION>"
BUILD_DATE="<BUILD_DATE>"
VCS_REF="<VCS_REF>"

docker build \
       --no-cache \
       -f "$DOTFILES_ROOT/deployment/Dockerfile" \
       -t tainvecs/dotfiles:local-test \
       --build-arg BUILD_VERSION="$BUILD_VERSION" \
       --build-arg BUILD_DATE="$BUILD_DATE" \
       --build-arg VCS_REF="$VCS_REF" \
       .
