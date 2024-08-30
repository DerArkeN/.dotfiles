# this script requires you to have https://github.com/sam-mfb/git-credential-forwarder 's .js files in your home directory
containerHome="/home/vscode"

devcontainer up \
    --mount "type=bind,source=${HOME}/.config/nvim,target=${containerHome}/.config/nvim" \
    --mount "type=bind,source=${HOME}/gcf-client.js,target=${containerHome}/gcf-client.js" \
    --additional-features '{
                             "ghcr.io/duduribeiro/devcontainer-features/neovim:1":{"version": "stable"},
                             "ghcr.io/devcontainers/features/node:1": {}
                           }' \
    --skip-post-create \
    --workspace-folder .

# save container id for later
containerId=$(devcontainer exec --workspace-folder . cat /etc/hostname)

# credential forward setup
export GIT_CREDENTIAL_FORWARDER_PORT=35712
devcontainer exec --workspace-folder . \
    sed -i '$ a\export GIT_CREDENTIAL_FORWARDER_SERVER=host.docker.internal:'"${GIT_CREDENTIAL_FORWARDER_PORT}"'' ${containerHome}/.bashrc # sed has to be used because redirections(>>) aren't working
devcontainer exec --workspace-folder . \
    git config --global credential.helper '!f() { node ~/gcf-client.js $*; }; f'

echo \n
echo '---Run this to start the shell in the devcontainer:---'
echo '   devcontainer exec --workspace-folder . /bin/bash'
echo '------------------------------------------------------'
echo \n

function cleanup() {
    kill 0
    docker stop ${containerId};
}
(trap cleanup EXIT; node ~/gcf-server.js) # stop the server on exit
