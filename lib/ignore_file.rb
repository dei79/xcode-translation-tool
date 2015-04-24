class IgnoreFile

  # Initializes the ignore files
  def initialize(filename)

    @ignoreElements =[]

    if (FileTest.exist?(filename))
      @ignoreElements = File.readlines(filename)
      @ignoreElements = @ignoreElements.map{ |ie|
        ie.chop
      }
    end
  end

  def needToIgnore(filename)

    @ignoreElements.each do |ignoreFilterElement|
      if (filename.include?(ignoreFilterElement))
        return true
      end
    end

    return false
  end
end