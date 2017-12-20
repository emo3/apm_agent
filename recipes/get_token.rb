include_recipe '::setapmip'
include_recipe '::install_decoder'

# create clientSecrets.xml
template 'client_secrets' do
  path "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['secrets_file']}"
  source "#{node['apm_agent']['secrets_file']}.erb"
  not_if { File.exist?("#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['secrets_file']}") }
  notifies :create, got_token, :immediately
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

node.default['apm_agent']['access_token'] = got_token?
