ENV['CHEF_GIT_REV'] = '11.6.0'
name "chef-client-mysql"
maintainer "John E. Vincent"
homepage "https://github.com/lusis/omnibus-chef-client-mysql"

replaces        "chef-client-mysql"
install_path    "/opt/chef-client-mysql"
version = "11.6.0" # match the chef version here
build_version "#{version}"
build_iteration 1

# creates required build directories
dependency "preparation"

dependency "mysql-ruby"
dependency "chef"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
