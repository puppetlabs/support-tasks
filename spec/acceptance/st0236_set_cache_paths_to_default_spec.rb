require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when all dirs are already default or is PE node' do
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result.stdout).to contain(%r{success})
  end
  it 'when vardir is not default or is pe node ' do
    run_shell('if [  -z "$(facter -p pe_build)" ]; then /opt/puppetlabs/bin/puppet config set vardir /opt/puppetlabs/testingdirs; fi')
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result.stdout).to contain(%r{success})
  end
  it 'when statedir is not default or is pe node ' do
    run_shell('if [  -z "$(facter -p pe_build)" ]; then /opt/puppetlabs/bin/puppet config set statedir /opt/puppetlabs/testingdirs; fi')
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result.stdout).to contain(%r{success})
  end
  it 'when rundir is not default or is pe node ' do
    run_shell('if [  -z "$(facter -p pe_build)" ]; then /opt/puppetlabs/bin/puppet config set rundir /opt/puppetlabs/testingdirs; fi')
    result = run_bolt_task('support_tasks::st0236_set_cache_paths_to_default')
    expect(result.stdout).to contain(%r{success})
  end
end
