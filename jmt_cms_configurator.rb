require 'rubygems'
require 'zip/zip'
require 'pathname'

# Take a warfile in a dir with configuration files in subdirs and
# create a copy for each config set.
#
# Dir structure:
#   root
#     jmt_cms_config.rb (THIS FILE)
#     war_file.war
#     configs
#       cfig1
#         config.yml
#         database.yml
#         mail_settings.rb
#         exception_notifier.rb
#       cfig2
#         config.yml
#         database.yml
#         mail_settings.rb
#         exception_notifier.rb
class WarFile

  # Pass in the filename.
  # Performs some validations - does the file exist, does the file have the correct structure.
  def initialize( file )
    @file = file
    # does file exist?
    unless File.exists?( file )
      puts "ERROR: File \"#{file}\' not found."
      exit 1
    end
    @base_path = Dir.pwd
    # validate - does it have a WEB_INF/config dir?
    unless validate( file )
      puts "ERROR: File \"#{file}\" does not contain config files."
      exit 1
    end
    get_config_dirs
  end

  # Run the configuration updates.
  # opts can contain an entry :configs which has an array of config
  # name to constrain the app to just creating those war files.
  def run(opts={})
    # check if opts are for a specific dir only or all (default)
    # for each config
    configs = opts[:configs] || @configs
    if configs.any? {|c| !@configs.include?( c ) }
      puts "ERROR: Invalid configuration options: \"#{configs.join(', ')}\"."
      exit 1
    end
    configs.each do |config|
      modify_config(config)
    end
  end

private

  # Check if required files are present in the war file.
  def validate( file )
    Zip::ZipFile.open(file) do |zip_file|
      unless zip_file.find_entry('WEB-INF/config/config.yml') &&
             zip_file.find_entry('WEB-INF/config/database.yml') &&
             zip_file.find_entry('WEB-INF/config/environments/mail_settings.rb') &&
             zip_file.find_entry('WEB-INF/config/initializers/exception_notifier.rb')
        return false
      end
    end
    true
  end

  # Assemble an Array of configs and their paths.
  def get_config_dirs
    @configs      = []
    @config_paths = {}
    dir = Pathname.new(File.join(@base_path, 'configs'))
    dir.children.each do |child|
      if child.directory?
        base                = child.basename.to_s
        @config_paths[base] = child
        @configs << base
      end
    end
  end

  # Perform the update for a particular config.
  def modify_config(config)
    subdir = File.join(@base_path, 'wars', config)
    # make war/config subdir if not exists
    make_subdir subdir
    # copy war to the dir
    FileUtils.cp(@file, subdir, :preserve => true)
    # update zip
    Zip::ZipFile.open(File.join(subdir, @file)) do |zip_file|
      zip_file.add('WEB-INF/config/config.yml', @config_paths[config] + 'config.yml') { true }
      zip_file.add('WEB-INF/config/database.yml', @config_paths[config] + 'database.yml') { true }
      zip_file.add('WEB-INF/config/environments/mail_settings.rb', @config_paths[config] + 'mail_settings.rb') { true }
      zip_file.add('WEB-INF/config/initializers/exception_notifier.rb', @config_paths[config] + 'exception_notifier.rb') { true }
    end
    puts "Copied and configured: #{subdir}/#{@file}."
  end

  # Create a subdir for a config (if required).
  def make_subdir( subdir )
    subdir = Pathname.new(subdir).mkpath
  end

end

# Code to execute:
# - create a WarFile instance and call #run on it.

wf = WarFile.new('jmt_cms.war')
puts "Configuring copies of jmt_cms.war"

if ARGV.empty?
  puts "\n"
  wf.run
else
  puts "- Using parameters: #{ARGV.join(', ')}.\n\n"
  wf.run :configs => ARGV
end

