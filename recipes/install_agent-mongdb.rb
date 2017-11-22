node.default['apm_agent']['silent_file'] = 'APM_silent_install-mongdb.txt'
include_recipe '::install_agent'
