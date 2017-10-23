##
# Import a list of rows from a textfile

class ListFile
  ##
  # Loads a text file and returns an array. Each line in the file will be an element in the array.
  #
  # ==== Attributes
  #
  # * +:file_name+ - The filepath of the file to be uploaded.
  def self.import(file_name)
    File.open(file_name).read.split("\n")
  end

  ##
  # Exports an array of string elements to a file
  #
  # ==== Attributes
  #
  # * +:rows+ - An array of strings to be exported to a file.
  # * +:filename+ - The name of the file to be created and/or written to
  #
  # ==== Examples
  #
  # ListFile.export(['foo', 'bar'], 'baz.txt') #=> nil
  def self.export(rows, filename)
    File.write(filename, rows.join("\n"))
  end
end
