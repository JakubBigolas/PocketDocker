function pdCompose() {


  local allComposes=()
  readarray -t allComposes < <(   pdComposeList -p -x   )


  local selectedProjects=()
  local selectedPackages=()
  local unhandledArgs=()

  while [[ $# -gt 0 ]]; do
    case $1 in

      # print help info
      --help|"-?"|help) shift ; eval pdComposeHelp "$@" ; exit 0 ;;

      --project) selectedProjects+=("$2") ; shift ; shift ;;

      --package) selectedPackages+=("$2") ; shift ; shift ;;

      *)         unhandledArgs+=("$1")    ; shift ;;

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
      local composeName="${compose/"$composePackage:"/}"
            composeName="${composeName/":"*/}"

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

  # print queue before build
  echo ""
  echo "Perform: docker compose ${unhandledArgs[*]}"
  echo "For each filtered compose project: "
  local compose=
  for compose in "${filteredComposes[@]}" ; do
    local composePackage="${compose/":"*/}"
    local composeName="${compose/"$composePackage:"/}"
          composeName="${composeName/":"*/}"
    printf " - ${C_WHITE}%s${C_RESET}\n" "$composeName"   ;
  done
  for compose in "${filteredComposes[@]}" ; do
    local composePackage="${compose/":"*/}"
    local composeName="${compose/"$composePackage:"/}"
          composeName="${composeName/":"*/}"
    local composePath="${compose/*"{path:"/}"
          composePath="${composePath/"}"/}"

    echo "docker compose --file \"$composePath/docker-compose.yml\" --project-name \"$composeName\" ${unhandledArgs[*]}"
    docker compose --file "$composePath/docker-compose.yml" --project-name "$composeName" ${unhandledArgs[*]}
    echo
  done


}