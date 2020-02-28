# frozen_string_literal: true

module ApplicationHelper
  private

  def navbar_link_class(link)
    if request.path == link
      'active'
    else
      ''
    end
  end

  def navbar_link(text, link, html_params={})
    html_params[:class] = navbar_link_class(link)
    link_to text, link, html_params
  end
end
