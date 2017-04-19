module ApplicationHelper
  def flash_key(key)
    case key
      when :notice, 'notice'
        :info
      when :alert, 'alert'
        :warning
      else
        key
    end
  end
end
