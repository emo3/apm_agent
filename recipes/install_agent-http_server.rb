node.default['apm_agent']['silent_file'] = 'APM_silent_install-http_server.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/http_server-agent.sh"
node.default['apm_agent']['log_file']    = 'agent_install-http_server.log'
include_recipe '::install_agent'
