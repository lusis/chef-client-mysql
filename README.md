# chef-client-mysql Omnibus project

This is a respin of the opscode chef client omnibus packages with the `mysql` gem baked in.

To do this it uses a hacky method of pulling in the mysqlclient libs and headers from the percona generic static build tarballs.
Then it installs the `mysql` gem in the omnibus'd ruby (the same one `chef` uses).

What this means in practice is that any calls to `chef_gem 'mysql'` will already be satisfied.

## Why?
To use the chef `mysql_*` resources, you need to have the `mysql` gem installed. This is because the LWRP for mysql stuff uses native ruby instead of shelling out to the mysql client.

Without debating the merits of that here, it's the way it is. 

The problem comes when you want to use something like Percona builds of mysql and need to use the mysql resources. You can build against the percona packages you have installed but only if the packages are installed first. There's not currently a clean way to get the repo added BEFORE the gem attempts to install. The `apt_repository` resource, for instance, doesn't work if you try to run it at compile time. 

So basically with the current state of things, there's not a way to use the mysql LWRPs without pulling in the disro's packages for MySQL.

Another reason is that we have to use chef frequently in places where we don't have external internet access. This breaks a SHITLOAD of assumptions in Chef (I don't blame Chef here). We might not be able to pull files from rubygems so now I'd have to write this wrapper to install from a gemfile and all that. I decided to shave the yak using an omnibus triple blade razor.

## Usage
The usage is pretty straightforward.

- Install Vagrant + virtualbox
- Install the Berkshelf vagrant plugin
- Install the Omnibus vagrant plugin
- run `vagrant up <distro>`
- Go get coffee/tea/beer/scotch (not all at the same time unless that's your thing)

When you come back, you'll have a nice omnibus chef package in the `pkg` directory for your distro. It is identical to the packages distributed by Opscode with two exceptions:

- It's installed into `/opt/chef-client-mysql`
- It has the mysql gem preinstalled

*Note: You can see the list of distros in the `Vagrantfile`.*

## Caveat
This works for me. It may not work for you. mysql native language bindings are notoriously picky. This was built against Percona 5.5 libs which should be backwards compatible to anything that someone using Chef would actually install. If you're using something older than that, you must be an enterprise or something.

This has been tested on both CentOS6 and Ubuntu-12.04 (64 bit only) with most of the `mysql` resources. We're bundling it in with our own stuff going forward.

## Customization
If you want to change any of the versions, here are the places you would look:

- Chef client version - `config/project/chef-client-mysql.rb` at the top of the file
- Percona library version - `config/software/percona-dev.rb`
- MySQL gem version - `config/software/mysql-ruby.rb`

Below are the standard omnibus project instructions that I was too lazy to clean up

# Standard boilerplate Omnibus generated README

## Installation

We'll assume you have Ruby 1.9+ and Bundler installed. First ensure all
required gems are installed and ready to use:

```shell
$ bundle install --binstubs
```

## Usage

### Build

You create a platform-specific package using the `build project` command:

```shell
$ bin/omnibus build project chef-client-mysql
```

The platform/architecture type of the package created will match the platform
where the `build project` command is invoked. So running this command on say a
MacBook Pro will generate a Mac OS X specific package. After the build
completes packages will be available in `pkg/`.

### Clean

You can clean up all temporary files generated during the build process with
the `clean` command:

```shell
$ bin/omnibus clean
```

Adding the `--purge` purge option removes __ALL__ files generated during the
build including the project install directory (`/opt/chef-client-mysql`) and
the package cache directory (`/var/cache/omnibus/pkg`):

```shell
$ bin/omnibus clean --purge
```

### Help

Full help for the Omnibus command line interface can be accessed with the
`help` command:

```shell
$ bin/omnibus help
```

## Vagrant-based Virtualized Build Lab

Every Omnibus project ships will a project-specific
[Berksfile](http://berkshelf.com/) and [Vagrantfile](http://www.vagrantup.com/)
that will allow you to build your projects on the following platforms:

* CentOS 5 64-bit
* CentOS 6 64-bit
* Ubuntu 10.04 64-bit
* Ubuntu 11.04 64-bit
* Ubuntu 12.04 64-bit

Please note this build-lab is only meant to get you up and running quickly;
there's nothing inherent in Omnibus that restricts you to just building CentOS
or Ubuntu packages. See the Vagrantfile to add new platforms to your build lab.

The only requirements for standing up this virtualized build lab are:

* VirtualBox - native packages exist for most platforms and can be downloaded
from the [VirtualBox downloads page](https://www.virtualbox.org/wiki/Downloads).
* Vagrant 1.2.1+ - native packages exist for most platforms and can be downloaded
from the [Vagrant downloads page](http://downloads.vagrantup.com/).

The [vagrant-berkshelf](https://github.com/RiotGames/vagrant-berkshelf) and
[vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) Vagrant plugins
are also required and can be installed easily with the following commands:

```shell
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-omnibus
```

Once the pre-requisites are installed you can build your package across all
platforms with the following command:

```shell
$ vagrant up
```

If you would like to build a package for a single platform the command looks like this:

```shell
$ vagrant up PLATFORM
```

The complete list of valid platform names can be viewed with the
`vagrant status` command.
