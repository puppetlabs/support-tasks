require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when all dirs are already default ' do
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('No changes necessary'.or(contain('This task should only be run on an agent')))
  end
  it 'when vardir is not default ' do
    run_shell('/opt/puppetlabs/bin/puppet config set vardir /opt/puppetlabs/testingdirs')
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('vardir set to /opt/puppetlabs/testingdirs, resetting to the default'.or(contain('This task should only be run on an agent')))
  end
  it 'when statedir is not default ' do
    run_shell('/opt/puppetlabs/bin/puppet config set statedir /opt/puppetlabs/testingdirs')
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('statedir set to /opt/puppetlabs/testingdirs, resetting to the default'.or(contain('This task should only be run on an agent')))
  end
  it 'when rundir is not default ' do
    run_shell('/opt/puppetlabs/bin/puppet config set rundir /opt/puppetlabs/testingdirs')
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result['result']['_output']).to contain('rundir set to /opt/puppetlabs/testingdirs, resetting to the default'.or(contain('This task should only be run on an agent')))
  end
end
