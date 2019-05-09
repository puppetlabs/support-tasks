# Reference

## Configuration

### ssh

By default, Bolt will assume the `ssh` transport and use `~/.ssh.config` for configuration options.  Below is a sample `config` file and command.

```
Host pe-*
  User centos
  Port 22
  PasswordAuthentication no
  IdentityFile /home/adrian/.ssh/id_rsa-acceptance
  IdentitiesOnly yes
  LogLevel ERROR
```

```
$ bolt plan run kb0337b_upload_ca_cert cert=/tmp/tmp.CuWtz3dmfx --run-as root --nodes pe-201815-agent
{
  "success": {
    "pe-201815-agent": {
      "_output": "Uploaded '/tmp/tmp.CuWtz3dmfx' to 'pe-201815-agent:/etc/puppetlabs/puppet/ssl/certs/ca.pem'"
    }
  }
}
```

### Inventory

See the [Bolt inventory](https://puppet.com/docs/bolt/latest/inventory_file.html) documentation for a full reference on how to use the inventory.  Below is a sample inventory created using [bolt-inventory-pdb](https://puppet.com/docs/bolt/latest/inventory_file_generating.html) and example commands.

```
$ cat pdb.yaml
---
query: "inventory[certname] {}"
groups:
- name: windows
  query: "inventory[certname] { facts.osfamily = 'windows' }"
  config:
    transport: winrm
    winrm:
      user: Administrator
      password: foo
      ssl: false
- name: linux
  query: "inventory[certname] { facts.kernel = 'Linux' }"
  config:
    transport: ssh
    ssh:
      user: centos
      private-key: ~/.ssh/id_rsa-acceptance
      host-key-check: false
```

```
$ /opt/puppetlabs/bolt/bin/bolt-inventory-pdb pdb.yaml -o ~/.puppetlabs/bolt/inventory.yaml
```

```
$ cat ~/.puppetlabs/bolt/inventory.yaml
---
query: inventory[certname] {}
groups:
- name: windows
  query: inventory[certname] { facts.osfamily = 'windows' }
  config:
    transport: winrm
    winrm:
      user: Administrator
      password: foo
      ssl: false
  nodes:
  - ljbkgu9t2x3ohqd.delivery.puppetlabs.net
- name: linux
  query: inventory[certname] { facts.kernel = 'Linux' }
  config:
    transport: ssh
    ssh:
      user: centos
      private-key: "~/.ssh/id_rsa-acceptance"
      host-key-check: false
  nodes:
  - pe-201815-master.puppetdebug.vlan
  - pe-201815-agent.platform9.puppet.net
  - pe-201815-compile.platform9.puppet.net
nodes:
- ljbkgu9t2x3ohqd.delivery.puppetlabs.net
- pe-201815-master.puppetdebug.vlan
- pe-201815-agent.platform9.puppet.net
- pe-201815-compile.platform9.puppet.net
```

```
$ bolt command run hostname --nodes linux
Started on pe-201815-compile.platform9.puppet.net...
Started on pe-201815-master.puppetdebug.vlan...
Started on pe-201815-agent.platform9.puppet.net...
Finished on pe-201815-master.puppetdebug.vlan:
  STDOUT:
    pe-201815-master.puppetdebug.vlan
Finished on pe-201815-compile.platform9.puppet.net:
  STDOUT:
    pe-201815-compile
Finished on pe-201815-agent.platform9.puppet.net:
  STDOUT:
    pe-201815-agent
Successful on 3 nodes: pe-201815-master.puppetdebug.vlan,pe-201815-agent.platform9.puppet.net,pe-201815-compile.platform9.puppet.net
Ran on 3 nodes in 0.62 seconds
```

```
$ bolt command run hostname --nodes windows
Started on ljbkgu9t2x3ohqd.delivery.puppetlabs.net...
Finished on ljbkgu9t2x3ohqd.delivery.puppetlabs.net:
  STDOUT:
    ljbkgu9t2x3ohqd
Successful on 1 node: ljbkgu9t2x3ohqd.delivery.puppetlabs.net
Ran on 1 node in 0.70 seconds
```

## Plans

### `kb0337a_extend_ca_cert`

#### Arguments

* master - Fully qualified domain name of the master containing the certificate authority
* compile_masters - Comma separated list of fully qualified domain names of compile masters

#### Steps

* Runs the `service` task to stop the `puppet` and `pe-puppetserver` services on the master
* Runs the `kb0337a_extend_ca_cert` task to dump the new cert to a file and return the path to the file and a base64 encoded string of its contents
* Runs the `kb0337d_configure_master` task to backup the `ssl` directory to `/var/puppetlabs/backups`, copy the new cert into place, and configure the master to use the new cert
* Decodes the cert's contents and dump it to a temp file
* Uploads the new cert to any compile masters and configures them to use the new cert

#### Output

All steps in this plan are critical to extending the certificate, so the plan will fail if any step fails.  The output consists of Bolt logging messages and any failures of the steps involved.

### Example

```
$ bolt plan run kb0337a_extend_ca_cert master=pe-201815-master compile_masters=pe-201815-compile --run-as root
Starting: plan kb0337a_extend_ca_cert
Starting: command 'echo "test" | base64 -w 0 - &>/dev/null' on localhost
Finished: command 'echo "test" | base64 -w 0 - &>/dev/null' with 0 failures in 0.0 sec
INFO: Stopping puppet and pe-puppetserver services on pe-201815-master
Starting: task service on pe-201815-master
Finished: task service with 0 failures in 0.85 sec
Starting: task service on pe-201815-master
Finished: task service with 0 failures in 1.95 sec
INFO: Extending certificate on master pe-201815-master
Starting: task kb0337a_extend_ca_cert on pe-201815-master
Finished: task kb0337a_extend_ca_cert with 0 failures in 2.92 sec
INFO: Configuring master pe-201815-master to use new certificate
Starting: task kb0337d_configure_master on pe-201815-master
Finished: task kb0337d_configure_master with 0 failures in 95.72 sec
Starting: task service on pe-201815-master
Finished: task service with 0 failures in 1.64 sec
INFO: Configuring compile master(s) pe-201815-compile to use new certificate
Starting: file upload from /tmp/tmp.CuWtz3dmfx to /etc/puppetlabs/puppet/ssl/certs/ca.pem on pe-201815-compile
Finished: file upload from /tmp/tmp.CuWtz3dmfx to /etc/puppetlabs/puppet/ssl/certs/ca.pem with 0 failures in 0.59 sec
Starting: task run_agent on pe-201815-compile
Finished: task run_agent with 0 failures in 44.34 sec
INFO: CA cert decoded and stored at /tmp/tmp.CuWtz3dmfx
INFO: Run plan 'kb0337b_upload_ca_cert' to distribute to agents
Finished: plan kb0337a_extend_ca_cert in 148.06 sec
```

### `kb0337b_upload_ca_cert`

#### Arguments

*  cert - Location of the new certificate on disk.

This plan accepts any valid TargetSpec(s) specified by the `--nodes` option.

#### Steps

* Collects facts from agents and separates them into groups of \*nix and Windows
* Runs `upload_file` on each list of agents to distribute the cert
* Constructs a JSON formatted object of the results of the uploads and returns it

#### Output

The output of this plan is a JSON object with two keys: `success` and `failure`.  Each key contains any number of objects consisting of the agent certname and the output of the `upload_file` command.

```
$ bolt plan run kb0337b_upload_ca_cert cert=/tmp/tmp.CuWtz3dmfx --run-as root --query 'inventory { }'
Starting: plan kb0337b_upload_ca_cert
Starting: plan kb0337c_get_agent_facts
Starting: install puppet and gather facts on pe-201815-agent.platform9.puppet.net, ljbkgu9t2x3ohqd.delivery.puppetlabs.net, pe-201815-master.puppetdebug.vlan, pe-201815-compile.platform9.puppet.net
Finished: install puppet and gather facts with 0 failures in 9.33 sec
Finished: plan kb0337c_get_agent_facts in 9.33 sec
Starting: plan facts
Starting: task facts on pe-201815-agent.platform9.puppet.net, ljbkgu9t2x3ohqd.delivery.puppetlabs.net, pe-201815-master.puppetdebug.vlan, pe-201815-compile.platform9.puppet.net
Finished: task facts with 0 failures in 6.27 sec
Finished: plan facts in 6.31 sec
Starting: file upload from /tmp/tmp.CuWtz3dmfx to C:\ProgramData\PuppetLabs\puppet\etc\ssl\certs\ca.pem on ljbkgu9t2x3ohqd.delivery.puppetlabs.net
Finished: file upload from /tmp/tmp.CuWtz3dmfx to C:\ProgramData\PuppetLabs\puppet\etc\ssl\certs\ca.pem with 0 failures in 1.07 sec
Starting: file upload from /tmp/tmp.CuWtz3dmfx to /etc/puppetlabs/puppet/ssl/certs/ca.pem on pe-201815-agent.platform9.puppet.net, pe-201815-master.puppetdebug.vlan, pe-201815-compile.platform9.puppet.net
Finished: file upload from /tmp/tmp.CuWtz3dmfx to /etc/puppetlabs/puppet/ssl/certs/ca.pem with 0 failures in 0.66 sec
Finished: plan kb0337b_upload_ca_cert in 17.41 sec
{
  "success": {
    "pe-201815-agent.platform9.puppet.net": {
      "_output": "Uploaded '/tmp/tmp.CuWtz3dmfx' to 'pe-201815-agent.platform9.puppet.net:/etc/puppetlabs/puppet/ssl/certs/ca.pem'"
    },
    "pe-201815-master.puppetdebug.vlan": {
      "_output": "Uploaded '/tmp/tmp.CuWtz3dmfx' to 'pe-201815-master.puppetdebug.vlan:/etc/puppetlabs/puppet/ssl/certs/ca.pem'"
    },
    "pe-201815-compile.platform9.puppet.net": {
      "_output": "Uploaded '/tmp/tmp.CuWtz3dmfx' to 'pe-201815-compile.platform9.puppet.net:/etc/puppetlabs/puppet/ssl/certs/ca.pem'"
    },
    "ljbkgu9t2x3ohqd.delivery.puppetlabs.net": {
      "_output": "Uploaded '/tmp/tmp.CuWtz3dmfx' to 'ljbkgu9t2x3ohqd.delivery.puppetlabs.net:C:\\ProgramData\\PuppetLabs\\puppet\\etc\\ssl\\certs\\ca.pem'"
    }
  }
}
```

## Tasks

### `kb0337g_check_ca_expiry`

#### Arguments

* cert - Optional location of certificate on disk to check.  Defaults to /etc/puppetlabs/puppet/ssl/certs/ca.pem.
* date - Optional YYYY-MM-DD format date against which to check for expiration. Defaults to 3 months in the future.

This task accepts any valid TargetSpec(s) specified by the `--nodes` option. Can be run on any \*nix agent node or the master.

#### Steps

* Uses `openssl` and Unix `date` to determine if the certificate will expire.

#### Output

A JSON object with the status and expiration date, e.g.

```
{
  "status": "valid",
  "expiry date": "Feb 16 01:00:09 2034 GMT"
}
```

### `kb0337f_check_agent_expiry`

#### Arguments

* date - Optional YYYY-MM-DD format date against which to check for expiration

This task accepts any valid TargetSpec(s) specified by the `--nodes` option. Should be run on the master.

#### Steps

* Uses `openssl` and Unix `date` to determine if the signed agent certificates under `/etc/puppetlabs/puppet/ssl/ca/signed/` will expire.

#### Output

A JSON object with keys for valid and expiring certificates, e.g.

```
  {
    "valid": [
      "/etc/puppetlabs/puppet/ssl/ca/signed/c4lscpmafhaxjr8.delivery.puppetlabs.net.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/cd4pe-containers.platform9.puppet.net.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/iwj6668y4s3vq40.delivery.puppetlabs.net.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/koo1nzsozj2xeqh.delivery.puppetlabs.net.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/mafy3pgo98v2vne.delivery.puppetlabs.net.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/pe-201901-agent.platform9.puppet.net.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/pe-201901-compile.puppetdebug.vlan.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/pe-201901-master.puppetdebug.vlan.pem",
      "/etc/puppetlabs/puppet/ssl/ca/signed/qgocotu07r3rdpa.delivery.puppetlabs.net.pem"
    ],
    "expiring": [

    ]
  }
```
