module InvalidUTF8Rejector
  class Railtie < Rails::Railtie
    initializer "invalid_utf8_rejector.insert_middleware" do |app|
      if Rails::VERSION::MAJOR >= 5
        app.config.middleware.insert_before 0, InvalidUTF8Rejector::Middleware
      else
        app.config.middleware.insert_before 0, "InvalidUTF8Rejector::Middleware"
      end
    end
  end
end
