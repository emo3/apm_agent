node.default['apm_agent']['silent_file'] = 'APM_silent_install-rt.txt'
node.default['apm_agent']['agent_bin']   = "#{node['apm_agent']['apm_dir']}/bin/rt-agent.sh"
include_recipe '::install_agent'
