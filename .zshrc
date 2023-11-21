if [ "$TMUX" = "" ]; then tmux; fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/sbodn/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # other plugins...
  git
  zsh-autosuggestions
  dotenv
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
bundle_install_wrapper() {
  # Run command

  eval "$@"
    if [ $? = 7 ]; then
      # If command crashes, try a bundle install
      echo -e "\033[1;31m'$@' failed with exit code 7."
  echo "This probably means that your system is missing gems defined in your Gemfile."
  echo -e "Executing 'bundle install'...\033[0m"
  bundle install # If bundle install was successful, try running command again.
  if [ $? = 0 ]; then
  echo "'bundle install' was successful. Retrying '$@'..."
        eval "$@"
  fi
  fi
}

alias v="nvim"
alias vi="nvim"

# Rails aliases
alias rs="bundle_install_wrapper rails s"
alias rc="bundle_install_wrapper rails c"
alias r="rails"
alias q="exit"
alias pras='RAILS_ENV=test rake parallel:drop && RAILS_ENV=test rake parallel:create && RAILS_ENV=test rake parallel:migrate'
alias ras='bundle_install_wrapper RAILS_ENV=test bundle exec rake db:drop && RAILS_ENV=test bundle exec rake db:create && RAILS_ENV=test bundle exec rake db:migrate'
alias rass='bundle_install_wrapper RAILS_ENV=test rake db:drop && RAILS_ENV=test rake db:setup'
alias pst="bundle_install_wrapper RAILS_ENV=test bundle exec rake parallel:drop && RAILS_ENV=test bundle exec rake parallel:create && RAILS_ENV=test bundle exec rake parallel:setup"
alias t="bundle exec rspec"
alias tp="bundle exec rake parallel:spec"
alias b="bundle"
trp(){
  CI_NODE_TOTAL=16 CI_NODE_INDEX=$1 bundle exec rake "knapsack:rspec[--seed $2]"
}

# Rubocop aliases
rbcs() {
  git status | grep modified: | cut -c 14- | xargs bundle exec rubocop
}
rbc()
{
  bundle exec pronto run --commit origin/$1 --runner rubocop
}
rrr()
{
  bundle exec rubocop $1
}

# services navigation
alias sts="cd ~/ruby/overhaul/sts"
alias gate="cd ~/ruby/overhaul/events_gate"
alias be="cd ~/ruby/overhaul/overhaul-backend"
alias bel="cd ~/ruby/overhaul/overhaul-backend-local"
alias fe="cd ~/ruby/overhaul/overhaul-frontend/web"
alias em="cd ~/ruby/overhaul/equipment_management"

# git
alias gcod="gco develop; gl origin develop; bundle"
alias gcom="gco master; gl origin master; bundle"
alias gpo='git push origin "$(git symbolic-ref --short HEAD)"'
alias tmp="gc -m '[~] tmp'"
alias tmp!="git add .; gc -a -m '[~] tmp'"
comm()
{
  git commit -m "[$(git symbolic-ref --short HEAD)] $1"
}
comma()
{
  git add .
  comm $1
}
comt() {
  if [[ -z $1 ]]; then
    branch=$(git branch --show-current)
  else
    branch=$1
  fi

  issue_key=$(jira issue view "$branch" --plain | grep '#' | sed -n '1 p' | sed 's/#//' | awk '$1=$1')
  comm "$issue_key"
}
create_pr() {
  gh pr create --title "$(git log -1 --pretty=%B)" --body "https://over-haul.atlassian.net/browse/$(git branch --show-current)"
}
release() {
  gpo -f && create_pr
}
release!() {
  gpo -f && (create_pr && review)
}
gcoa() {
  BRANCH=$(jira issue list -s "In Progress" -a$(jira me) --plain --columns key | sed -n '2 p')
  gco $BRANCH || gco -b $BRANCH

}
lhard() {
  git reset --hard HEAD
}
rhard() {
  git reset --hard origin/$(git branch --show-current)
}

# jira
review() {
  jira issue move $(git branch --show-current) "OH to Test"
}
progres() {
  jira issue move $(git branch --show-current) "In Progress"
}
to_deploy() {
  jira issue move $(git branch --show-current) "Ready for Deployment"
}
export JIRA_API_TOKEN="G4mQrafnzgK1zpYRRdCY834C"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# docker
docker_cleanup(){
  echo "before:"
  docker system df

  docker rm $(docker ps -qa --no-trunc --filter "status=exited")
  docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
  docker volume rm $(docker volume ls -qf dangling=true)

  echo "\nafter:"
  docker system df
}

# kubernetes
cfd()
{
  cloudflared access tcp --hostname kubectl.az-eastus-$1.over-haul.com --url 127.0.0.1:1234
}
cfd_prod()
{
  cloudflared access tcp --hostname kubectl.az-eastus-prod.over-haul.com --url 127.0.0.1:1232
}
cfd_stage()
{
  cloudflared access tcp --hostname kubectl.az-eastus-stage.over-haul.com --url 127.0.0.1:1233
}
cfd_dev()
{
  cloudflared access tcp --hostname kubectl.az-eastus-dev.over-haul.com --url 127.0.0.1:1234
}

get_ns ()
{
    kubectl get ns
}
get_pods ()
{
  # get pods on provided namespace or on backend-api
  if [[ -z $1 ]]; then
    kubectl get pods -n backend-api
  else
    kubectl get pods -n $1
  fi
}

# exec into a pod
enter_pode ()
{
    kubectl exec -it -n $1 $2 -- bash
}

# set current namespace so you don't have to put "-n ..." everywhere
nset ()
{
  export KUBECONFIG=~/.kube/oh-az-app-$1-aks.yaml
}
kube_back_connect() {
  export BACKEND=$(kubectl get pod -n backend-api | grep backend-api | grep Running | awk '{print $1}' | head -n1)
  kubectl exec -ti $BACKEND bash -n backend-api -- rails c
}
kube_gate_connect() {
  export BACKEND=$(kubectl get pod -n events-gate | grep events-gate | awk '{print $1}' | head -n1)
  kubectl exec -ti $BACKEND bash -n events-gate -- hanami c
}
kube_sts_connect() {
  export BACKEND=$(kubectl get pod -n sts-events-stream-consumer | grep sts-events-stream-consumer | awk '{print $1}' | head -n1)
  kubectl exec -ti $BACKEND bash -n sts-events-stream-consumer -- bin/console --noautocomplete
}
be_atqc() {
  export KUBEENV="dev"
  export BACKEND=$(kubectl --kubeconfig ~/.kube/oh-aws-us-east-1-app-dev.yaml -n atqc get pods | grep backend-api | awk '{print $1}' | head -n1)
  kubectl exec -ti $BACKEND bash -n atqc
}

setup_pod() {
  cd ~/ruby/overhaul/helm/charts/developer-testing
  gco main
  gl
  nset $1
  TAG_NAME=$(cat ~/ruby/overhaul/helm/apps/$2/$3/values-$1.yaml | grep tag | cut -d " " -f 6)
  echo $TAG_NAME

  helm upgrade --install "$(whoami)-$2"  . --set image=$2 --set env=$1 --set tag=$TAG_NAME --set ttl="24h" --namespace backend
}

enter_be_dev() {
  nset dev
  kubectl exec -ti "developer-testing-$(whoami)-overhaul-backend"  bash -n backend -- rails c
}
enter_be_prod() {
  nset prod
  kubectl exec -ti "developer-testing-$(whoami)-overhaul-backend" bash -n backend -- rails c
}
enter_be_stage() {
  nset stage
  kubectl exec -ti "developer-testing-$(whoami)-overhaul-backend" bash -n backend -- rails c
}
be_prod_up() {
  setup_pod prod overhaul-backend api
  cd -
  nset prod
}

enter_sts_prod() {
  nset prod
  kubectl exec -ti "developer-testing-$(whoami)-sts" bash -n backend -- bin/console
}
sts_prod_up() {
  setup_pod prod sts events-stream-consumer
  cd -
  nset prod
}
enter_gate_prod() {
  nset prod
  kubectl exec -ti "developer-testing-$(whoami)-events-gate" bash -n backend -- hanami c
}
gate_prod_up() {
  setup_pod prod events_gate gate
  cd -
  nset prod
}

delete_pod() {
  nset $1
  helm uninstall "$(whoami)-$2" --namespace backend
}
delete_gate_prod() {
  delete_pod prod events-gate
}
delete_be_prod() {
  delete_pod prod overhaul-backend
}
delete_sts_prod() {
  delete_pod prod sts
}

be_dev() {
  nset dev
  cfd_dev &
  kube_back_connect
}
sts_dev() {
  nset dev
  cfd_dev &
  kube_sts_connect
}
gate_dev() {
  nset dev
  cfd_dev &
  kube_gate_connect
}
be_stage() {
  nset stage
  cfd_stage &
  kube_back_connect
}
sts_stage() {
  nset stage
  cfd_stage &
  kube_sts_connect
}
gate_stage() {
  nset stage
  cfd_stage &
  kube_gate_connect
}
be_prod() {
  nset prod
  cfd_prod &
  kube_back_connect
}
sts_prod() {
  nset prod
  cfd_prod &
  kube_sts_connect
}
gate_prod() {
  nset prod
  cfd_prod &
  kube_gate_connect
}
doup() {
  colima start --cpu 4 --memory 6 --disk 20
  bel
  docker-compose -f docker-compose.development.yml up -d
  cd -
}
dodown() {
  bel
  docker-compose -f docker-compose.development.yml down
  colima stop
  cd -
}

combos() {
  echo '
    Ctrl + U Ð clear line
    Ctrl + K Ð delete from the cursor to the end of the line.
    Ctrl + W Ð delete from the cursor to the start of the preceding word.
    Alt + D Ð delete from the cursor to the end of the next word.
    Ctrl + L Ð clear the terminal.
  '
}

. /usr/local/opt/asdf/libexec/asdf.sh

export PATH="/usr/local/opt/node@14/bin:$PATH"
