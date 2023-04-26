function pdToolEndScript {
  local start_script=$1
  local end_script=`date +%s`;
  local diff=`expr $end_script - $start_script`;
  local hrs=`expr $diff / 360`;
  local min=`expr $diff / 60`;
  local sec=`expr $diff % 60`;
  echo "`printf %02d $hrs`:`printf %02d $min`:`printf %02d $sec`"
}