# Change Log
All notable changes to this project will be documented in this file.

## [1.1.2] - 2020-03-26

### Added

- st1105_master_port_check - Task to test TCP port connectivity of the Puppet Master

### Changed

- PDK updated to 1.17

### Fixed

- Removed "DOCS" reference to now removed cert regen tasks


## [1.1.1] - 2020-01-17

### Added


### Changed

- To support Upcoming Changes to the Support Knowledge base, number referencing from all tasks has been uncoupled from the Article Number, References going forward will be prefix "ST" followed by a 4 digit number etx "st9999" 

### Fixed

- https://github.com/puppetlabs/support-tasks/issues/71 


## [1.1] - 2019-12-20
 
### Added

 - kb0370_generate_token
 - kb0371_puppet_commands
 - kb0372_os_commands
 - kb0373_api_calls


### Changed

- Updated kb0285 for Windows support
- Added Puppet OpenSource Support to compatible tasks
- PDK 1.14 Update

### Fixed

## [1.0.9] - 2019-10-10
 
### Added

- kb0305_support_script_and_upload


### Changed

- Remove ca_extend plans and tasks from this module
- [SUP-1408] Added cross-platform task metatdata where applicable 

### Fixed

## [1.0.8] - 2019-09-20
 
### Added

New Tasks:

 - kb00362_download_latest_pe_in_stream
 - kb00361b_uploading_facts
 - kb00361a_uploading_facts

### Changed

- Updated to PDK 1.13

 ### Fixed


## [1.0.8] - 2019-09-20
 
### Added

New Tasks:

 - kb00362_download_latest_pe_in_stream
 - kb00361b_uploading_facts
 - kb00361a_uploading_facts

### Changed

- Updated to PDK 1.13

 ### Fixed


## [1.0.7] - 2019-09-01
 
### Added


### Changed

- Updated to PDK template version PDK 1.12

- Updated Readme for missing links
 
### Fixed

 - SUP-1217

## [1.0.6] - 2019-07-01
 
### Added

New tasks to fix resolve thundering herd in Linux and windows

- kb0346a
  kb0346ba

### Changed

  - Updated to PDK template version PDK 1.11
 
### Fixed



## [1.0.5] - 2018-05-09
 
### Added

New plans to extend the CA certificate on a master:

- kb0337a_extend_ca_cert
- kb0337b_upload_ca_cert
- kb0337c_get_agent_facts

New tasks to check the expiry date of the CA certificate and signed agent certificates

- kb0337f_check_agent_expiry
- kb0337g_check_ca_expiry


### Changed

Updated to support PE 2019.x

Added acceptance testing using [Litmus](https://github.com/puppetlabs/puppet_litmus)
 
### Fixed



## [1.0.4] - 2018-12-19
 
### Added

- kb0317a_clean_cert
- kb0317b_purge_node


### Changed
 
### Fixed


## [1.0.3] - 2018-09-05
 
### Added

- kb0009_change_pe_service_loglevel


### Changed
 
### Fixed


 
## [1.0.2] - 2018-09-18
  
 
### Added

 - kb0287_Check_DB_Table_Sizes

 - kb0263_Rename_Pe_Master

 - kb0298_Run_Code_Deploy

 - kb0299_Regen_Master_Cert
 
### Changed

### Fixed
 

 
## [1.0.0] - 2018-07-20
 
### Added

Initial Release of Module

### Changed
 
### Fixed
 
