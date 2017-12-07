#######################################
# Create base agent directory
directory node['apm_agent']['agents_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

#######################################
# Set physical volume
lvm_physical_volume '/dev/sdb'

#######################################
# Set volume group
lvm_volume_group 'apmvg' do
  physical_volumes ['/dev/sdb']
end

#######################################
# Set logical volume
lvm_logical_volume 'lvagent' do
  group 'apmvg'
  size '10G'
  filesystem 'xfs'
  mount_point node['apm_agent']['agents_dir']
end

#######################################
# Set /tmp to 3G, from the original 1.99 provided by build.
# APM needs minimum of 2G
lvm_logical_volume 'lvtmp' do
  group 'rootvg'
  size '6G'
  filesystem 'xfs'
  mount_point node['apm_agent']['temp_dir']
  # action :resize
  action :nothing
end

# create apm agents dir
directory node['apm_agent']['apm_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end
