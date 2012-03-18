require 'rake/clean'

#CLEAN.include 'tmp', 'Launcher.class', 'vendor'
CLEAN.include 'tmp', 'Launcher.class'
CLOBBER.include 'jmt_cms_configurator.jar'

directory 'vendor'

desc 'Install Ruby gems into vendor/'
task :install_gems => 'vendor' do
  sh 'jruby -S gem install -i vendor rubyzip'
end

desc 'Build Java launcher that will start the Ruby program'
task :build_launcher do
  sh 'javac -cp jruby-complete-1.6.7.jar Launcher.java'
end

directory 'tmp'

desc 'Extract jruby-complete so we can combine it with the app'
task :extract_jruby => 'tmp' do
  Dir.chdir('tmp') do
    sh 'jar -xf ../jruby-complete-1.6.7.jar'
  end
end

desc 'Combine app, launcher, and JRuby into one jar'
#task :to_jar => [:install_gems, :build_launcher, :extract_jruby] do
task :to_jar => [:build_launcher, :extract_jruby] do
  sh 'jar -cfm jmt_cms_configurator.jar app.manifest Launcher.class jmt_cms_configurator.rb -C vendor . -C tmp .'
end

