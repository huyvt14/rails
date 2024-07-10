class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @pagy, @feed_items = pagy(current_user.feed, items: 10)
    end
  end


  def help
    # Đây là phương thức help, không có nội dung cụ thể cần định dạng lại.
  end

  def about
    # Đây là phương thức about, không có nội dung cụ thể cần định dạng lại.
  end

  def contact
    # Đây là phương thức contact, không có nội dung cụ thể cần định dạng lại.
  end
end
