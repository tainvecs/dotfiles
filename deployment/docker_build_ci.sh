# ------------------------------------------------------------------------------
# params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"


# ------------------------------------------------------------------------------
# build
# ------------------------------------------------------------------------------


# build tmp Dockerfile from template
# CLONE_DOTFILES_REPO_CMD="RUN git clone https://github.com/tainvecs/dotfiles.git"
CLONE_DOTFILES_REPO_CMD="ADD . /root/dotfiles"
RUN_BOOTSTRAP_SCRIPT_CMD="RUN cd dotfiles \&\& env DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES=true zsh ./scripts/bootstrap.zsh"

sed "s|%%CLONE_DOTFILES_REPO_CMD%%|$CLONE_DOTFILES_REPO_CMD|g; s|%%RUN_BOOTSTRAP_SCRIPT_CMD%%|$RUN_BOOTSTRAP_SCRIPT_CMD|g;" \
    "$DOTFILES_ROOT/deployment/Dockerfile.template" > "$DOTFILES_ROOT/deployment/Dockerfile.ci"

# build docker image
docker build \
       -f "$DOTFILES_ROOT/deployment/Dockerfile.ci" \
       -t "ghcr.io/tainvecs/dotfiles:$DOCKER_TAG" \
       --build-arg BUILD_VERSION="$BUILD_VERSION" \
       --build-arg BUILD_DATE="$BUILD_DATE" \
       --build-arg VCS_REF="$VCS_REF" \
       .

# tag with latest
docker tag "ghcr.io/tainvecs/dotfiles:$DOCKER_TAG" "ghcr.io/tainvecs/dotfiles:latest"

# push to github container registry
docker push "ghcr.io/tainvecs/dotfiles:$DOCKER_TAG"
docker push "ghcr.io/tainvecs/dotfiles:latest"
