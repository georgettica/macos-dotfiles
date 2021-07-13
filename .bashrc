export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}:${HOME}/go/bin:${HOME}/.krew/bin"

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
source "${HOME}/Repo/gogitmail/env.source"

PROMPT_DIRTRIM=3
HISTCONTROL=ignoreboth
PS1="\[\e[00;35m\]\$ \w \[\e[0m\]"

export GREP_OPTIONS='--color=auto'
export CLICOLOR=1

CRC_MACHINE=$(gcloud compute instances list | grep $(whoami))
CRC_MACHINE_NAME=${CRC_MACHINE_NAME:-$(echo $CRC_MACHINE | cut -d' ' -f1 | tr -d [:space:])}
CRC_MACHINE_ZONE=${CRC_MACHINE_ZONE:-$(echo $CRC_MACHINE | awk '{print $2}' | tr -d [:space:])}

if [[ "$(dscl . -read /Users/rogreen UserShell | cut -d: -f2  | tr -d '[:space:]' )" !=  '/usr/local/bin/bash' ]]; then
	chsh -s /usr/local/bin/bash
fi

alias config='/usr/bin/git --git-dir=/Users/rogreen/.cfg/ --work-tree=/Users/rogreen'
alias gcloud-crc-external='gcloud compute instances describe $CRC_MACHINE_NAME --zone $CRC_MACHINE_ZONE --format "text(networkInterfaces[0].accessConfigs[0].natIP:label="external",networkInterfaces[0].networkIP:label="internal")" | yq e ".external" -'
alias gcloud-crc-ssh-add='ssh-add ~/.ssh/gcp'
alias gcloud-crc-ssh='ssh $CRC_MACHINE_NAME'
alias gcloud-crc-status='gcloud compute instances describe $CRC_MACHINE_NAME --zone $CRC_MACHINE_ZONE --format "get(status)" '
alias ls='ls --color=auto'
alias ocm-backplane-cwd='OCM_CONTAINER_LAUNCH_OPTS="-v ${PWD}:/root/cwd -w /root/cwd" ocm-container -t backplane'
alias ocm-backplane-stg-cwd='OCM_CONTAINER_LAUNCH_OPTS="-v ${PWD}:/root/cwd -w /root/cwd" OCM_URL=stg ocm-container -t backplane'
alias ocm-backplane-stg='OCM_URL=stg ocm-container -t backplane'
alias ocm-backplane='ocm-container -t backplane'
alias ocm-container-cwd='OCM_CONTAINER_LAUNCH_OPTS="-v ${PWD}:/root/cwd -w /root/cwd" ocm-container'
alias ocm-container-stg-cwd='OCM_CONTAINER_LAUNCH_OPTS="-v ${PWD}:/root/cwd -w /root/cwd" OCM_URL=stg ocm-container'
alias ocm-container-stg='OCM_URL=stg ocm-container'
alias vi=vim

vis() {
  eval $(echo "$@" | awk -F: '{print "vim", $1, "+" $2}')
}

gcloud-crc-toggle() {
  local gcloudCommand
  case $(gcloud-crc-status) in
	  "RUNNING") gcloudCommand="stop" ;;
	  "TERMINATED") gcloudCommand="start" ;;
	  *) echo "bad option, result is $(gcloud-crc-status)" ;;
  esac
  gcloud compute instances "$gcloudCommand" \
	  --zone europe-west4-b \
	  rogreen-crc1
}
