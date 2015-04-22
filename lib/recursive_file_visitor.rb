require('fileutils')
require('find')

class RecursiveFileVisitor

  def visit(filter, &block)

    # build the path
    fullPathFilter = File.join(FileUtils.pwd(), "..")

    # load the ignore array if needed
    ignoreFilter = []
    ignoreFile = File.join(FileUtils.pwd(), ".xctignore")
    if (FileTest.exist?(ignoreFile))
      ignoreFilter = File.readlines(ignoreFile)
      ignoreFilter = ignoreFilter.map{ |ie|
        ie.chop
      }
      p "Ignore list is set to: #{ignoreFilter}"
    end

    Find.find(fullPathFilter) do |path|

      # Check if the file is part of the filter
      if FileTest.directory?(path) || !path.end_with?(filter)
        next
      end

      # check if
      ignoreFile = false
      ignoreFilter.each do |ignoreFilterElement|
        if (path.include?(ignoreFilterElement))
          ignoreFile = true
        end
      end

      if (ignoreFile)
        next
      end

      block.call(path)
    end
  end
end