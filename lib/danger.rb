require "danger/version"
require "danger/danger_core/dangerfile"
require "danger/danger_core/environment_manager"
require "danger/commands/runner"
require "danger/plugin_support/plugin"
require "danger/core_ext/string"
require "danger/danger_core/executor"

require "claide"
require "colored"
require "pathname"
require "terminal-table"
require "cork"

# Import all the Sources (CI, Request and SCM)
Dir[File.expand_path("danger/*source/*.rb", File.dirname(__FILE__))].each do |file|
  require file
end

module Danger
  # @return [String] The path to the local gem directory
  def self.gem_path
    gem_name = "danger"
    unless Gem::Specification.find_all_by_name(gem_name).any?
      raise "Couldn't find gem directory for 'danger'"
    end
    return Gem::Specification.find_by_name(gem_name).gem_dir
  end

  # @return [String] Latest version of Danger on https://rubygems.org
  def self.danger_outdated?
    require "danger/clients/rubygems_client"
    latest_version = RubyGemsClient.latest_danger_version

    if Gem::Version.new(latest_version) > Gem::Version.new(Danger::VERSION)
      latest_version
    else
      false
    end
  rescue Exception => _e
    false
  end
end
