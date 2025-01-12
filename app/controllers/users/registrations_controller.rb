class Users::RegistrationsController < Devise::RegistrationsController
  layout "devise", only: [:new, :create]
  layout "application", only: [:edit, :update]
end
