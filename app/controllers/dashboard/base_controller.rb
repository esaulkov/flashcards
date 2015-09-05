class Dashboard::BaseController < ApplicationController
  before_action :require_login
end
