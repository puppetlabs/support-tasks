require 'spec_helper_acceptance'
describe 'tasks' do
  it 'facts uploaded successfully' do
    result = run_bolt_task('support_tasks::st0361_uploading_facts')
    expect(result['result']['_output']).to contain('Uploading facts for')
  end
end
