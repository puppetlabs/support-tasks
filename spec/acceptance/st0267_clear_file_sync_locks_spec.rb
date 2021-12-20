require 'spec_helper_acceptance'
describe 'tasks' do
  it 'when lockfile removal possible, or not a valid node ' do
    run_shell('if [  -n "$(facter -p pe_build)" ]; then mkdir -p /opt/puppetlabs/server/data/puppetserver/filesync &&  touch /opt/puppetlabs/server/data/puppetserver/filesync/index.lock; fi')
    result = run_bolt_task('support_tasks::st0267_clear_file_sync_locks')
    expect(result.stdout).to contain(%r{success})
  end
end
