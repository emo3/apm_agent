node.default['apm_agent']['silent_file'] = 'APM_silent_install-mongdb.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/mongdb-agent.sh"
node.default['apm_agent']['log_file']    = 'agent_install-mongdb.log'
include_recipe '::install_agent'
