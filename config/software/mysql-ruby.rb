name "mysql-ruby"
version "2.9.1"

dependency "ruby"
dependency "rubygems"
dependency "percona-dev"

build do
  gem "install mysql -n #{install_dir}/bin --no-rdoc --no-ri -v #{version}"
end
