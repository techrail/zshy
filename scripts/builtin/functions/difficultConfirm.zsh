#!/usr/bin/env zsh

# This function gives the user a simple mathematical puzzle and returns 0 or 1 depending on whether the user was able
# to solve the problem or not (0 if he/she solved it, 1 otherwise).
# NOTE: This function is interactive and will print strings on the terminal when called.
function difficultConfirm() {
  local n1       # First number
  local n2       # Second number 
  local toss     # To decide if the mathematical operation is addition or multiplication
  local expected # The expected value of the expression result
  local exp_math # The mathematical expression (to be printed on screen to ask the user for input)
  local input    # The input as put in by the user

  n1=$((RANDOM%10))
  if [[ $n1 -eq 0 ]]; then 
    n1=1
  fi

  n2=$((RANDOM%10))
  if [[ $n2 -eq 0 ]]; then 
    n2=9
  fi

  toss=$((RANDOM%2))

  if [[ $toss -eq 1 ]]; then 
    # Addition 
    expected=$((n1+n2))
    exp_math="${n1} + ${n2}"
  else 
    # Multiplication
    expected=$((n1*n2))
    exp_math="${n1} * ${n2}"
  fi

  printf "\nEnter the result of the following expression\n$exp_math : "
  read input

  if [[ $input =~ ^[0-9]+$ ]]; then
    # The input was numerical
    if [[ $input -eq $expected ]]; then
      return 0
    else
      return 1
    fi 
  else 
    echo "Input is not a number"
    return 1
  fi
}


function difficultConfirm_oneliner() {
	echo "difficultConfirm: Asks the user a simple mathematical question and returns 0 if the user solved it, 1 otherwise."
}

function difficultConfirm_help() {
	echo "difficultConfirm asks the user a simple mathematical question and checks if the user solved it"
  echo "  It is a simple, yet effective tool to combat the mistakes caused by reflex human action"
  echo "  For example: when we press enter twice, accidentally; or when we press 'y' in a hurry "
  echo "  and trigger an unwanted action. Mistakes like these can range from 'negligible' to"
  echo "  'catastrophic'. difficultConfirm tries to mitagate these with a simple mathematical question"
  echo ""
  echo "Usage example:"
  echo "  echo \"Are you sure you want to continue? If yes, then please solve the following:\""
  echo "  difficultConfirm"
  echo "  if [[ $? -ne 0 ]]; then"
  echo "    echo \"Wrong answer. Cannot proceed.\""
  echo "    return 1"
  echo "  else"
  echo "    echo \"Thanks for the confirmation. Proceeding..."
  echo "    # Write your functional code here"
  echo "  fi"
  echo ""
  echo "Behaviour:"
  echo "  difficultConfirm selects two numbers between 1 and 9."
  echo "  It then selects a mathematical operation which is either addition or multiplication."
  echo "  It then asks the user to input the result of expression and checks the results"
  echo "  It returns 0 if the result was as expexted, it returns 0, otherwise it returns 1"
  echo "Caveat:"
  echo "  difficultConfirm prints text on terminal and there is no way to change that."
  echo "  Hence, you should not try to evaluate the echoed/printed value."
  echo "  That means you should never use it with the `\$()` expression!"
}
