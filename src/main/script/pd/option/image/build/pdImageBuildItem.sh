function pdImageBuildItem {
  local imageName=$1
  local paramSilent=$2
  local startScript=$(pdToolStartScript)

  # get image version
  imageToBuild=$(pdImageList -a -p -v --image $imageName)

  imagePath=${imageToBuild/*\{/}
  imagePath=${imagePath/\}/}

  imageVersion=${imageToBuild/"{$imagePath}"/}
  imageVersion=${imageVersion/$imageName/}
  imageVersion=${imageVersion/:/}
  [[ -z "$imageVersion" ]] && echo "" && echo "WARNING: version not set, default value is 1.0" && imageVersion="1.0"

  local dockerImageName="$imageName:$imageVersion"
  local dockerLatestImageName="$imageName:latest"

  local logPath="$imagePath/$imageVersion.log"
  local logLatestPath="$imagePath/latest.log"

  echo -e ""
  echo -e "@ Start build proces "
  echo -e ""
  echo -e "@ Image           ${C_WHITE}$imageName${C_RESET}"
  echo -e "@ Version         ${C_BLUE}$imageVersion${C_RESET}"
  echo -e "@ Src             ${C_WHITE}$imagePath${C_RESET}"
  echo -e "@ Log path        ${C_WHITE}$logPath${C_RESET}"
  echo -e "@ Latest log path ${C_WHITE}$logLatestPath${C_RESET}"
  echo -e ""

  if [[ $paramSilent = true ]]; then
    docker build $imagePath/. -t   $dockerImageName     &>	"$logPath" || exit 1
    docker tag $dockerImageName $dockerLatestImageName  &>>	"$logPath" || exit 1

    local buildTime=$(pdToolEndScript "$startScript")
    local buildTimeEcho="@ Build [$imageName:$imageVersion] finish in $buildTime"
    echo $buildTimeEcho	&>> $logPath
    cat $logPath > $logLatestPath
  else
    echo "$ docker build $imagePath/. -t $dockerImageName"
    docker build $imagePath/. -t $dockerImageName || exit 1
    echo "$ docker tag $dockerImageName $dockerLatestImageName"
    docker tag $dockerImageName $dockerLatestImageName || exit 1
  fi

  local buildTime=$(pdToolEndScript "$startScript")
  echo -e "@ Build [${C_WHITE}$imageName${C_CYAN}:${C_BLUE}$imageVersion${C_RESET}] finish in ${C_WHITE}$buildTime${C_RESET}"
}