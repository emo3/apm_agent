default['apm_agent']['version']       = '8.1.4.0'
default['apm_agent']['agents_lnx']    = "apm_base_agents_xlinux_#{node['apm_agent']['version']}.tar"
default['apm_agent']['agents_pnx']    = "apm_base_agents_plinuxle_#{node['apm_agent']['version']}.tar"
default['apm_agent']['agents_aix']    = "apm_base_agents_aix_#{node['apm_agent']['version']}.tar"
default['apm_agent']['lnx_name']      = "APM_Agent_Install_#{node['apm_agent']['version']}"
default['apm_agent']['pnx_name']      = "APM_PLINUXLE_Agent_Install_#{node['apm_agent']['version']}"
default['apm_agent']['aix_name']      = "APM_AIX_Agent_Install_#{node['apm_agent']['version']}"
default['apm_agent']['lvg_name']      = 'apmvg'
default['apm_agent']['agents_dir']    = '/agents'
default['apm_agent']['apm_dir']       = '/agents/apm'
default['apm_agent']['decoder_dir']   = '/agents/apm/decoder'
default['apm_agent']['decoder_file']  = 'decoder.tar'
default['apm_agent']['silent_file']   = 'APM_silent_install-os.txt'
default['apm_agent']['silent_config'] = 'APM_silent_config-os.txt'
default['apm_agent']['agent_bin']     = "#{node['apm_agent']['apm_dir']}/bin/os-agent.sh"
default['apm_agent']['config_bin']    = "#{node['apm_agent']['apm_dir']}/config/kcirunas.cfg"
default['apm_agent']['process_bin']   = 'klzagent'
default['apm_agent']['log_file']      = 'agent_install-os.log'
default['apm_agent']['config_log']    = 'agent_config-os.log'
default['apm_agent']['rhel']          = %w(bc java-1.8.0-openjdk)
default['apm_agent']['apm_ip']        = '10.1.1.20'
default['apm_agent']['apm_name']      = 'myapm'
default['apm_agent']['media_url']     = 'http://10.1.1.30/media'
default['apm_agent']['depot_url']     = 'http://10.1.1.30/media/depot'
default['apm_agent']['temp_dir']      = '/tmp'
default['apm_agent']['chefsrv_ip']    = '10.1.1.10'
default['apm_agent']['chefsrv_name']  = 'chefsrv'
default['apm_agent']['secrets_file']  = 'clientSecrets.xml'
