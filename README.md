# Fedora Workstation Minimal

This ansible playbook aims to setup a minimal, yet fully featured, instance of Fedora Workstation
starting from a minimal netinstall.

Available DE are:

- GNOME
- KDE
- XFCE

## Installing the base system

- Download Fedora Everything ISO [Everything ISO](https://fedora.mirror.garr.it/fedora/linux/releases/33/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-33-1.6.iso)
    - TESTED ON:
        - 32
        - 33
        - 34
- Prepare Boot Media following [Install Instructions](http://docs.fedoraproject.org/en-US/Fedora/html/Installation_Guide/sect-preparing-boot-media.html)
- In the installer under Software Selection, select Minimal Install.
- Create your user and be sure to **mark user as administrator**

## Running the playbook

The best way to run it is from an external machine (the playbook will reboot the machine a couple of times).
Be sure you have **ssh access to the target machine**.

Run:

```sh
./install.sh machine_ip --all,gnome
```

this will launch the ansible playbook. Wait it to finish.

### Tags

Available tags are:

- powersave (optional)    will tweak the system for laptops and install all powersaving features  **This has to be explicitely specified to be run**
- hardening (optional)    will tweak the system for better security  **This has to be explicitely specified to be run**
- kde (optional) **this has to be explicitely specified to be run**
- gnome (optional) **this has to be explicitely specified to be run**
- xfce (optional) **this has to be explicitely specified to be run**

More atomic tags are available:

- archives
- base_distro
- base_packages
- codecs
- gnome
- kde
- rpmfusion
- system_tweaks
- xfce
- zip

Those will only run the specific task ie. for installing only codecs and rpmfusion, etc.

### Running

#### Locally

So to run all the tags (ie. on a laptop we want Powersaving Tweaks), we will run:

```sh
./install.sh MACHINE_IP --tags all,powersave,hardening,gnome
```

#### Ansible Pull

It is also possible to use this playbook in ansible-pull mode:

```sh
ansible-pull -U https://github.com/89luca89/ansible-fedora-minimal -i $(hostname), -c local --tags all,powersave,hardening,gnome --skip-tags reboot -e "ansible_become_pass=$(pass sudo)" main.yml
```

#### Hardening

It's also possible to specify the hardening tag, this will apply various tweaks to improve system security.
This work is inspired from:

- https://dev-sec.io/
- https://www.cisecurity.org/cis-benchmarks/
- https://www.ssi.gouv.fr/en/guide/configuration-recommendations-of-a-gnulinux-system/
- https://apps.nsa.gov/iaarchive/library/ia-guidance/security-configuration/operating-systems/guide-to-the-secure-configuration-of-red-hat-enterprise.cfm

This phase will:

- Disable ssh host-based authentication
- Disable ssh root login
- Disable coredump storage
- Mount with noexec,nosuid,nodev as many mountpoints as possible
- Make /boot and /usr/lib accessible only to root
- Ensure selinux enforcing
- Disable root login on any tty
- Make `su` binary not accesible to non-sudo users
- Limit max number of concurrent logins per user
- Stricter file/folder persmissions in /etc
- Stricter umask (0027)
- Stricter $HOME user permissions
- Sysctl kernel and net values hardening
- Grub kernel flags hardening

---

# Result:

![overview](./pics/overview.png)
![htop](./pics/htop.png)
![kde-overview](./pics/kde-overview.png)
![kde-htop](./pics/kde-htop.png)
![xfce-htop](./pics/xfce-htop.png)

After install:

- `rpm -qa | wc -l` yelds **1248** packages for GNOME, **1375** for KDE, **1211** for XFCE
- process after boot:
    - 111 GNOME
    - 87 KDE
    - 83 XFCE
- about 600~650mb of ram occupied after boot (both GNOME and KDE), ~420mb for XFCE

To be noted:

With a minimal install both KDE and GNOME ram consumption is absolutely comparable, if measured with the same
tool ( `htop` )
If we measure with `gnome-system-monitor` it reports a higher RAM usage for GNOME and at the same time,
`ksysguard` reports much lower RAM usage for KDE, both compared to `htop`.

So keep in mind that:

- `gnome-system-monitor` **over reports ram usage**
- `ksysguard` **under reports ram usage**
