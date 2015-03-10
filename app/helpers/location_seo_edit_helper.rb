module LocationSeoEditHelper
  def number_of_widgets(row_layout)
    if row_layout=="single" || row_layout=="one"
      return 1
    elsif row_layout=="halves" ||
        row_layout=="uneven-thirds-1" ||
        row_layout=="uneven-thirds-2" || row_layout=="two"
      return 2
    elsif row_layout=="thirds" || row_layout=="three"
      return 3
    elsif row_layout=="quarters" || row_layout=="four"
      return 4
    elsif row_layout=="five"
      return 5
    elsif row_layout=="six"
      return 6
    else
      return -1
    end
  end

  def get_val(object, setting)
    object.settings.where({name: setting}).first.value
  end

end
