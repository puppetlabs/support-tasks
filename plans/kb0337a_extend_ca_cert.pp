plan support_tasks::kb0337a_extend_ca_cert(TargetSpec $master, Optional[TargetSpec] $compile_masters = undef) {
  notice("INFO: Stopping puppet, pe-postgresql, and pe-puppetserver services on ${master}")
  run_task('service', $master, 'action' => 'stop', 'name' => 'puppet')
  run_task('service', $master, 'action' => 'stop', 'name' => 'pe-puppetserver')
  run_task('service', $master, 'action' => 'stop', 'name' => 'pe-postgresql')

  notice("INFO: Extending certificate on master ${master}")
  $regen_results =  run_task('support_tasks::kb0337e_extend_ca_cert', $master)
  $new_cert = $regen_results.first.value
  $cert_contents = base64('decode', $new_cert['contents'])

  notice("INFO: Configuring master ${master} to use new certificate")
  run_task('support_tasks::kb0337d_configure_master', $master, 'new_cert' => $new_cert['new_cert'])
  run_task('service', $master, 'action' => 'start', 'name' => 'puppet')

  $tmp = run_command('mktemp', 'localhost', '_run_as' => system::env('USER'))
  $tmp_file = $tmp.first.value['stdout'].chomp
  file::write($tmp_file, $cert_contents)

  if $compile_masters {
    notice("INFO: Stopping puppet service on ${compile_masters}")

    run_task('service', $compile_masters, 'action' => 'stop', 'name' => 'puppet')
    notice("INFO: Configuring compile master(s) ${compile_masters} to use new certificate")
    upload_file($tmp_file, '/etc/puppetlabs/puppet/ssl/certs/ca.pem', $compile_masters)

    # Just running Puppet with the new cert in place should be enough
    run_command('/opt/puppetlabs/bin/puppet agent --no-daemonize --no-noop --onetime', $compile_masters)
    run_task('service', $compile_masters, 'action' => 'start', 'name' => 'puppet')
  }

  notice("INFO: CA cert decoded and stored at ${tmp_file}")
  notice("INFO: Run plan 'support_tasks::kb0337b_upload_ca_cert' to distribute to agents")

}
