function pdToolUpperCaseFirstLetter {
  local string=$1

  local firstLetter=`echo $string|cut -c1|tr [a-z] [A-Z]`
  local rest=`echo $string|cut -c2-`
  echo "$firstLetter$rest"
}