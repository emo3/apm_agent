node.default['apm_agent']['silent_file'] = 'APM_silent_install-db2.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/db2-agent.sh"
node.default['apm_agent']['log_file']    = 'agent_install-db2.log'

include_recipe '::install_agent'

# configure db2 agent using silent file, write output to log
execute 'configure_db2' do
  command "#{node['apm_agent']['agent_bin']} config db2apm \
-p #{node['apm_agent']['apm_dir']}/samples/DB2_silent_config.txt > \
#{node['temp_dir']}/#{node['apm_agent']['log_file']} 2>&1"
  cwd node['apm_agent']['apm_dir']
  # not_if { File.exist?(node['apm_agent']['agent_bin']) }
  user 'root'
  group 'root'
  umask '022'
end
