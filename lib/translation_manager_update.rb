require 'xcodeproj'
require 'nokogiri'
require 'apfel'

class TranslationManagerUpdate

  def perform(projectFile, targetLanguage)

    # open the project
    project = Xcodeproj::Project.open(projectFile);

    # get the development region
    development_region = project.root_object.development_region

    # adapt the region to two letter code
    development_region = 'de' if development_region.eql?('German')
    development_region = 'en' if development_region.eql?('English')

    # get all storyboards from the base localisation
    project.files.each do |fileObject|
      if fileObject.path.include?('Base.lproj') && fileObject.path.end_with?('.storyboard')
        p "Reading storyboard: #{fileObject.real_path}"

        # read the storyboard file and find all XML tags which are having a property
        storyboardXML = Nokogiri::XML(File.open(fileObject.real_path)) do |config|
          config.strict.nonet
        end

        #
        # text
        # title
        #
        translationElements = {};


        storyboardXML.xpath("//*[@id]").each do |element|

          # label --> text --> text
          # button --> child:title --> normalTitle
              # state key="normal" title="Setup beenden"
              # state key="highlighted" title=""
          # textField --> placeholder --> .placeholder

          case element.name
            when "label"
              next unless element.attributes['text'] && element.attributes['text'].value.length != 0
              translationElements["#{element.attributes['id'].value}.text"] = element.attributes['text'].value
            when "button"
              element.xpath("state").each do |stateElement|
                next unless stateElement.attributes['title']
                translationElements["#{element.attributes['id'].value}.#{stateElement.attributes['key'].value}Title"] = stateElement.attributes['title'].value
              end
            when "textField"
              next unless element.attributes['placeholder']
              translationElements["#{element.attributes['id'].value}.placeholder"] = element.attributes['placeholder'].value
            else
              next
          end
        end

        p "#{translationElements.length} items found in storyboards"

        #
        # Read the associated strings file
        #
        filename = File.basename( fileObject.real_path, ".*" )
        stringsFileName = File.expand_path("#{fileObject.real_path}/../../#{targetLanguage}.lproj/#{filename}.strings", "/")

        # p "StringsFile is: #{stringsFileName}"
        parsed_file = Apfel.parse(stringsFileName)

        #
        # Compare the keys to find the missing ones
        #
        parsed_file.keys.each do |existingKey|
          translationElements = translationElements.dup.except(existingKey)
        end

        p "#{translationElements.length} elements missing in associated strings file"

        #
        # Generate the associated strings file
        #
        File.open(stringsFileName, 'a') do |file|
          translationElements.each do |key, value|
            p "Addding #{key} to strings (#{value})"
            file.puts ""
            file.puts ""
            file.puts "/* Class = \"????\"; text = \"#{value}\"; ObjectID = \"#{key.split('.')[0]}\"; */"
            file.puts "\"#{key}\" = \"NEW: #{value}\";";
          end
        end
      end
    end

    # get all strings in base language from projects
    project.files.each do |fileObject|
      if fileObject.path.include?("#{development_region}.lproj") && fileObject.path.end_with?('.strings')

        # read the original file
        originalStringsParsed = Apfel.parse(fileObject.real_path)
        originalStringsParsed = originalStringsParsed.to_hash(with_comments: false)
        p "#{originalStringsParsed.keys.length} elements in original strings file"

        # read the target file
        filename = File.basename(fileObject.real_path, ".*" )
        targetStrings = File.expand_path("#{fileObject.real_path}/../../#{targetLanguage}.lproj/#{filename}.strings", "/")
        targetStringsParsed = Apfel.parse(targetStrings)

        # check which entries are mossing
        targetStringsParsed.keys.each do |existingKey|
          originalStringsParsed = originalStringsParsed.dup.except(existingKey)
        end

        p "#{originalStringsParsed.length} elements missing in associated strings file"

        # write the missing strings
        File.open(targetStrings, 'a') do |file|
          originalStringsParsed.each do |key, value|
            p "Addding #{key} to strings (#{value})"
            file.puts ""
            file.puts "\"#{key}\" = \"NEW: #{value}\";";
          end
        end
      end
    end

  end
end