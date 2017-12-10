include_recipe '::setapmip'
include_recipe '::install_decoder'

# create clientSecrets.xml
template 'client_secrets' do
  path "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['secrets_file']}"
  source "#{node['apm_agent']['secrets_file']}.erb"
  not_if { File.exist?("#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['secrets_file']}") }
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

ruby_block 'retrieve token from secrets' do
  block do
    require 'net/http'
    require 'uri'
    require 'openssl'
    require 'json'
    require 'nokogiri'
    xml_resp = Nokogiri::XML(File.open("#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['secrets_file']}"))
    value = ''
    xml_resp.xpath('//variable').each do |xml_var|
      next unless xml_var['name'] == 'client.secret.apmui'
      value = xml_var['value']
      break
    end
    classpath = "#{node['apm_agent']['decoder_dir']}/bootstrap.jar:#{node['apm_agent']['decoder_dir']}/com.ibm.ws.emf.jar:#{node['apm_agent']['decoder_dir']}/com.ibm.ws.runtime.jar:#{node['apm_agent']['decoder_dir']}/ffdcSupport.jar:#{node['apm_agent']['decoder_dir']}/org.eclipse.emf.common.jar:#{node['apm_agent']['decoder_dir']}/org.eclipse.emf.ecore.jar"
    # puts ("value=#{value}")
    output = Mixlib::ShellOut.new("/usr/bin/java -cp #{classpath} com.ibm.ws.security.util.PasswordDecoder #{value}|awk '{print $8}'|sed 's/\"//g'")
    output.run_command
    output.error!
    decodedpw = output.stdout
    # decodedpw = output.stdout(/decoded password == "(.*)"/)
    puts "decodedpw=#{decodedpw}"
    uri = URI.parse('https://myapm:8099/oidc/endpoint/OP/token')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      'grant_type' => 'password',
      'client_id' => 'rpapmui',
      # 'client_secret' => decodedpw,
      'client_secret' => 'ZnV7T2o/ZV5HSTMraSVYMlIwdXwgKy',
      'username' => 'apmadmin',
      'password' => 'apmpass',
      'scope' => 'openid'
    )
    req_options = {
      use_ssl: uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    if response.is_a?(Net::HTTPSuccess)
      token1 = JSON.parse(response.body)
      node.default['apm_agent']['access_token'] = token1['access_token']
    else
      node.default['apm_agent']['access_token'] = 'ERROR'
    end
    puts "access_token=#{node['apm_agent']['access_token']}"
  end
  notifies :create, 'template[client_secrets]', :immediately
end
