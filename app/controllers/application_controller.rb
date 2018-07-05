class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # methods in application_controller are only available to other controllers
  # to make them available to view templates declare as helper_method

end
