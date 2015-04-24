require('fileutils')
require('find')

require __FILE__ + '/../ignore_file'
require __FILE__ + '/../element_filter'

class RecursiveFileVisitor

  def visit(filter, &block)

    # build the path
    fullPathFilter = File.join(FileUtils.pwd(), "..")

    # load the ignore array if needed
    ignoreFile = IgnoreFile.new(File.join(FileUtils.pwd(), ".xctignore"))

    # prepare our filter
    elementFilter = ElementFilter.new(filter)

    # find the files
    Find.find(fullPathFilter) do |path|

      # Check if the file is part of the filter
      next if FileTest.directory?(path) || elementFilter.needToIgnore(path)

      # check if
      next if ignoreFile.needToIgnore(path)

      # call our visitor block
      block.call(path)
    end
  end
end