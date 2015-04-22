#!/usr/bin/env ruby
#
# This script implements some simplicity tools for base translation support in Apple XCode. Currently
# the script supports the following features:
#
# * Generate a pseudo translation in a defined target language
#

require 'optparse'
require __FILE__ + '/../../lib/recursive_file_visitor'
require __FILE__ + '/../../lib/pseudo_translation_manager'

# Handle command line parameters
options = {}
optparser = OptionParser.new do |opts|
  opts.banner = "Usage: xt-tool [options]"

  opts.on('-p', '--pseudo TARGETLANGUAGE', 'Creates a pseudo translation in target langauge') { |v| options[:action] = :pseudo; options[:target] = v }
end
optparser.parse!

case options[:action]

  when :pseudo
    # generate the target language indicator
    targetLanguage = options[:target].downcase

    # start the translation
    translationManager = PseudoTranslationManager.new()
    translationManager.performPseudoTranslation(targetLanguage);
  else
    p "Ups"
end

p options