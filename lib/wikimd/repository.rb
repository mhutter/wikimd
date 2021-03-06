require 'open3'
require 'pathname'
require 'shellwords'

require 'wikimd/error'

module WikiMD
  # Handles reading and writing of files in the repo. Also interacts with GIT.
  class Repository
    # Raised, if a file or directory cannot be found, or is outside the repo.
    class FileNotFound < WikiMD::Error; end
    class GitError < WikiMD::Error; end

    attr_reader :path

    def initialize(path)
      @path = Pathname(path).realpath
      @path.mkpath
    end

    # Reads a file from the repository. +path+ will have its leading slashes
    # removed and must be within the repository path.
    #
    # @param path [String,Pathname] path to the file to be read
    # @return [String] the content of +file+
    # @raise [FileNotFound] if +file+ doesn't exist within the repo or is a dir
    def read(path, rev=nil)
      if rev.nil?
        file = pathname(path)
        return file.read
      else
        git :show, %(#{rev}:"./#{path.shellescape}")
      end
    rescue
      raise FileNotFound, "no such file in repo - #{path}"
    end

    def history(path)
      params = %(--pretty='format:%h;%cr;%s' --no-decorate --no-color -z)
      out = git :log, "#{params} -- #{path.shellescape}"
      out.split("\x0").map do |e|
        h, d, m = e.split(';', 3)
        {
          hash: h,
          date: d,
          message: m
        }
      end
    end

    # List all directories in +path+.
    #
    # @param path [String,Pathname] path to the directory within the repo
    # @return [Array] an array of directory names
    def list_dirs(path)
      dir = pathname(path)

      Dir.chdir(dir) do
        Dir['*/'].sort
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
        Dir['*'].select { |n| File.file?(n) }.sort
      end

    rescue
      raise FileNotFound, "no such file in repo - #{path}"
    end

    # return an array of all files
    def files(root = '')
      files = []
      dir = @path.join(root)
      Dir.chdir(dir) do
        files = Dir.glob('**/*').select { |p| dir.join(p).file? }
      end
    end

    # return a hash containing all dirs and files
    def tree(root = '')
      build_hash(files(root), root)
    end

    def diff(path, old, new)
      path = pathname(path)
      raw_diff = git :diff, "-p --no-color #{old} #{new} -- #{path.to_s.shellescape}"
      diff = []
      raw_diff.each_line do |line|
        next if line =~ /^(diff|index|\+\+\+|---)/
        case line[0]
        when '@'
          parts = line.chomp.split('@@')
          diff << {
            start: parts[1].gsub(/^\s|\s$/, ''),
            lines: [(parts[2])].compact
          }
        else
          diff.last[:lines] << line.chomp
        end
      end
      diff
    end

    # Updates the given file with `content`. The file must be present!
    #
    # @param path [String] absolute path of file to update.
    # @param content [String] the new file content
    # @raise [FileNotFound] if +file+ doesn't exist within the repo or is a dir
    def update(path, content)
      file = pathname(path)

      # fail if path is a dir or similar
      fail FileNotFound unless file.file?

      # get rid of CRLFs
      content.gsub!(/\r\n?/, "\n")

      # don't do anything if the contents are identical
      return if file.read == content

      # write, add, commit
      file.write(content)
      git :add, path.shellescape
      git :commit, "-m 'update #{path}' -- #{path.shellescape}"
    end

    private

    def git(cmd, arg)
      command = "git #{cmd.to_s} #{arg}"
      out, err, stat = nil
      Dir.chdir(@path) do
        out, err, stat = Open3.capture3(command)
      end
      fail GitError, "Error running `#{command}` - #{err}" unless stat.success?
      out
    end

    # convert an array of absolute path names into a hash.
    def build_hash(files, root)
      tree = {}
      files.each do |path|
        build_tree(tree, path.split(File::SEPARATOR), root)
      end
      tree
    end

    # add an array of path parts to the +tree+
    def build_tree(tree, parts, path)
      path += '/' unless path.empty? || path.end_with?('/')
      parts[0...-1].each do |p|
        path += "#{p}/"
        tree[p] ||= { type: :directory, path: path, sub: {} }
        tree = tree[p][:sub]
      end
      fname = parts[-1]
      tree[fname] = { type: :text, path: path + fname }
    end

    def pathname(path)
      # calling `realpath` does several things for us:
      # - returns an absolute pathname
      # - ... which does not contain any useless dots (., ..)
      # - and checks that the file actually exists.
      file = @path.join(path.sub(%r{\A/+}, '')).realpath
      fail unless file.to_s.start_with?(@path.to_s)
      file
    rescue
      raise FileNotFound, "no such file or directory in repo - #{path}"
    end
  end
end
