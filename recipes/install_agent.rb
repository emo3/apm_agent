set_hostname 'set apm server' do
  host_ip   node['apm_agent']['apm_ip']
  host_name node['apm_agent']['apm_name']
  action :run
end

set_hostname 'set chefsrv server' do
  host_ip   node['apm_agent']['chefsrv_ip']
  host_name node['apm_agent']['chefsrv_name']
  action :run
end
include_recipe '::filesystem'
include_recipe '::fix_agent'

# turn off Prerequisite Scanner
ENV['SKIP_PRECHECK'] = 'Yes'

raise "*** Machine #{node['kernel']['machine']} is NOT coded for!" unless node['kernel']['machine'] == 'x86_64'
# Download the Linux APM agent binary
remote_file "#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['agents_lnx']}" do
  source "#{node['apm_agent']['depot_url']}/#{node['apm_agent']['agents_lnx']}"
  not_if { File.exist?("#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}/installAPMAgents.sh") }
  not_if { File.exist?(node['apm_agent']['agent_bin']) }
  owner 'root'
  group 'root'
  mode '0644'
end

# untar the apm binary file
tar_extract "#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['agents_lnx']}" do
  action :extract_local
  target_dir node['apm_agent']['apm_dir']
  creates "#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}/installAPMAgents.sh"
  compress_char ''
  not_if { File.exist?("#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}/installAPMAgents.sh") }
  not_if { File.exist?(node['apm_agent']['agent_bin']) }
end

# delete the apm tar file
file "#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['agents_lnx']}" do
  action :delete
end

# Write silent contents to a file
template "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['silent_file']}" do
  source "#{node['apm_agent']['silent_file']}.erb"
  not_if { File.exist?(node['apm_agent']['agent_bin']) }
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

# install apm agent using silent file, write output to log
execute 'install_agent' do
  command "#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}/installAPMAgents.sh \
-p #{node['apm_agent']['temp_dir']}/#{node['apm_agent']['silent_file']} > \
#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['log_file']} 2>&1"
  cwd node['apm_agent']['apm_dir']
  not_if { File.exist?(node['apm_agent']['agent_bin']) }
  user 'root'
  group 'root'
  umask '022'
end

# print out the log file
# results = "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['log_file']}"
# ruby_block 'list_results' do
#  only_if { ::File.exist?(results) }
#  block do
#    print "\n"
#    File.open(results).each do |line|
#      print line
#    end
#  end
# end

# delete the install apm dir
directory "#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}" do
  recursive true
  action :delete
end

# delete the apm response file
file "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['silent_file']}" do
  action :delete
end
