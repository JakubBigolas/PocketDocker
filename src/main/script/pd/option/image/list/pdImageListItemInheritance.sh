function pdImageListItemInheritance {
  local printVersion=$1
  shift
  local printFormatted=$1
  shift
  local printPath=$1
  shift
  local printInheritanceinverted=$1
  shift
  local image=$1
  shift
  local allImages=($@)

  # prepare start and end format of line
  local beginFormat=
  [[ $printFormatted = true ]] && beginFormat="   - ${C_WHITE}"
  local endingFormat=
  [[ $printFormatted = true ]] && endingFormat="${C_RESET}"

  # loop per all available image in project to find config of current image
  for imageToFind in ${allImages[@]}
  do
    local imageName=${imageToFind/\{*/}
    local path=${imageToFind/*\{/}
    local path=${path/\}/}

    # image found by name
    if [[ "$image" = "$imageName" ]]; then

      # find FROM clause in docker file
      local fromWithVersion=$(cat "$path/Dockerfile" | grep -e "^FROM ")
      fromWithVersion=${fromWithVersion/FROM /}

      # parent image name without version from FROM clause
      local from=${fromWithVersion/:*/}

      # loop per all available image in project to find config of parent image
      for anyImage in ${allImages[@]}
      do

        # parent image name
        local parentImageName=${anyImage/\{*/}

        # if there is config for parent image
        if [[ "$parentImageName" = "$from" ]]; then

          # parent path
          local parentPath=
          [[ $printPath = true ]] && parentPath=${anyImage/*\{/} && parentPath="{$parentPath"

          # parent info formatted
          local fromFormatted=$from
          [[ $printFormatted = true ]] && fromFormatted="$from${C_RESET}"

          # version number of parent from FROM clause
          local versionNumber=
          if [[ $printVersion = true ]]; then
            versionNumber=${fromWithVersion/$from/}
            versionNumber=${versionNumber/:/}
            [[ $printFormatted = true  ]] && [[ ! -z $versionNumber ]] && versionNumber="${C_CYAN}:${C_BLUE}$versionNumber${C_RESET}"
            [[ $printFormatted = false ]] && [[ ! -z $versionNumber ]] && versionNumber=":$versionNumber"
          fi

          # if inheritance is printed inverted way then perform recurrence before printing this iteration info
          [[ $printInheritanceinverted = true ]] && pdImageListItemInheritance $from "${allImages[@]}"

          # print this iteration info
          echo -e "$beginFormat$fromFormatted$versionNumber$parentPath$endingFormat"

          # if inheritance is printed normal way then perform recurrence after printing this iteration info
          [[ ! $printInheritanceinverted = true ]] && pdImageListItemInheritance $from "${allImages[@]}"

          break # there is no reason to continue sub loop
        fi
      done

      break; # there is no reason to continue main loop
    fi

  done

}