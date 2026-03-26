class PagesController < ApplicationController
  before_action :authenticate_user!, only: :home

  def home
  end

  def styleguide_markdown
    send_file Rails.root.join("STYLEGUIDE.md"), type: "text/markdown; charset=utf-8", disposition: "inline"
  end
end
