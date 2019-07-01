require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when agent is disabled ' do
    run_shell('/opt/puppetlabs/bin/puppet agent --disable')
    result = run_bolt_task('support_tasks::kb0285_find_disabled_agents')
    expect(result['result']['_output']).to contain('Puppet agent is disabled')
  end
  it 'when agent is enabled ' do
    run_shell('/opt/puppetlabs/bin/puppet agent --enable')
    expect { run_bolt_task('support_tasks::kb0285_find_disabled_agents') }.to raise_error do |error|
      expect(error).to be_a(RuntimeError)
      expect(error.message).to match %r{"_output"=>"Puppet agent is enabled\\n"}
      expect(error.message).to match %r{"exit_code"=>1}
    end
  end
end
