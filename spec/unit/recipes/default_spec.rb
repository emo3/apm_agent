# Cookbook:: apm_agent
# Spec:: default
#
# Copyright:: 2017, Ed Overton, Apache 2.0

require 'spec_helper'

describe 'apm_agent::install_agent' do
  context 'When all attributes are default, on an Redhat 7.5' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.5')
      runner.converge(described_recipe)
    end
    before do
      stub_command('ps aux | grep -v grep | grep klzagent').and_return(true)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
