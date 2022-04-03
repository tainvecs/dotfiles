# git
alias g="git "

# git branch
alias gb="git branch "
alias gba="git branch -a "

# git status
alias gs="git status "

# git add
alias gaa="git add --all "

# git pull
alias gpl="git pull "

# git push
alias gph="git push "

# git commit
alias gcm="git commit "
alias gcma="git commit -a "
alias gcmam="git commit --amend "

# git checkout
alias gco="git checkout "
alias gct="git checkout --track "

# git stash
alias gsp="git stash push "
alias gsa="git stash apply "
alias gsclear="git stash clear "

# git merge
alias gm="git merge "

# git restore
alias gr="git restore "
alias grs="git restore --staged "

# git tag
alias gt="git tag "

# forgit
if type -f forgit::add >/dev/null; then

    # git add
    alias ga="forgit::add "
    
    # git log
    alias gl="forgit::log "
    
    # git diff
    alias gd="forgit::diff "

    # git checkout
    alias gcb="forgit::checkout::branch "
    alias gcf="forgit::checkout::file "
    alias gccm="forgit::checkout::commit "

    # git stash
    alias gss="forgit::stash::show "

    # git rebase
    alias grb="forgit::rebase "

    # git reset
    alias grh="forgit::reset::head "

    # git cherry-pick
    alias gchp="forgit::cherry::pick "

    # git ignore
    alias gi="forgit::ignore "

    # git clean
    alias gcln="forgit::clean "

else

    # git add
    alias ga="git add "
    
    # git log
    alias gl="git log "
    
    # git diff
    alias gd="git diff "

    # git checkout
    alias gcb="git checkout -b "
    alias gcf="git checkout -- "
    alias gccm="git checkout "

    # git stash
    alias gss="git stash show "

    # git rebase
    alias grb="git rebase "

    # git cherry-pick
    alias gchp="git cherry-pick "

fi

# git prune local branches
function gp(){

    git fetch

    # prune origin
    git_origin_ready_prune_branch=`git remote prune origin --dry-run`
    
    if [[ ! $git_origin_ready_prune_branch = "" ]];then
        echo $git_origin_ready_prune_branch
        while true; do
            read "?Do you want to prune these branches? " yn
            case $yn in
                [Yy]* ) git remote prune origin;
                        break;;
                [Nn]* ) break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi

    # prune local
    git_all_local_branch=`git for-each-ref --format '%(refname) %(upstream:track)' refs/heads`
    git_filtered_branch=`echo $git_all_local_branch | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'`
    git_filtered_branch_array=("${(f)git_filtered_branch}")

    if [[ ! $git_filtered_branch = "" ]];then
        echo "$git_filtered_branch"
        while true; do
            read "?Do you want to prune these branches? " yn
            case $yn in
                [Yy]* ) for rm_branch in $git_filtered_branch_array;
                        do;
                            git branch -D $rm_branch;
                        done;
                        break;;
                [Nn]* ) break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi

    # if no branch
    if [[ "$git_filtered_branch$git_origin_ready_prune_branch" = "" ]];then
        echo "No branch to be pruned."
        return 0
    fi

}