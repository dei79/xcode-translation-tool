class TranslationManagerUpdate

  def perform(targetLanguage)

    # Visit every *.strings file
    fileVisitor = RecursiveFileVisitor.new()
    fileVisitor.visit(".strings;.storyboard") do |fullFileName|
     p fullFileName
    end
  end
end