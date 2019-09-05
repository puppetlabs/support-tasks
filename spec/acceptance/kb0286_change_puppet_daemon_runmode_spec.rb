require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when agent is disabled and action is enable' do
    run_shell('/opt/puppetlabs/bin/puppet agent --disable shelldisable')
    result = run_bolt_task('support_tasks::kb0286_change_puppet_daemon_runmode', 'puppet_mode' => 'enable')
    expect(result['result']['_output']).to contain('enabled puppet on')
  end
  it 'when agent is enabled and action is disable ' do
    run_shell('/opt/puppetlabs/bin/puppet agent --enable')
    result = run_bolt_task('support_tasks::kb0286_change_puppet_daemon_runmode', 'puppet_mode' => 'disable', 'reason' => 'taskdisabled')
    expect(result['result']['_output']).to contain('disabled puppet on')
    expect(result['result']['_output']).to contain('taskdisabled')
  end
  it 'when agent is disabled and action is disable' do
    run_shell('/opt/puppetlabs/bin/puppet agent --disable')
    result = run_bolt_task('support_tasks::kb0286_change_puppet_daemon_runmode', 'puppet_mode' => 'disable', 'reason' => 'taskdisabled')
    expect(result['result']['_output']).to contain('puppet daemon already disabled on')
    expect(result['result']['_output']).to contain('taskdisabled')
  end
  it 'when agent is enable and action is enable' do
    run_shell('/opt/puppetlabs/bin/puppet agent --enable')
    result = run_bolt_task('support_tasks::kb0286_change_puppet_daemon_runmode', 'puppet_mode' => 'enable')
    expect(result['result']['_output']).to contain('puppet already enabled on')
  end
end
