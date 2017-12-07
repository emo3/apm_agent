# This will install the decoder files
template "#{node['apm_agent']['temp_file']}/#{node['apm_agent']['secrets_file']}" do
  source "#{node['apm_agent']['secrets_file']}.erb"
  not_if { File.exist?("#{node['apm_agent']['temp_file']}/#{node['apm_agent']['secrets_file']}") }
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

directory node['apm_agent']['decoder_dir'] do
  recursive true
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

remote_file "#{node['apm_agent']['decoder_dir']}/#{node['apm_agent']['decoder_file']}" do
  source "#{node['apm_agent']['media_url']}/#{node['apm_agent']['decoder_file']}"
  # not_if { File.exist?("#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}/installAPMAgents.sh") }
  owner 'root'
  group 'root'
  mode '0644'
end

# untar the decoder file
tar_extract "#{node['apm_agent']['decoder_dir']}/#{node['apm_agent']['agents_lnx']}" do
  action :extract_local
  target_dir node['apm_agent']['apm_dir']
  creates "#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}/installAPMAgents.sh"
  compress_char ''
  not_if { File.exist?("#{node['apm_agent']['apm_dir']}/#{node['apm_agent']['lnx_name']}/installAPMAgents.sh") }
  not_if { File.exist?(node['apm_agent']['agent_bin']) }
end
