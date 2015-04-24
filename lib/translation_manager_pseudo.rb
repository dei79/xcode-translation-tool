class TranslationManagerPseudo

  def applyPseudoTranslationInLine(line, targetLanguage)
    # check if we have a valid value
    stringsEntry = line
    if (stringsEntry.length != 0 && stringsEntry != "\n" && !stringsEntry.start_with?('/*'))

      # split the strings entry by '='
      rightValue = stringsEntry.split("=")
      if (rightValue.length != 2)
        nil
        return
      else
        rightValue = rightValue[1]
      end


      # remove line break if needed
      rightValue.chop!()

      # remove the trailing ;
      rightValue.chomp!(';')

      # remove the leading spaces (trimming)
      rightValue.strip!()

      # remove the quotes
      rightValue = rightValue[1..rightValue.length - 2]

      # check if the right value not starts with the translation prefix
      if (!rightValue.start_with?(targetLanguage.upcase + ':'))

        # generate the replacement mark but only when not prefixed before
        valueToReplace = targetLanguage.upcase + ':' + rightValue

        # replace this value
        # stringsEntry = stringsEntry.replace(rightValue, valueToReplace)
        stringsEntry = stringsEntry.gsub(rightValue, valueToReplace)
      end

      stringsEntry
    else
      line
    end
  end

  def perform(targetLanguage)

    # define the lang directory
    targetLanguageDirectory = targetLanguage + ".lproj"

    # Visit every *.strings file
    fileVisitor = RecursiveFileVisitor.new()
    fileVisitor.visit(".strings") do |fullFileName|

      # check if we are part of the target language
      next if (!fullFileName.include?(targetLanguageDirectory))

      # check if we can ignore file
      next if (fullFileName.include?("Pods") || fullFileName.include?("vendor") || fullFileName.include?("external"))

      # line number
      lineNumber = 0

      # read the content & add the prefix to every value
      p "Patching contents file: " + fullFileName
      stringsContent = File.readlines(fullFileName)

      # open the file for writing
      targetFile = File.new(fullFileName, 'w')

      # visit every line
      stringsContent.each do |stringsEntry|

        lineNumber = lineNumber + 1

        begin
          stringsEntry = applyPseudoTranslationInLine(stringsEntry, targetLanguage)
        rescue
          p "ERROR: #{fullFileName} (Line: #{lineNumber}) - ignoring"
        end

        targetFile.write(stringsEntry)
      end

      targetFile.close
    end
  end
end