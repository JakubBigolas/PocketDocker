function pdOptionStatus {

  [[ ! -z "$@" ]] && echo -e "${C_RED}Unhandled arguments: $@" && exit 1

  echo ""
  echo "Project name       : $PD_PROJECT_NAME"
  echo "Environment        : $PD_ENV"
  echo "Docker project dir : $PD_DOCKER_PROJECT_DIR"
  echo ""

}