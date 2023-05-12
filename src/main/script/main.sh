function main {

  # save start script timestamp
  local startScript=$(pdToolStartScript)

  # flag to print total time at the end
  local showTotalTime=false

  while [[ $# -gt 0 ]]; do
    case $1 in

      # print help info and exit
      help|--help|"-?")       pdOptionHelp                  ; exit 0 ;;

      # print version info and exit
      version|--version|-v)   echo "1.0.0"                  ; exit 0 ;;

      # print docker project path variable and exit
      --docker-project-path)  echo "$PD_DOCKER_PROJECT_DIR" ; exit 0 ;;

      # set flags
      --totaltime)   showTotalTime=true ; shift ;;

      # sub option select and break args loop
      image)         shift ; pdOptionImage "$@"   ; break ;;
      compose)       shift ; pdOptionCompose "$@" ; break ;;

      # ignore empty
      "") shift ;;

      # Error unknown
      *) echo "Unknown option $1" ; exit 1 ;;

    esac
  done

  # print total time if requested
  [[ $showTotalTime = true ]] && echo "total time $(pdToolEndScript "$startScript")"

  exit 0
}