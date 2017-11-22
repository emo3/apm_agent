node.default['apm_agent']['silent_file'] = 'APM_silent_install-was.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/was-agent.sh"
node.default['apm_agent']['log_file']    = 'agent_install-was.log'
include_recipe '::install_agent'
