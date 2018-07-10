
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

This is the companion module used to deliver the Tasks for the solutions and configurations described in the Puppet Enterprise Support Knowledgebase https://support.puppet.com/hc/en-us

The Puppet Enterprise Support Knowledgebase, available to PE customers, offers a range of self service support solutions, ranging from fixes to known issues to  useful configuration and deployment options. Some of the knowledge base articles include an accompanying Puppet Task to automate the configuration of these self service solutions, this module delivers these Puppet Tasks.


## Setup



### Beginning with support_tasks


Tasks in this module should only be executed by PE customers in accompaniment with the corresponding Knowledgebase article. The Task name will correspond the KB Article Number, for instance, article KB#9999 will correspond to Puppet Task kb9999

## Usage

PE customers should execute the task designated by the Knowledgebase article based on the instructions within.



## Reference

To view the available actions and parameters, on the command line, run `puppet task show <task_name>` or see the support_tasks module page on the [Forge](https://forge.puppet.com/puppetlabs/support_tasks/tasks).

**Tasks:**

* [`kb0149`](https://support.puppet.com/hc/en-us/articles/218763948)

* [`kb0244`](https://support.puppet.com/hc/en-us/articles/360002051354)

* [`kb0267`](https://support.puppet.com/hc/en-us/articles/360003883933)

* [`kb0236`](https://support.puppet.com/hc/en-us/articles/360001060434)

* ['kb0285`](https://support.puppet.com/hc/en-us/articles/360006717334)

* [`kb0286`](https://support.puppet.com/hc/en-us/articles/360006721014)




## Getting Help

PE Customers can raise a ticket with PE support for assistance

To display help for the support_tasks task, run `puppet task show support_tasks`

## Copyright and License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.




