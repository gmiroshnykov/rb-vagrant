rb-vagrant
==========

Review Board playground powered by Vagrant.


Requirements
------------

* Vagrant 1.5.2+
* VirtualBox 4.3.10+


Usage
-----

1. Add the following line to your `/etc/hosts`:

        10.0.20.2       rb.dev

2. Provision a VM using Vagrant:

        vagrant up


Details
-------

The following things are installed:

* Python
* Apache2 + mod_wsgi
* MySQL
* Memcached
* Git & Mercurial
* ReviewBoard 2.0 (dev)

### MySQL credentials:

* root : root
* reviewboard : reviewboard

### Review Board credentials:

[http://rb.dev/](http://rb.dev/)

* admin : admin
