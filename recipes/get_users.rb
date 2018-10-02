include_recipe '::get_token'

uri = URI.parse('https://myapm:9443/1.0/authzn/users')
request = Net::HTTP::Get.new(uri)
request.content_type = 'application/json'
request['Authorization'] = "Bearer #{node['apm_agent']['access_token']}"
request['Accept'] = 'application/json'
request['X-Ibm-Service-Location'] = 'na'
req_options = {
  use_ssl: uri.scheme == 'https',
  verify_mode: OpenSSL::SSL::VERIFY_NONE,
}
response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
if response.is_a?(Net::HTTPSuccess)
  puts response.body
else
  puts "BAD=#{response.code}!"
end
