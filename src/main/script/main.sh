function main {

  # save start script timestamp
  local startScript=$(pdToolStartScript)
  local showTotalTime=false

  while [[ $# -gt 0 ]]; do
    case $1 in
      help|--help|"-?")
        pdOptionHelp
        break;
        ;;
      version|--version|-v)
        echo "0.0.1.dev"
        break;
        ;;
      --totaltime)
        showTotalTime=true
        shift
        ;;
      image)
        shift
        pdOptionImage "$@"
        break;
        ;;
      compose)
        shift
        pdOptionCompose "$@"
        break;
        ;;
      *)
        echo "Unknown option $1"
        exit 1
        ;;
    esac
  done

  [[ $showTotalTime = true ]] && echo "total time $(pdToolEndScript "$startScript")"

  return 0
}