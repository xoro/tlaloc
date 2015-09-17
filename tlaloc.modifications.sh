#!/bin/sh

# tlaloc modification script
# Copyright Timo Pallach <timo@pallach.de>, see LICENSE for details

# We want to save the complete /etc and the /var before we reboot the system.
echo "save_etc='.'" >> ${resflash_directory}/etc/resflash.conf
echo "save_var='.'" >> ${resflash_directory}/etc/resflash.conf

# We are sourcing the /etc/csh.cshrc in the /root/.cshrc because we cannot
# modify and save any changes in the / filesystem, only in the /etc and /variables
# filesystems.
echo ". /etc/csh.cshrc" >> ${base_directory}/root/.cshrc

# Disable services that we do not need on a router firmware (smtpd, sndiod).
echo "smtpd_flags=NO" >> ${base_directory}/etc/rc.conf.local
echo "sndiod_flags=NO" >> ${base_directory}/etc/rc.conf.local
