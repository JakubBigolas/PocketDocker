function pdImageBuildItem {
  local image=$1    ; shift
  local paramSilent=$1  ; shift
  local startScript=$(pdToolStartScript)

  echo -e ""
  echo -e "@ Start build proces "
  echo -e ""

  # split image to name and version
  local imageName="${image/":"*/}"
  local imageVersion=${image/"$imageName"/}
        imageVersion=${imageVersion/":"/}

  # read image path from image list query
  local imagePath="$(pdImageList -p -N --image "$imageName")"
        imagePath=${imagePath/"{path:"/}
        imagePath=${imagePath/"}"/}
  [[ -z "$imageVersion" ]] && echo "WARNING: version not set, default value is 1.0" && imageVersion="1.0"

  # prepare docker naming
  local dockerImageName="$imageName:$imageVersion"
  local dockerLatestImageName="$imageName:latest"

  # prepare log paths
  local logPath="$imagePath/$imageVersion.log"
  local logLatestPath="$imagePath/latest.log"

  # print parametri
  printf "@ Image           ${C_WHITE}%s${C_RESET}\n" "$imageName"     ;
  printf "@ Version         ${C_BLUE}%s${C_RESET}\n"  "$imageVersion"  ;
  printf "@ Src             ${C_WHITE}%s${C_RESET}\n" "$imagePath"     ;
  printf "@ Log path        ${C_WHITE}%s${C_RESET}\n" "$logPath"       ;
  printf "@ Latest log path ${C_WHITE}%s${C_RESET}\n" "$logLatestPath" ;
  echo -e ""

  if [[ $paramSilent = true ]]; then
    docker build $imagePath/. -t $dockerImageName       &>	"$logPath" || exit 1
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