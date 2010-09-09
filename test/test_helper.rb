# Add this folder to the load path for "test_helper"
$:.unshift(File.dirname(__FILE__))

require 'vagrant'
require 'mario'
require 'contest'
require 'mocha'
require 'support/path'
require 'support/environment'
require 'support/objects'

# Try to load ruby debug since its useful if it is available.
# But not a big deal if its not available (probably on a non-MRI
# platform)
begin
  require 'ruby-debug'
rescue LoadError
end

# Silence Mario by sending log output to black hole
Mario::Platform.logger(nil)

# Add the I18n locale for tests
I18n.load_path << File.expand_path("../locales/en.yml", __FILE__)

class Test::Unit::TestCase
  include VagrantTestHelpers::Path
  include VagrantTestHelpers::Environment
  include VagrantTestHelpers::Objects

  # Sets up the mocks for a VM
  def mock_vm(env=nil)
    env ||= vagrant_env
    vm = Vagrant::VM.new
    vm.stubs(:env).returns(env)
    vm.stubs(:ssh).returns(Vagrant::SSH.new(vm.env))
    vm
  end

  def mock_action_data(v_env=nil)
    v_env ||= vagrant_env
    app = lambda { |env| }
    env = Vagrant::Action::Environment.new(v_env)
    env["vagrant.test"] = true
    [app, env]
  end

  # Sets up the mocks and stubs for a downloader
  def mock_downloader(downloader_klass)
    tempfile = mock("tempfile")
    tempfile.stubs(:write)

    _, env = mock_action_data
    [downloader_klass.new(env), tempfile]
  end
end

