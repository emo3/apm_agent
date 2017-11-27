agent = 'was'
node.default['apm_agent']['silent_file'] = "APM_silent_install-#{agent}.txt"
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/#{agent}-agent.sh"
node.default['apm_agent']['log_file']    = "agent_install-#{agent}.log"
node.default['apm_agent']['silent_config'] = "#{agent}_silent_config.txt"
node.default['apm_agent']['config_log']  = "agent_config-#{agent}.log"
node.default['apm_agent']['process_bin'] = 'kynagent'

include_recipe '::install_agent'

# Write silent contents to a file
template "#{node['temp_dir']}/#{node['apm_agent']['silent_config']}" do
  source "#{node['apm_agent']['silent_config']}.erb"
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

# configure #{agent} agent using silent file, write output to log
execute "configure_#{agent}" do
  command "#{node['apm_agent']['agent_bin']} config \
#{node['temp_dir']}/#{node['apm_agent']['silent_config']} > \
#{node['temp_dir']}/#{node['apm_agent']['config_log']} 2>&1"
  cwd node['apm_agent']['apm_dir']
  not_if "ps aux | grep -v grep | grep #{node['apm_agent']['process_bin']}"
  user 'root'
  group 'root'
  umask '022'
end

# start #{agent} agent
execute "start_#{agent}" do
  command "#{node['apm_agent']['agent_bin']} start"
  cwd node['apm_agent']['apm_dir']
  not_if "ps aux | grep -v grep | grep #{node['apm_agent']['process_bin']}"
  user 'root'
  group 'root'
  umask '022'
end

file "#{node['temp_dir']}/#{node['apm_agent']['silent_config']}" do
  action :delete
end
