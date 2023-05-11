function pdComposeList() {

  local printPackage=false
  local printProjectName=true
  local printPath=false

  local composesDir="$PD_DOCKER_PROJECT_DIR/composes"

  local composes=()
  readarray -t composes < <(find "$composesDir" -regex .*/docker-compose.yml$)

  # dockerfiles paths to packages
  local packages=("${composes[@]}")
  packages=("${packages[@]//"$composesDir/"/}")
  packages=("${packages[@]//"/docker-compose.yml"/}")
  packages=("${packages[@]//"\\"/"/"}")


  # add composes name and version info to every package
  local allComposes=()
  local package=
  for package in "${packages[@]}" ; do
    # by default compose name is package with - sign instead of / and \
    local projectName="$package"
    projectName="${projectName//"/"/-}"
    projectName="${projectName//"\\"/-}"

    # try retrieve specified compose name from file
    local projectNameFile="$composesDir/$package/project-name"
    if [[ -f "$projectNameFile" ]] ; then
      local projectNameFromFile=
      projectNameFromFile="$(head -n 1 "$projectNameFile")"
      [[ -n "$projectNameFromFile" ]] && projectName="$projectNameFromFile"
    fi

    # concatenate all info in one line and add to all composes array
    allComposes+=("$package:$projectName")
  done



  local selectedProjects=()
  local selectedPackages=()

  while [[ $# -gt 0 ]]; do
    case $1 in

      # flags
      -x) printPackage=true        ; shift ;;
      -N) printProjectName=false   ; shift ;;
      -p) printPath=true           ; shift ;;

      # print help info
      --help|"-?"|help) shift ; eval pdComposeListHelp "$@" ; exit 0 ;;

      # pick compose by name
      --project) selectedProjects+=("$2") ; shift ; shift ;;

      # pick all composes from package
      --package) selectedPackages+=("$2") ; shift ; shift ;;

      # pick all composes from package
      *)         selectedPackages+=("$1") ; shift ;;

    esac
  done

  
  local filteredComposes=()

  # get all composes if there are no filter
  if [[ ${#selectedPackages[@]} = 0 ]] && [[ ${#selectedProjects[@]} = 0 ]] ; then
    filteredComposes=("${allComposes[@]}")

  # or filter them by package or compose name
  else
    local compose=
    for compose in "${allComposes[@]}" ; do
      local composePackage="${compose/":"*/}"
      local composeName="${compose/*":"/}"

      local selected=false

      # packages filter
      local selectedPackage=
      for selectedPackage in "${selectedPackages[@]}" ; do
        [[ "$composePackage/" =~ ^$selectedPackage//* ]] && selected=true && continue
      done
      [[ $selected = true ]] && filteredComposes+=("$compose") && continue

      # compose names filter
      local selectedImage=
      for selectedImage in "${selectedProjects[@]}" ; do
        [[ "$composeName" = "$selectedImage" ]] && selected=true && continue
      done
      [[ $selected = true ]] && filteredComposes+=("$compose") && continue

    done
  fi

  # for each filtered position
  local item=
  for item in "${filteredComposes[@]}" ; do
    local lineToPrint=""

    local composePackage="${item/":"*/}"
    local composeProjectName="${item/*":"}"
    local composePath="$composesDir/$composePackage"

    [[ $printPackage     = true ]] && lineToPrint+="$composePackage"
    [[ $printProjectName = true ]] && lineToPrint+="${lineToPrint:+":"}$composeProjectName"
    [[ -n "$lineToPrint" ]] && [[ $printPath        = true ]] && lineToPrint+="${lineToPrint:+":"}{path:$composePath}"
    [[ -z "$lineToPrint" ]] && [[ $printPath        = true ]] && lineToPrint+="$composePath"

    echo "$lineToPrint"
#    pdImageListItem "$imagesDir" "$item" $printFormatted $printPackage $printProjectName $printPath "${prevItem/":"*/}"
  done

}