rb-vagrant
==========

Review Board playground powered by Vagrant.


Requirements
------------

    * Vagrant 1.4.3+
    * VirtualBox 4.3.6+


Usage
-----

1. Add the following line to your `/etc/hosts`:

        10.0.20.2       rb.dev

2. Provision a VM using Vagrant:

        vagrant up

3. Open [http://rb.dev/](http://rb.dev/) in your browser:

    * username: admin
    * password: admin


Details
-------

The following things are installed:

* Python
* Apache2 + mod_wsgi
* MySQL
* Memcached
* Git & Mercurial
* ReviewBoard 2.0 (dev)
* RBTools 0.5

### MySQL credentials:

* root : root
* reviewboard : reviewboard

### Review Board credentials:

[http://rb.dev/](http://rb.dev/)

* admin : admin
