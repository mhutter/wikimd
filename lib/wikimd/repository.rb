require 'pathname'

require 'wikimd/error'

module WikiMD
  # Handles reading and writing of files in the repo. Also interacts with GIT.
  class Repository
    class FileNotFound < WikiMD::Error; end

    attr_reader :path

    def initialize(path)
      @path = Pathname(path)
      @path.mkpath
    end

    # Reads a
    def read(path)
      file = @path.join(path)

      fail if file.basename.to_s.start_with?('.') # file hidden
      fail unless within_repo?(file) # file outside repo
      fail unless file.file? # file does not exist or is a directory

      file.open.read
    rescue
      fail FileNotFound, "no such file in repo - #{path}"
    end

    def within_repo?(path)
      path.to_s.start_with?(@path.to_s)
    end
  end
end
