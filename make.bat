rem Make copies of the war file each configured for a different database.
rem ---------------------------------------------------------------------
rem
rem The default is to configure for all:
rem "java -jar jmt_cms_conigurator.jar"
rem
rem You can optionally specify which configurations to run:
rem "java -jar jmt_cms_conigurator.jar ph1 ph2" (where ph1 and ph2 are a subset of the configs)
rem
rem The required folder structure is:
rem root
rem   make.bat (THIS FILE)
rem   jmt_cms_conigurator.jar
rem   jmt_cms.war
rem   configs
rem     ph1
rem       config.yml
rem       database.yml
rem       mail_settings.rb
rem       exception_notifier.rb
rem     ph2
rem       config.yml
rem       database.yml
rem       mail_settings.rb
rem       exception_notifier.rb
rem (Where ph1 and ph2 can be any meaningful name and can be repeated for each required config)
rem The only file that MUST differ in each configs subdir is database.yml
rem which points to the relevant database.
rem
rem New war files will be created in the "wars" subdir.

java -jar jmt_cms_conigurator.jar
