require 'capybara/rails'

Capybara.ignore_hidden_elements = false

if ENV['SELENIUM_HOST'].present?
  require 'selenium-webdriver'

  ip = `ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d ':' -f2 | cut -d ' ' -f1`.strip
  ip = '127.0.0.1' if ip.blank?
  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = 3010
  Capybara.app_host = "http://#{ip}:#{Capybara.server_port}"

  Capybara.register_driver :remote_browser do |app|
    Capybara::Selenium::Driver.new app,
        :browser              => :remote,
        :url                  => "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
        :desired_capabilities => Selenium::WebDriver::Remote::Capabilities.firefox
  end
  Capybara.register_driver :iphone do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
    capabilities['general.useragent.override'] = 'iPhone'
    Capybara::Selenium::Driver.new app,
        :browser              => :remote,
        :url                  => "http://#{ENV['SELENIUM_HOST']}:4444/wd/hub",
        :desired_capabilities => capabilities
  end
  Capybara.javascript_driver = :remote_browser
else
  Capybara.javascript_driver = :selenium
  Capybara.register_driver :iphone do |app|
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['general.useragent.override'] = "iPhone"
    Capybara::Selenium::Driver.new app, profile: profile
  end
end
