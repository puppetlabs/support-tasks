$LOCKFILE="$(cmd.exe /c puppet config print statedir)/agent_disabled.lock"

Write-Output "This task is deprecated and will be removed in a future release. Please see this module's README for more information"
if(Test-Path $LOCKFILE) {
  Write-Output "Puppet agent is disabled"
  cat $LOCKFILE
}
else {
  Write-Output "Puppet agent is enabled"
  EXIT 1
}
