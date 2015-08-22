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

    def read(path)
      file = @path.join(path)
      if file.basename.to_s.start_with?('.') || !file.file?
        # file is either hidden or not a file.
        fail FileNotFound, "no such file in repo - #{path}"
      end
      file.open.read
    end
  end
end
