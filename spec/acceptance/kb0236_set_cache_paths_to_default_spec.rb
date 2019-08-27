require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when all dirs are already default ' do
    result = run_bolt_task('support_tasks::kb0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('No changes necessary')
  end
  it 'when vardir is not default ' do
    run_shell('/opt/puppetlabs/bin/puppet config set vardir /tmp')
    result = run_bolt_task('support_tasks::kb0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('vardir set to /tmp, resetting to the default')
  end
  it 'when statedir is not default ' do
    run_shell('/opt/puppetlabs/bin/puppet config set statedir /tmp')
    result = run_bolt_task('support_tasks::kb0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('statedir set to /tmp, resetting to the default')
  end
  it 'when rundir is not default ' do
    run_shell('/opt/puppetlabs/bin/puppet config set rundir /tmp')
    result = run_bolt_task('support_tasks::kb0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('rundir set to /tmp, resetting to the default')
  end
end
