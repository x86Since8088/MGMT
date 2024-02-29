
# Welcome to the MGMT Repo

This is lab deployment codeset, but I'm working on making it a cross-cloud deployment environment.

Things to know:

- Custom Modules are located under MGMT/PowerShell/Modules
- Saved modules are located under MGMT/Sved-Modules

## Todo items

- Backup functions for keys, data folder
- Restore functions
- Update functions
- Deploy functions
- Wrappers of AZ
- Wrappers for AWS
- Linux compatibility
- Unit tests
- Error handling

## Security

- A 'Data' folder is automatically created at the root of the drive that you run this module from.
  - Project data is kept there

## Deployment goals

- IPAM
- Objectives
  - DNS Records
  - IP Address reservations via PTR
  - VLAN automation
  - How can VXLAN be implemented
- Netbox
  - chat.openai.com
- PFsense API
- Splunk
- Cribl
- ELK
- Telegraf
- Redis - MGMT for cross-system variables and other fun stuff.
- RBAC
- Web front end
- NPM
- Node

## Multi-cloud Tools

- Have the ability to move to cheaper options
- Deployment parity between on-site, Azure, AWS, Linode, Cloudflare
- Reference Architectures for each environemnt
  - IAM
  - PKI
  - DNS
  - Load Balancers
  - WAF
  - ALG
  - Databases
    - Create a testing table by default.
  - ML scenarios
  - Key Management
  - Credential Vaults
    - <https://github.com/hashicorp/vault/>
  - WSL
    - <https://github.com/okibcn/wslcompact>
