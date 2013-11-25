someonewhocares
==================

Pull and install the latest host file from http://someonewhocares.org
provided by Dan Pollock

Example
-------

Run the script with no arguments to pull and install the latest host file.
This script does not need to be run as root, as it will attempt to install
the host file with `sudo` if it fails at first.

    $ ./someonewhocares
    > pulling latest host file from http://someonewhocares.org/hosts//hosts... done
    > validating host file... passed
    > installing new host file
    tee: /etc/hosts: Permission denied
    > failed - retrying with sudo
    Password:
    > finished! # Last updated: Nov 24th, 2013 at 10:24

Usage
-----

    $ someonewhocares
    usage: someonewhocares [options]

    pull and install the latest host file from someonewhocares.org

    options
      -h           print this message and exit
      -t <type>    the host file type to pull, can be [ipv6, zero], leave blank for default
      -u           uninstall the host file by replacing it with a default template

License
-------

MIT License
