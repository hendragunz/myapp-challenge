class Users::SessionsController < Devise::SessionsController
  layout "devise", only: [:new]
end
