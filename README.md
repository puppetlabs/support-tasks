# support_tasks

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with support_tasks](#setup)
    * [Beginning with support_tasks](#beginning-with-support_tasks)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Tasks](#tasks)
5. [Getting Help](#getting-help)

## Description

This is the companion module used to deliver the tasks for the solutions and configurations described in Puppet Support knowledge base <https://support.puppet.com/hc/en-us>.

The knowledge base, available to our support customers, offers a range of self service solutions, ranging from fixes to known issues to  useful configuration and deployment options. Some of the knowledge base articles include an accompanying Puppet task to automate the configuration of these self service solutions, this module delivers these tasks.


## Setup

### Beginning with support_tasks

Tasks in this module should only be executed by PE support customers in accompaniment with the corresponding knowledge base article. The task name corresponds to the KB article number, for instance, article KB#9999 corresponds to task kb9999.

## Usage

Support customers should follow the instructions in the corresponding knowledge base articles linked below.


## Reference

To view the available actions and parameters for each task, on the command line, run `puppet task show <task_name>` or see the support\_tasks module page on the [Forge](https://forge.puppet.com/puppetlabs/support_tasks/tasks).

**Tasks:**

* [`st0009_Change_PE_Service_Loglevel`](https://support.puppet.com/hc/en-us/articles/115000177368)

* [`st0149_Resolve_Stack_Level_Too_Deep`](https://support.puppet.com/hc/en-us/articles/218763948)

* [`st0244_disable_mco_logrotate`](https://support.puppet.com/hc/en-us/articles/360002051354)

* [`st0267_clear_file_sync_locks`](https://support.puppet.com/hc/en-us/articles/360003883933)

* [`st0236_set_cache_paths_to_default`](https://support.puppet.com/hc/en-us/articles/360001060434)

* [`st0285_find_disabled_agents`](https://support.puppet.com/hc/en-us/articles/360006717334)

* [`st0286_change_puppet_daemon_runmode`](https://support.puppet.com/hc/en-us/articles/360006721014)

* [`st0287_Check_DB_Table_Sizes`](https://support.puppet.com/hc/en-us/articles/360006922673)

* [`st0263_Rename_Pe_Master`](https://support.puppet.com/hc/en-us/articles/360003489634)

* [`st0298_Run_Code_Deploy`](https://support.puppet.com/hc/en-us/articles/360008192734)

* [`st0299_Regen_Master_Cert`](https://support.puppet.com/hc/en-us/articles/360008505193)

* [`st0305_support_script_and_upload`](https://support.puppet.com/hc/en-us/articles/360009970114)

* [`st0317_Clean_Or_Purge_Nodes`](https://support.puppet.com/hc/en-us/articles/360012551294)

* [`st0346_Thundering_Herd_resolver`](https://support.puppet.com/hc/en-us/articles/360023988353)

* [`st0361 Uploading facts to the Puppet master`](https://support.puppet.com/hc/en-us/articles/360036136533)

* [`st0362 Check for and download the latest patch for your current major release for Puppet Enterprise `](https://support.puppet.com/hc/en-us/articles/360036141593 )

* [`st0370_generate_token`](https://support.puppet.com/hc/en-us/articles/360040226053)

* [`st0371_puppet_commands`](https://support.puppet.com/hc/en-us/articles/360039726314)

* [`st0372_os_commands`](https://support.puppet.com/hc/en-us/articles/360040232993)

* [`st0373_api_calls`](https://support.puppet.com/hc/en-us/articles/360040234893)

## Getting Help

Puppet Enterprise Support customers can open a ticket with us at our portal for assistance <https://support.puppet.com/hc/en-us>, this module is officially supported by the Puppet Enterprise Support Team

To display help for the support\_tasks task, run `puppet task show support_tasks::<task_name>`

To display a list of all tasks provided by this module run `puppet task show --all | grep support_tasks`

## Copyright and License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
