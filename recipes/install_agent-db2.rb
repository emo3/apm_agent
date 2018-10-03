agent = 'db2'
node.default['apm_agent']['silent_file']   = "APM_silent_install-#{agent}.txt"
node.default['apm_agent']['agent_bin']     = "#{node['apm_agent']['apm_dir']}/bin/#{agent}-agent.sh"
node.default['apm_agent']['log_file']      = "agent_install-#{agent}.log"
node.default['apm_agent']['silent_config'] = "#{agent}_silent_config.txt"
node.default['apm_agent']['config_log']    = "agent_config-#{agent}.log"
node.default['apm_agent']['config_bin']    = "#{node['apm_agent']['apm_dir']}/config/myapm_ud_db2apm.cfg"

include_recipe '::install_agent'

# Write silent contents to a file
template "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['silent_config']}" do
  source "#{node['apm_agent']['silent_config']}.erb"
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

# configure #{agent} agent using silent file, write output to log
execute "configure_#{agent}" do
  command "#{node['apm_agent']['agent_bin']} config db2apm \
#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['silent_config']} > \
#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['config_log']} 2>&1"
  cwd node['apm_agent']['apm_dir']
  not_if { File.exist?(node['apm_agent']['config_bin']) }
  user 'root'
  group 'root'
  umask '022'
end

# start #{agent} agent
execute "start_#{agent}" do
  command "#{node['apm_agent']['agent_bin']} start db2apm"
  cwd node['apm_agent']['apm_dir']
  not_if 'ps aux | grep kuddb2 | grep myapm'
  user 'root'
  group 'root'
  umask '022'
end

file "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['silent_config']}" do
  action :delete
end
