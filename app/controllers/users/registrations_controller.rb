class Users::RegistrationsController < Devise::RegistrationsController
  layout "devise", only: [:new]


end
