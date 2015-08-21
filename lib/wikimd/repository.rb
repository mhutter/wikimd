require 'pathname'

require 'wikimd/error'

module WikiMD
  # Handles reading and writing of files in the repo. Also interacts with GIT.
  class Repository
    class Error < WikiMD::Error; end
    class FileNotFound < Error; end

    def initialize(path)
      @repo = Pathname(path)
      @repo.mkpath
    end

    def read(path)
      file = @repo.join(path)
      fail FileNotFound, "no such file in repo - #{path}" unless file.file?
      file.open.read
    end
  end
end
