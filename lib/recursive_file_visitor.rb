require('fileutils')
require('find')

require __FILE__ + '/../ignore_file'

class RecursiveFileVisitor

  def visit(filter, &block)

    # build the path
    fullPathFilter = File.join(FileUtils.pwd(), "..")

    # load the ignore array if needed
    ignoreFile = IgnoreFile.new(File.join(FileUtils.pwd(), ".xctignore"))

    # find the files
    Find.find(fullPathFilter) do |path|

      # Check if the file is part of the filter
      next if FileTest.directory?(path) || !path.end_with?(filter)

      # check if
      next if ignoreFile.needToIgnore(path)

      # call our visitor block
      block.call(path)
    end
  end
end