# Make copies of a war file with different configs

Useful if a rails app bundled in a war file via warbler needs to be deployed to several clients or to different databases. Lay out the different database.yml files (and others config files e.g. for email settings) in subdirs of the configs dir and run the app to generate correctly configured copies of the war file.

The code is designed to be compiled into a jar file for deployment and run via java.

### Requires

Rubyzip gem.

    gem install rubyzip

### To create a jar file

    rake to_jar

### To run via java

    java -jar jmt_cms_configurator.jar
or

    java -jar jmt_cms_configurator.jar cfig1 cfig2

### Required directory structure:

		root
			jmt_cms_configurator.rb (or jmt_cms_configurator.jar after compile)
			jmt_cms.war
			configs
				cfig1
					config.yml
					database.yml
					mail_settings.rb
					exception_notifier.rb
				cfig2
					config.yml
					database.yml
					mail_settings.rb
					exception_notifier.rb

