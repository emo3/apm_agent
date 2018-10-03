# This will install the decoder files
directory 'decoder_dir' do
  path node['apm_agent']['decoder_dir']
  recursive true
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

remote_file "#{node['apm_agent']['decoder_dir']}/#{node['apm_agent']['decoder_file']}" do
  source "#{node['apm_agent']['media_url']}/#{node['apm_agent']['decoder_file']}"
  not_if { File.exist?("#{node['apm_agent']['decoder_dir']}/bootstrap.jar") }
  owner 'root'
  group 'root'
  mode '0644'
end

# untar the decoder file
tar_extract "#{node['apm_agent']['decoder_dir']}/#{node['apm_agent']['decoder_file']}" do
  action :extract_local
  target_dir node['apm_agent']['decoder_dir']
  creates "#{node['apm_agent']['decoder_dir']}/bootstrap.jar"
  compress_char ''
  not_if { File.exist?("#{node['apm_agent']['decoder_dir']}/bootstrap.jar") }
end
