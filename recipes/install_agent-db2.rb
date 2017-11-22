node.default['apm_agent']['silent_file'] = 'APM_silent_install-db2.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/db2-agent.sh"
node.default['apm_agent']['log_file']    = 'agent_install-db2.log'
include_recipe '::install_agent'
