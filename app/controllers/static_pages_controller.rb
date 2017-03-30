class StaticPagesController < ApplicationController
  skip_before_filter :require_login, only: [:root]
end