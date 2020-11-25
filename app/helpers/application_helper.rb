module ApplicationHelper
    
  # ページごとにタイトルを返す
  def full_title(page_name = "")
    base_title = "AttendanceApp"
    if page_name.empty?
        base_title
    else
        page_name + " | " + base_title
    end
  end
  
  def week_color(date)
    displaying_label = %w(日 月 火 水 木 金 土)[DateTime.now.wday]
    if DateTime.now.wday == "土"
      tag.span(displaying_label, class: 'saturday')
    elsif DateTime.now.wday == "日"
      tag.span(displaying_label, class: 'sunday')
    else
      displaying_label
    end
  end
end
