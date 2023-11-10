# support_tasks

#### Table of Contents

- [support_tasks](#support_tasks)
      - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [Beginning with support_tasks](#beginning-with-support_tasks)
  - [Usage](#usage)
  - [Deprecation Notice](#deprecation-notice)
  - [Getting Help](#getting-help)
  - [How to Report an issue or contribute to the module](#how-to-report-an-issue-or-contribute-to-the-module)
- [Supporting Content](#supporting-content)
    - [Articles](#articles)
    - [Videos](#videos)
  - [Copyright and License](#copyright-and-license)
## Description

This is the companion module used to deliver the tasks for the solutions and configurations described in Puppet Support knowledge base <https://support.puppet.com/hc/en-us>.

The knowledge base, available to our support customers, offers a range of self service solutions, ranging from fixes to known issues to  useful configuration and deployment options. Some of the knowledge base articles include an accompanying Puppet task to automate the configuration of these self service solutions, this module delivers these tasks.

## Setup

### Beginning with support_tasks

Tasks in this module should only be executed by PE support customers in accompaniment with the corresponding knowledge base article.

## Usage

Support customers should follow the instructions in the corresponding knowledge base articles linked below.

## Deprecation Notice

The following tasks are no longer being developed and will be deprecated in a future version:

| Task Name | Alternative |
|-----------|-------------|
| st0236_set_cache_paths_to_default | Use [puppet conf](https://forge.puppet.com/modules/puppetlabs/puppet_conf/readme) |
| st0267_clear_file_sync_locks | See [knowledge article](https://support.puppet.com/hc/en-us/articles/360003883933) for manual steps |
| st0285_find_disabled_agents | This task can be handled manually in a custom task by running the following code: ```if [ -e "$LOCKFILE" ] then echo "Puppet agent is disabled" cat "$(puppet config print statedir)/agent_disabled.lock" else echo "Puppet agent is enabled" exit 1 fi``` |
| st0286_change_puppet_daemon_runmode | To enable or disable puppet agent, see [documentation](https://www.puppet.com/docs/puppet/latest/man/agent.html#options) |
| st0298_run_code_deploy | See [documentation](https://www.puppet.com/docs/pe/latest/code_mgr) for suitable solution |
| st0305_support_script_and_upload | See [documentation](https://portal.perforce.com/s/article/360009970114) for upload methods. SFTP and MFT are preferred|
| st0362_download_latest_pe_in_stream |  See [documentation](https://portal.perforce.com/s/article/218822507) for latest version of PE |
| st0317a_clean_cert | Use [certificate clean](https://www.puppet.com/docs/puppet/7/server/http_certificate_clean) API to remove certifications |
| st0317b_purge_node | Use [certificate clean](https://www.puppet.com/docs/puppet/7/server/http_certificate_clean) API to purge nodes |
| st0370_generate_token | Use [puppet access CLI](https://www.puppet.com/docs/pe/latest/rbac_token_auth_intro.html#generate_a_token_using_puppet_access) |
| st0371_puppet_commands | Use [Pe status check](https://forge.puppet.com/modules/puppetlabs/pe_status_check/readme) |
| st0372_os_commands |  See documentation on [system configuration](https://portal.perforce.com/s/article/360040232993) |
| st0373_api_calls | See docomentation on [CD4PE](https://www.puppet.com/docs/continuous-delivery/4.x/cd_user_guide.html) and [Tokens Endpoint](https://www.puppet.com/docs/pe/latest/rbac_api_v1_token.html) |
| st1105_primary_server_port_check | See [documentation](https://www.puppet.com/docs/pe/latest/system_configuration.html#firewall_standard) for checking TCP port configuration |

## Getting Help

Puppet Enterprise Support customers can open a ticket with us at our portal for assistance <https://support.puppet.com/hc/en-us>, this module is officially supported by the Puppet Enterprise Support Team

To display help for the support\_tasks task, run `puppet task show support_tasks::<task_name>`

To display a list of all tasks provided by this module run `puppet task show --all | grep support_tasks`

## How to Report an issue or contribute to the module

If you are a PE user and need support using this module or are encountering issues, our Support team would be happy to help you resolve your issue and help reproduce any bugs. Just raise a ticket on the [support portal](https://support.puppet.com/hc/en-us/requests/new).
If you have a reproducible bug or are a community user you can raise it directly on the Github issues page of the module [here](https://github.com/puppetlabs/support-tasks/issues).
We also welcome PR contributions to improve the module. Please see further details about contributing [here](https://puppet.com/docs/puppet/7.5/contributing.html#contributing_changes_to_module_repositories)


---

# Supporting Content

### Articles

The [Support Knowledge base](https://support.puppet.com/hc/en-us) is a searchable repository for technical information and how-to guides for all Puppet products.


### Videos

The [Support Video Playlist](https://youtube.com/playlist?list=PLV86BgbREluWKzzvVulR74HZzMl6SCh3S) is a resource of content generated by the support team


   ---


## Copyright and License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


