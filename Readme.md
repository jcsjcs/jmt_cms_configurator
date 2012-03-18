# Make copies of a war file with different configs

Takes a warfile in a dir with configuration files in subdirs and
creates a copy for each config set.
The code is designed to be compiled into a jar file for deployment and run via java.

## To create a jar file

    rake to_jar

## To run via java

    java -jar jmt_cms_configurator.jar
or
    java -jar jmt_cms_configurator.jar cfig1 cfig2

## Required directoy structure:

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

