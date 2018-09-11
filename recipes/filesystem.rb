#######################################
# Create base agent directory
directory node['apm_agent']['agents_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

create_xfs 'create /agents extra file system' do
  action :run
end

# create apm agents dir
directory node['apm_agent']['apm_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end
