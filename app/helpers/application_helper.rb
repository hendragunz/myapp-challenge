module ApplicationHelper

  def flash_klass(flash_key)
    case flash_key
      when 'success'  then "green"
      when 'notice'   then "blue"
      when 'error'    then "red"
      when 'warning'  then "red"
    end
  end

end
