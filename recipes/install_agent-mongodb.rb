node.default['apm_agent']['silent_file'] = 'APM_silent_install-mongodb.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/mongodb-agent.sh"
node.default['apm_agent']['log_file']    = 'agent_install-mongodb.log'
include_recipe '::install_agent'
