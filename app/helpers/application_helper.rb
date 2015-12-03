module ApplicationHelper
  def link_with_icon link, uri, icon='home', size='medium'
    link_to "<i class='fi-#{icon} #{size}'></i> #{link}".html_safe, uri
  end

  def heading title
    content = content_tag :blockquote do
      content_tag :h4 do
        title
      end
    end

    content << content_tag(:div, '', class: "divider")
  end
end
