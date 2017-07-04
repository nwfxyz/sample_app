module ApplicationHelper
  #Returns full title if no title
  
  def fulltitle(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    if page_title.length == 0
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
