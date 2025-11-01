# Cisco Search

This repository contains a simple but powerful toolset — a shell script and an accompanying Ansible playbook — for searching Cisco configuration files for a given pattern and printing the relevant configuration sections.  

It’s especially useful when you need to quickly locate, for example, a switchport with a specific description across a large number of network devices.  

The cisco-search shell script scans Cisco configuration files under a specified directory (by default /tmp/cisco-search) for a given search pattern.
It then prints all configuration blocks that contain the pattern, including the device name as a heading for better readability.

## Installation

```bash
# Install dependencies
apt install ansible

# Clone the repository
git clone https://github.com/l3fuex/cisco-search.git

# Make the script executable
chmod +x cisco-search/cisco-search.sh
```

## Usage
### Run the Ansible Playbook
The included playbook (cisco-search.yaml) automates the process of:
- Collecting and unpacking Cisco running configurations
- Converting NXOS configs into the supported format
- Storing everything in the working directory (by default /tmp/cisco-search)

Add the following line to your crontab with `crontab -e` to automate this task everyday at 2:15 AM.
```bash
15 2 * * * ansible-playbook /PATH/TO/plb_cisco-search.yaml --inventory /PATH/TO/inventory
```

### Run the Search Script
Once the configurations are available, run the script:
```bash
./cisco-search HOST_A
```

Example output:
```
~~~~~~~~~~~~~~
>> switch01 <<
~~~~~~~~~~~~~~
interface GigabitEthernet1/10
 description HOST_A
 switchport access vlan 10
 switchport mode access
 authentication event fail action next-method
 authentication order dot1x mab
 authentication port-control auto
 authentication violation restrict
 mab
 dot1x pae authenticator
 dot1x timeout tx-period 5
 spanning-tree portfast
```

## Notes
- The Ansible playbook assumes a naming convention like \<hostname\>_\<date\>.tar.gz for backup files.
- Ensure you have unique interface descriptions across your environment for best results.
- Adjust paths patterns (workdir, basedir) to fit your local setup.

## License
This software is provided under the [Creative Commons BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) license.
