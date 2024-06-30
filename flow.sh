#!/bin/bash

# It is a shell script for creating a branch from the git flow.
# Especially, it would be helpful for a small team with JIRA.

# Write 'bash flow.sh' and take procedures followed

# created: 24-06-12
# updated: 24-06-30
# @glenn-syj

# color codes
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
RESET='\e[0m'

# switch to develop and pull origin develop
git checkout develop
current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ $current_branch != "develop" ]]; then
    echo -e "${RED}No develop branch found.${RESET}"
    exit;
fi

echo "Pulling origin develop ..."
git pull origin develop
echo -e "\n"

# result: a variable where the branch name would be saved
result=""

# branch_types: an array where the branch types are stored
branch_types=( "feature" "bugfix" "release" "hotfix" )

# team_types: an array where the team types are stored
team_types=( "" "back" "front" )

# jira_prefix: jira prefix without any issue number
jira_prefix="SPR"

# trim(): a function for trimming the whole input string
trim() {
    local var="$@"
    var=$(echo "$var" | xargs)
    echo "$var"
}


# step 1: get and check the branch type input
while true; do

    # branch_idx: where the input value is stored
    echo -e "${GREEN}[1] feature [2] bugfix [3] release [4] hotfix ${RESET}"
    echo -e "${YELLOW}enter your branch type${RESET} [default = 1]: \c"
    read branch_idx
    # trim the blanks from the left-most and the right-most side
    branch_idx=$(trim $branch_idx)
    # when an enter or a space is put, the branch is set to feature
    if [ -z "$branch_idx" ]; then 
        branch_idx=1
    fi

    # input validation: join the branch tpye after passing only 1, 2, 3 and 4
    if [[ "$branch_idx" =~ ^[1234]$ ]]; then
        branch_idx=$((branch_idx - 1))
        branch_type=${branch_types[$branch_idx]}
        result="$branch_type"
        break;
    else
        echo -e "${RED}Invalid branch type.${RESET}"
    fi
done



# step 2: create a proper branch name bsaed on its type

# mid_step: a variable for saving the checkpoint when the input is invalid in [1] feature or [2] bugfix
# 0: team input, 1: JIRA issue input, 2: brief description input
mid_step=0

# case [1] feature [2] bugfix: {branch_type}/{team_type}/{jira_prefix}-{issue_num}-{brief_desc}
while [ $branch_idx -le 1 ]; do 

    # a step for getting the input of the team. 
    # If any team variable is not required, change the codes below to comments.
    if [ $mid_step -eq 0 ]; then
        echo -e "${GREEN}[1] none [2] back [3] front${RESET}"
        echo -e "${YELLOW}enter your team${RESET} [default = 1]: \c" 
        read team_idx
        # trim the blanks from the left-most and the right-most side
        team_idx=$(trim $team_idx)

        # set the default value with enter or space as [1] none, which does not append any string
        if [ -z "$team_idx" ] || [[ "$team_idx" =~ ^[1]$ ]]; then 
            team_idx=1
        fi

        # [1] none does not need further process
        if [[ "$team_idx" =~ ^[1]$ ]]; then
            ((mid_step++))

        # [2] back [3] front, append a team_type string
        elif [[ "$team_idx" =~ ^[23]$ ]]; then

            # step done: successfully get the input for a team variable
            team_idx=$((team_idx - 1))
            team_type=${team_types[$team_idx]}
            result="$result/$team_type"
            ((mid_step++))

        # improper input after the regex check
        else
            echo -e "${RED}Invalid team type.${RESET}"
            continue
        fi
    fi


    # a step for getting the issue number with JIRA. 
    # If any JIRA identifier is not required, change the codes below to comments.
    if [ $mid_step -eq 1 ]; then
        echo -e "${YELLOW}enter the JIRA issue number ${RESET}: \c" 
        read issue_num

        # trim the blanks from the left-most and the right-most side
        issue_num=$(trim $issue_num)

        # issue_num input should consist of singlular/mutliple digit(s)
        if [[ "$issue_num" =~ ^[0-9]+$ ]]; then    

            # step done: successfully get the input for a jira issue number variable
            result="$result/$jira_prefix-$issue_num"
            ((mid_step++))
        
        # improper input after the regex check
        else
            echo -e "${RED}Invalid jira issue number.${RESET}"
            continue
        fi
    fi

    # a step for getting a brief description of a branch. 
    # If any brief description is not required, change the codes below to comments.
    if [ $mid_step -eq 2 ]; then
        echo -e "${YELLOW}enter the brief description${RESET}: \c"
        read brief_desc
        # trim the blanks from the left-most and the right-most side
        brief_desc=$(trim $brief_desc)

        # brief_desc should consist of alphabets or spaces and not contain any special symbol except '-'
        if [[ -n "$brief_desc" ]] && [[ ! "$brief_desc" =~ [^a-zA-Z[:space:]-] ]] ; then    
            
            # join each words with replacing blanks as a single '-' and turn them into lower-cases
            brief_desc=$(echo "$brief_desc" | tr -s ' ' '-')
            brief_desc=$(echo "$brief_desc" | tr "[A-Z]" "[a-z]")
            
            # step done: successfully get the input for the brief description of a branch
            result="$result-$brief_desc"
            ((mid_step++))
            break
        
        # improper input after the regex check
        else
            echo -e "${RED}A brief description of a branch should not be empty.${RESET}"
            continue
        fi
    fi
done

# case [3] release [4] hotfix: {branch_type}/{version}
while [ $branch_idx -ge 2 ]; do

    echo -e "${YELLOW}enter the target version ${RESET}: \c"
    read target_version
    # trim the blanks from the left-most and the right-most side
    target_version=$(trim $target_version)

    # target_version should be a string like 'x.x.x' where x is a number
    if [[ "$target_version" =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then    
            result="$result/$target_version"
            break
    
    # improper input after the regex check
    else
        echo -e "${RED}Invalid version string.${RESET}"
        continue
    fi

done

# branch name checking manually 
echo -e "\nbranch name: ${GREEN}$result${RESET}" 
echo -e "${YELLOW}press enter to continue.${RESET}"
read consent;

# checkout to a created branch
if [[ $consent == "" ]]; then
    git checkout -b "$result"
else 
    echo -e "${RED}The process is canceled.${RESET}"
fi

