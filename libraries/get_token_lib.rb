module Gettoken
  module Helper
    require 'net/http'
    require 'uri'
    require 'openssl'
    require 'json'
    require 'nokogiri'
    def got_token
      xml_resp = Nokogiri::XML(
        File.open(
          "#{node['apm_agent']['temp_dir']}/#{node['apm_agent']['secrets_file']}"))
      value = ''
      xml_resp.xpath('//variable').each do |xml_var|
        next unless xml_var['name'] == 'client.secret.apmui'
        value = xml_var['value']
        break
      end
      classpath =
        "#{node['apm_agent']['decoder_dir']}/bootstrap.jar:"\
        "#{node['apm_agent']['decoder_dir']}/com.ibm.ws.emf.jar:"\
        "#{node['apm_agent']['decoder_dir']}/com.ibm.ws.runtime.jar:"\
        "#{node['apm_agent']['decoder_dir']}/ffdcSupport.jar:"\
        "#{node['apm_agent']['decoder_dir']}/org.eclipse.emf.common.jar:"\
        "#{node['apm_agent']['decoder_dir']}/org.eclipse.emf.ecore.jar"
      cmd =
        "/usr/bin/java -cp #{classpath} "\
        "com.ibm.ws.security.util.PasswordDecoder #{value}"\
        "|awk '{print $8}'|sed 's/\"//g'|tr -d '\n'"
      output = Mixlib::ShellOut.new(cmd)
      output.run_command
      output.error!
      uri = URI.parse('https://myapm:8099/oidc/endpoint/OP/token')
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(
        'grant_type' => 'password',
        'client_id' => 'rpapmui',
        'client_secret' => output.stdout,
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
        got_token(token1['access_token'])
      else
        got_token(response.code)
      end
    end # def
  end # Helper
  # notifies :create, 'template[client_secrets]', :immediately
end # Gettoken
