require 'pathname'
require 'wikimd/repository'

RSpec.describe WikiMD::Repository do
  let(:repo) { ::WikiMD::Repository.new(repo_path.to_s) }
  let(:repo_path) { Pathname(FIXTURE_REPO_PATH) }

  describe '.new' do
    let(:repo_path) { Pathname(TMP_REPO_PATH) }
    before(:each) { repo_path.rmtree if repo_path.exist? }

    it 'creates the repository path if necessary' do
      repo
      expect(repo_path).to be_directory
    end
  end #.new

  describe '#read' do
    it 'reads the files contents' do
      expect(repo.read('file')).to eq 'content!'
      expect(repo.read('/file')).to eq 'content!'
    end

    it 'raises if the file does not exist' do
      expect {
        repo.read('does/not/exist.txt')
      }.to raise_error WikiMD::Repository::FileNotFound,
                       'no such file in repo - does/not/exist.txt'
    end

    it 'raises if the provided path is a directory' do
      expect {
        repo.read('folder')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'cannot read stuff outside the repo path' do
      rm_tmp_repo
      Pathname(TMP_REPO_PATH).mkpath
      # create a testfile outside repo_path
      file = Pathname(TMP_REPO_PATH).join('file')
      file.open('w') { |f| f.write 'fail' }

      expect {
        repo.read(file)
      }.to raise_error(WikiMD::Repository::FileNotFound)

      # construct a relative path to file
      file = file.relative_path_from(repo_path).to_s
      expect {
        repo.read(file)
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end
  end

  describe '#list_dirs' do
    it 'returns an array of folder names' do
      expect(repo.list_dirs('list/')).to eq %w(folderA/ folderB/ folderC/)
      expect(repo.list_dirs('list')).to eq %w(folderA/ folderB/ folderC/)
    end

    it 'does not include hidden directories' do
      expect(repo.list_dirs('list/')).to_not include('.hidden')
      expect(repo.list_dirs('list/')).to_not include('.hidden_file')
    end

    it 'returns an empty array for empty directories' do
      expect(repo.list_dirs('empty')).to eq []
      expect(repo.list_dirs('empty/')).to eq []
    end

    it 'does not modify the working dir' do
      repo.list_dirs('list/')
      expect(Dir.pwd).to eq ORIGINAL_PWD
    end

    it 'raises if the dir does not exist' do
      expect {
        repo.list_dirs('does/not/exist')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'raises if the dir is a file' do
      expect {
        repo.list_dirs('file')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'cannot read stuff outside the repo path' do
      Pathname(TMP_REPO_PATH).rmtree
      # create a directory
      dir = Pathname(TMP_REPO_PATH).join('dir')
      dir.mkpath

      expect {
        repo.list_dirs(dir)
      }.to raise_error(WikiMD::Repository::FileNotFound)

      # construct a relative path to dir
      dir = dir.relative_path_from(repo_path)
      expect {
        repo.read(dir)
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end
  end

  describe '#list_files' do
    it 'returns an array of file names' do
      expect(repo.list_files('list/')).to eq %w(fileA fileB fileC)
      expect(repo.list_files('list')).to eq %w(fileA fileB fileC)
    end

    it 'does not include hidden files' do
      expect(repo.list_files('list/')).to_not include('.hidden')
      expect(repo.list_files('list/')).to_not include('.hidden_file')
    end

    it 'returns an empty array for empty directories' do
      expect(repo.list_files('empty')).to eq []
      expect(repo.list_files('empty/')).to eq []
    end


    it 'does not modify the working dir' do
      repo.list_files('list/')
      expect(Dir.pwd).to eq ORIGINAL_PWD
    end

    it 'raises if the dir does not exist' do
      expect {
        repo.list_files('does/not/exist')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'raises if the dir is a file' do
      expect {
        repo.list_files('file')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'cannot read stuff outside the repo path' do
      rm_tmp_repo
      # create a directory
      dir = Pathname(TMP_REPO_PATH).join('dir')
      dir.mkpath

      expect {
        repo.list_files(dir)
      }.to raise_error(WikiMD::Repository::FileNotFound)

      # construct a relative path to dir
      dir = dir.relative_path_from(repo_path)
      expect {
        repo.read(dir)
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end
  end # list_files

  describe '#tree' do
    describe 'empty repo' do
      let(:repo_path) { Pathname(TMP_REPO_PATH) }
      it 'returns an empty hash' do
        rm_tmp_repo
        expect(repo.tree).to eq({})
      end
    end

    it 'returns the tree' do
      expected = {
        '.' => %w(file syntax.md),
        'list' => {
          '.' => %w{fileA fileB fileC}
        }
      }
      expect(repo.tree).to eq expected
    end
  end
end
