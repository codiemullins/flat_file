require 'flat_file/version'
require 'flat_file/flat_file'
require 'flat_file/definition'
require 'flat_file/section'
require 'flat_file/column'
require 'flat_file/parser'
require 'flat_file/generator'

module FlatFile
  class ParserError < RuntimeError; end
  class DuplicateColumnNameError < StandardError; end
  class DuplicateGroupNameError < StandardError; end
  class DuplicateSectionNameError < StandardError; end
  class RequiredSectionNotFoundError < StandardError; end
  class RequiredSectionEmptyError < StandardError; end
  class FormattedStringExceedsLengthError < StandardError; end
  class ColumnMismatchError < StandardError; end
end
