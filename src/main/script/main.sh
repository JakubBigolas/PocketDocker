function main {
  local home=$1

  local startScript=$(pdToolStartScript)
  local projectName=$PD_DEFAULT_PROJECT_NAME
  local env=$PD_DEFAULT_ENV
  local showTotalTime=false
  local hideHeader=false
  local option=

  shift # past argument with home path
  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|"-?")
        option="Help"
        shift
        break;
        ;;
      --show-totaltime)
        showTotalTime=true
        shift
        ;;
      -H)
        hideHeader=true
        shift
        ;;
      -p)
        projectName="$2"
        shift # past argument
        shift # past value
        ;;
      -e)
        env="$2"
        shift # past argument
        shift # past value
        ;;
      status|image|project|compose)
        option=$(pdToolUpperCaseFirstLetter "$1")
        shift
        break;
        ;;
      version)
        echo "0.0.1.dev"
        exit 0
        ;;
      *)
        echo "Unknown option $1"
        exit 1
        ;;
    esac
  done

  # Default option is "help"
  [[ -z "$option" ]] && option=Help

  # set global variables
  PD_PROJECT_NAME="$projectName"
  PD_ENV="$env"

  # set project/env projection for echo command
  local echoProject="${C_BLACK}${C_BG_BLUE}$projectName${C_RESET}"
  local echoEnv="${C_BLACK}${C_BG_BLUE}$env${C_RESET}"
  [[ -z $projectName ]] && echoProject="-"
  [[ -z $env ]] && echoEnv="-"

  # Welcome text
  [[ $hideHeader = false ]] && echo -e "DockerPocket ${C_GREEN}1.0${C_RESET} $echoProject/$echoEnv"

  eval pdOption$option "$@"

  [[ $showTotalTime = true ]] && echo "total time $(pdToolEndScript "$startScript")"

}