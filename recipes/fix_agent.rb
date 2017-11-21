#######################################
# The following was taken from the PreRequisite Scanner
# begin PRS Section

# Install RPM's
package node['apm_agent']['rhel'] if node['platform_family'] == 'rhel'
# end PRS Section
#######################################
