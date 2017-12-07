# set the IP and name of the APM Server
hostsfile_entry node['apm_agent']['apm_ip'] do
  hostname node['apm_agent']['apm_name']
  action   :create
  unique   true
end
