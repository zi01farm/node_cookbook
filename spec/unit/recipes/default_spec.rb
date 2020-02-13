#
# Cookbook:: chef_getting_started_2
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef_getting_started_2::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'should install nginx' do
      expect(chef_run).to install_package "nginx"
    end
    it 'should enable nginx' do
      expect(chef_run).to enable_service("nginx")
    end
    it 'should start nginx' do
      expect(chef_run).to start_service("nginx")
    end
    it 'should install nodejs from recipe' do
      expect(chef_run).to include_recipe('nodejs')
    end
    it 'should install pm2 via npm' do
      expect(chef_run).to install_nodejs_npm('pm2')
    end
    it 'should create a proxy.conf template in /etc/nginx/sites-available' do
      expect(chef_run).to create_template("/etc/nginx/sites-available/proxy.conf").with_variables(proxy_port: 3000)
    end
    it 'should create symbolic link from sites-available to sites-enabled' do
      expect(chef_run).to create_link("/etc/nginx/sites-enabled/proxy.conf").with_link_type(:symbolic)
    end
    it 'should delete the default site enabled link' do
      expect(chef_run).to delete_link("/etc/nginx/sites-enabled/default")
    end

    at_exit { ChefSpec::Coverage.report! }
  end
end
