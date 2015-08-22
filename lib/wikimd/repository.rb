require 'pathname'

require 'wikimd/error'

module WikiMD
  # Handles reading and writing of files in the repo. Also interacts with GIT.
  class Repository
    # Error indicating that the requestet file either
    # - does not exist
    # - is a folder
    # - is a hidden file (= basename starts with a '.')
    class FileNotFound < WikiMD::Error; end

    attr_reader :path

    def initialize(path)
      @path = Pathname(path)
      @path.mkpath
    end

    # Reads a file from the repository. +path+ will have its leading slashes
    # removed and must be within the repository path.
    #
    # @param path [String,Pathname] path to the file to be read
    # @return [String] the content of +file+
    # @raise [FileNotFound] if +file+ doesn't exist, is a folder, or is hidden.
    def read(path)
      file = @path.join(path.sub(%r{\A/+}, ''))

      fail if file.basename.to_s.start_with?('.') # file hidden
      fail unless within_repo?(file) # file outside repo
      fail unless file.file? # file does not exist or is a directory

      file.open.read
    rescue
      raise FileNotFound, "no such file in repo - #{path}"
    end

    def within_repo?(path)
      path.to_s.start_with?(@path.to_s)
    end
  end
end
