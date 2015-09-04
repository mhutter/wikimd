require 'pathname'

require 'wikimd/error'

module WikiMD
  # Handles reading and writing of files in the repo. Also interacts with GIT.
  class Repository
    # Raised, if a file or directory cannot be found, or is outside the repo.
    class FileNotFound < WikiMD::Error; end

    attr_reader :path

    def initialize(path)
      @path = Pathname(path)
      @path.mkpath
    end

    def dir?(path)
      pathname(path).directory?
    end

    # Reads a file from the repository. +path+ will have its leading slashes
    # removed and must be within the repository path.
    #
    # @param path [String,Pathname] path to the file to be read
    # @return [String] the content of +file+
    # @raise [FileNotFound] if +file+ doesn't exist within the repo or is a dir
    def read(path)
      file = pathname(path)

      fail unless within_repo?(file)

      file.open.read
    rescue
      raise FileNotFound, "no such file in repo - #{path}"
    end

    # List all directories in +path+.
    #
    # @param path [String,Pathname] path to the directory within the repo
    # @return [Array] an array of directory names
    def list_dirs(path)
      dir = pathname(path)

      Dir.chdir(dir) do
        Dir['*/']
      end

    rescue
      raise FileNotFound, "no such file in repo - #{path}"
    end

    # List all files in +path+.
    #
    # @param path [String,Pathname] path to the directory within the repo
    # @return [Array] an array of file names
    def list_files(path)
      dir = pathname(path)

      Dir.chdir(dir) do
        Dir['*'].select { |n| File.file?(n) }
      end

    rescue
      raise FileNotFound, "no such file in repo - #{path}"
    end

    # return a hash containing all dirs and files
    def tree
      files = []
      Dir.chdir(@path) do
        files = Dir.glob('**/*').select { |p| @path.join(p).file? }
      end

      build_hash(files)
    end

    # @param path [#to_s] path to check
    # @return [Boolean] +true+, if +path+ is within the repo
    def within_repo?(path)
      path.to_s.start_with?(@path.to_s)
    end

    private

    # convert an array of absolute path names into a hash.
    def build_hash(files)
      tree = {}
      files.each do |path|
        parts = path.split(File::SEPARATOR)
        h = tree
        parts[0...-1].each { |p| h = h[p] ||= {} }
        (h['.'] ||= []) << parts[-1]
      end
      tree
    end

    def pathname(path)
      # calling `realpath` does several things for us:
      # - returns an absolute pathname
      # - ... which does not contain any useless dots (., ..)
      # - and checks that the file actually exists.
      @path.join(path.sub(%r{\A/+}, '')).realpath
    rescue
      raise FileNotFound, "no such file or directory in repo - #{path}"
    end
  end
end
