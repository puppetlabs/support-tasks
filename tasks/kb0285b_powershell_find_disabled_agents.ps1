$LOCKFILE="$(cmd.exe /c puppet config print statedir)/agent_disabled.lock"

if(Test-Path $LOCKFILE) {
  Write-Output "Puppet agent is disabled"
  cat $LOCKFILE
}
else {
  Write-Output "Puppet agent is enabled"
  EXIT 1
} 