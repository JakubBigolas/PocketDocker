function pdCompose() {

  local selectedProjects=() # user selected docker compose projects
  local selectedPackages=() # user selected docker compose packages / sub-packages

  # unhandled arguments to be redirected to "docker compose"
  local unhandledArgs=()

  # command args loop
  while [[ $# -gt 0 ]]; do
    case $1 in

      # command project selection
      --project) selectedProjects+=("$2") ; shift ; shift ;;

      # command package selection
      --package) selectedPackages+=("$2") ; shift ; shift ;;

      # not handle, redirect to "docker compose"
      *)         unhandledArgs+=("$1")    ; shift ;;

    esac
  done

  # filter docker compose projects using compose list function
  local filteredComposes=()
  readarray -t filteredComposes < <(   pdComposeList -x -p "${selectedProjects[*]}" "${selectedPackages[*]}"   )

  # print queue before build
  echo ""
  echo "Perform: docker compose ${unhandledArgs[*]}"
  echo "For each filtered compose project: "
  local compose=
  for compose in "${filteredComposes[@]}" ; do
    local composePackage="${compose/":"*/}"
    local composeName="${compose/"$composePackage:"/}"
          composeName="${composeName/":"*/}"
    printf " - ${C_WHITE}%s${C_RESET}\n" "$composeName"
  done

  # perform "docker compose" command for every selected compose project
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