plan support_tasks::kb0XXX_preupgrade_check(
  TargetSpec $nodes,
  Boolean    $fail_plan_on_errors = true,
  Integer    $time_skew = 60,  ## May want to keep under 300 seconds due to hitting SSL limitations.
  Boolean    $debug = false,
) {
  if $nodes.empty { return ResultSet.new([]) } 
  $os_results = run_task(support_tasks::kb0XXX_check_os, $nodes, '_catch_errors' => true )
  $time_results = run_task(support_tasks::kb0XXX_check_time, $nodes, '_catch_errors' => true )
  $targets = $os_results.targets

  $failed_results = $os_results.error_set()
  $failed_targets = ResultSet($failed_results).targets()
    $failures = $os_results.map | $result | {
      $target = $result.target
      if $result['puppet-agent'] != 'running' {
        $err = true
        $agent_msg = 'Puppet agent is not running.'
      }
      else {
        $agent_msg = 'Puppet agent is running'
      }
  
      if $result['pxp-agent'] != 'running' {
        $err = true
        $pxp_msg = 'PXP agent is not running.'
      }
      else {
        $pxp_msg = 'PXP agent is running.'
      }

      $codedir_usage = Integer("${result['CodeDirectoryUsage']}")
      if $codedir_usage > 50 {
        $err = true
        $codedir_msg = "Code directory filesystem utilization of ${codedir}% is greater than 50% utilized."
      }
      else {
        $codedir_msg = 'Code directory filesystem utilization is ok.'
      }

      $puppetdir_usage = Integer("${result['PuppetDirectoryUsage']}")
      if $puppetdir_usage > 50 {
        $err = true
        $puppetdir_msg = 'Puppet directory filesystem is greater than 50% utilized.'
      }
      else {
        $puppetdir_msg = 'Puppet directory filesystem utilization is ok.'
      }

      $ca_time = $time_results.filter_set |$time_result| { $time_result['is_ca'] }.first['catime']
      $catime = Integer("${ca_time}")
      $time_value = $time_results.find($result.target().name())['mytime']
      $mytime = Integer("${time_value}") 
      if $catime > $mytime {
        $delta = $catime - $mytime
      }
      else {
        $delta = $mytime - $catime
      }
      if $delta > $time_skew {
        $time_msg = "Time variance is greater than ${time_skew} seconds from the time of the PuppetCA."
      }
      else {
        $time_msg = 'Time delta is within acceptable the acceptable range of the PuppetCA.'
      }
      
      if defined('$err') {
        Result.new($target, {
           _has_errors       => true,
           _agent_output     => $agent_msg,
           _pxp_output       => $pxp_msg,
           _codedir_output   => $codedir_msg,
           _puppetdir_output => $puppetdir_msg,
           _time_output      => $time_msg,
          _output           => 'Please contact support prior to upgrading.',
          _error            => {
              msg  => 'At least one pre-upgrade check failed.',
              kind => 'bolt/plan/preupgrade_check'
            }
          })
      }
      else {
         Result.new($target, {
           _agent_output     => $agent_msg,
           _pxp_output       => $pxp_msg,
           _codedir_output   => $codedir_msg,
           _puppetdir_output => $puppetdir_msg,
           _time_output      => $time_msg,
         })        
      }
    }

  $failure_set = $failures.filter |$failed| {
    if $failed['_has_errors'] {
      true
    }
  }

  $error_set = Resultset.new($failure_set)

  if $debug {
    $total_results = $targets.map |$target| { 
      Result.new($target, {"os" => $os_results.find($target.name).to_data, "time" => $time_results.find($target.name).to_data } )
    }
    $result_set = ResultSet($total_results)
    if ($fail_plan_on_errors and !$error_set.empty) {
      fail_plan('At least one target failed the pre-upgrade checks.', 'plan/kb0XXX_preupgrade_check', {
        data        => $result_set,
        errors      => $error_set,
        failednodes => $error_set.names,
      })
    }
    else {
      return($result_set)
    }
  }
  else {
    if ($fail_plan_on_errors and !$error_set.empty) {
      fail_plan('At least one target failed the pre-upgrade checks.', 'plan/kb0XXX_preupgrade_check', {
        errors      => $error_set,
        failednodes => $error_set.names,
      })
    }
  }
}
