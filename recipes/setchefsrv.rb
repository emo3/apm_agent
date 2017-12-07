# set the IP and chef server name
hostsfile_entry node['apm_agent']['chefsrv_ip'] do
  hostname node['apm_agent']['chefsrv_name']
  action   :create
  unique   true
end
