require 'spec_helper_acceptance'
describe 'tasks' do
  it 'facts uploaded successfully' do
    result = run_bolt_task('support_tasks::st0361_uploading_facts')
    expect(result.exit_code).to eq(0)
  end
end
