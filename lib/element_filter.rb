class ElementFilter

  # Initializes the ignore files
  def initialize(filter)
    @filterElements = filter.split(';')
  end

  def needToIgnore(filename)

    ignoreElement = true

    @filterElements.each do |includeFilterElement|
      if (filename.end_with?(includeFilterElement))
        return false
      end
    end

    return true
  end
end