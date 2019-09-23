# Changelog

All notable changes to this project will be documented in this file.

## Release 1.0.0

Initial Release July 20th 2018

## Release 1.0.2

September 3rd 2018

Addition of the following tasks:

- kb0287_Check_DB_Table_Sizes

- kb0263_Rename_Pe_Master

- kb0298_Run_Code_Deploy

- kb0299_Regen_Master_Cert

**Features**

**Bugfixes**

**Known Issues**

## Release 1.0.3

September 5th 2018

Updated the following tasks:

- kb0009_change_pe_service_loglevel

## Release 1.0.4

December 19th 2018

New task to clean and purge certnames:

- kb0317a_clean_cert
- kb0317b_purge_node

## Release 1.0.5

May 9th 2019

**Features**

New plans to extend the CA certificate on a master:

- kb0337a_extend_ca_cert
- kb0337b_upload_ca_cert
- kb0337c_get_agent_facts

New tasks to check the expiry date of the CA certificate and signed agent certificates

- kb0337f_check_agent_expiry
- kb0337g_check_ca_expiry

Updated to support PE 2019.x

Added acceptance testing using [Litmus](https://github.com/puppetlabs/puppet_litmus)

## Release 1.0.6

July 1st 2019

**Features**


New tasks to fix resolve thundering herd in Linux and windows

- kb0346a
  kb0346ba

Updated to PDK template version PDK 1.11

## Release 1.0.7

September 2019

**Features**


Fix for SUP-1217

Updated to PDK template version PDK 1.12

Updated Readme for missing links


## Release 1.0.8

September 20th 2019

**Features**

Updated to PDK 1.13

New Tasks:

kb00362_download_latest_pe_in_stream
kb00361b_uploading_facts
kb00361a_uploading_facts


