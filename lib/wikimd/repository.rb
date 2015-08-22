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

    # Reads a file from the repository. +path+ will have its leading slashes
    # removed and must be within the repository path.
    #
    # @param path [String,Pathname] path to the file to be read
    # @return [String] the content of +file+
    # @raise [FileNotFound] if +file+ doesn't exist within the repo or is a dir
    def read(path)
      # calling `realpath` does several things for us:
      # - returns an absolute pathname
      # - ... which does not contain any useless dots (., ..)
      # - and checks that the file actually exists.
      file = @path.join(path.sub(%r{\A/+}, '')).realpath

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
      # calling `realpath` does several things for us:
      # - returns an absolute pathname
      # - ... which does not contain any useless dots (., ..)
      # - and checks that the file actually exists.
      dir = @path.join(path.sub(%r{\A/+}, '')).realpath

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
      # calling `realpath` does several things for us:
      # - returns an absolute pathname
      # - ... which does not contain any useless dots (., ..)
      # - and checks that the file actually exists.
      dir = @path.join(path.sub(%r{\A/+}, '')).realpath

      Dir.chdir(dir) do
        Dir['*'].select { |n| File.file?(n) }
      end

    rescue
      raise FileNotFound, "no such file in repo - #{path}"
    end

    # @param path [#to_s] path to check
    # @return [Boolean] +true+, if +path+ is within the repo
    def within_repo?(path)
      path.to_s.start_with?(@path.to_s)
    end
  end
end
