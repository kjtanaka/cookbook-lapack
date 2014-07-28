default['lapack']['version'] = "3.5.0"
default['lapack']['download_url'] = "http://www.netlib.org/lapack/lapack-#{node['lapack']['version']}.tgz"
default['lapack']['download_dir'] = "/root/source"
default['lapack']['install_dir'] = "/opt"
default['lapack']['required_packages'] = %w[gcc-gfortran]

# Environment Modules
default['lapack']['modulefile_dir'] = "/opt/modules-3.2.10/Modules/3.2.10/modulefiles/lapack"
default['lapack']['default_version'] = node['lapack']['version']
