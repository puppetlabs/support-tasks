require 'spec_helper_acceptance'
describe 'tasks' do
  it 'run support script' do
    run_shell('echo 192.69.65.61 customer-support.puppetlabs.net >> /etc/hosts')
    result = run_bolt_task('support_tasks::st0305_support_script_and_upload', 'ticket' => 1234)
    expect(result.exit_code).to eq(0)
  end
end
