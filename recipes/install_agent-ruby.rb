node.default['apm_agent']['silent_file'] = 'APM_silent_install-ruby.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/ruby-agent.sh"
node.default['apm_agent']['log_file']    = 'agent_install-ruby.log'
include_recipe '::install_agent'
