# Copyright (c) 2012-2013 Stark & Wayne, LLC

module Bosh; module CloudFoundry; end; end

# Model for the configuration data of a CloudFoundry System
# description.
# Stores the data as a YAML configuration file within a System's
# home folder.
class Bosh::CloudFoundry::SystemConfig < Bosh::Cli::Config

  # Defaults the +system_dir+ and +system_name+ based on the path
  # of the +config_file+.
  # It is assumed that the +config_file+ is located within a folder
  # dedicated to the System begin configured.
  def initialize(system_dir)
    config_file      = File.join(system_dir, "manifest.yml")
    super(config_file, system_dir)
    self.system_dir  = system_dir
    self.system_name = File.basename(system_dir)
  end

  [
    :bosh_provider,    # from list 'aws', 'openstack', 'vsphere', 'vcloud'
    :system_name,      # e.g. production
    :system_dir,       # e.g. /var/vcap/store/systems/production
    :release_name,     # e.g. 'appcloud'
    :stemcell_version, # e.g. '0.6.7'
    :core_ip,          # Static IP for Core CF server (router, cc) e.g. '1.2.3.4'
    :root_dns,         # Root DNS for cc & user apps, e.g. 'mycompanycloud.com'
    :core_server_flavor, # Server size for CF Core; e.g. 'm1.xlarge' on AWS
    :runtimes,         # e.g. { "ruby18" => false, "ruby19" => true }
    :common_password,  # e.g. 'c1oudc0wc1oudc0w` - must be 16 chars for CC password
    :dea,              # e.g. { "count" => 2, "flavor" => "m1.large" }
  ].each do |attr|
    define_method attr do
      read(attr, false)
    end

    define_method "#{attr}=" do |value|
      write_global(attr, value)
    end
  end
end
