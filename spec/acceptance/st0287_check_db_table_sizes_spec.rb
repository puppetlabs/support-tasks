require 'spec_helper_acceptance'
describe 'tasks' do
  it 'table sizes output sucessfully' do
    result = run_bolt_task('support_tasks::st0287_check_db_table_sizes', 'dbname' => 'all')
    expect(result.stdout).to contain(%r{success})
  end
end
