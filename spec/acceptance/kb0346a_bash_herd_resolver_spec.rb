require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when restarting agent ' do
    run_shell('/opt/puppetlabs/bin/puppet config set runinterval 5')
    result = run_bolt_task('support_tasks::kb0346a_bash_herd_resolver')
    expect(result['result']['_output']).to contain('running')
    expect(result['result']['_output']).to contain('stopped')
  end
end
