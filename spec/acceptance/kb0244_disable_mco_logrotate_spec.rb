require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when mco logrotate is present ' do
    run_shell('touch /etc/logrotate.d/mcollective')
    results = run_bolt_task('support_tasks::kb0244_disable_mco_logrotate')
    expect(results.first['result']['_output']).to contain('Applied catalog in')
    expect(File).not_to exist('/etc/logrotate.d/mcollective')
  end
  it 'when mco logrotate is not present ' do
    run_shell('rm -rf /etc/logrotate.d/mcollective')
    results = run_bolt_task('support_tasks::kb0244_disable_mco_logrotate')
    expect(results.first['result']['_output']).to contain('Applied catalog in')
    expect(File).not_to exist('/etc/logrotate.d/mcollective')
  end
end
