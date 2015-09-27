require 'pathname'
require 'wikimd/repository'

RSpec.describe WikiMD::Repository do
  let(:repo) { ::WikiMD::Repository.new(repo_path.to_s) }
  let(:repo_path) { Pathname(FIXTURE_REPO_PATH) }
  let(:success) { double('thread', success?: true) }

  describe '#read' do
    it 'reads the files contents' do
      expected = repo_path.join('file').read
      expect(repo.read('file')).to eq expected
      expect(repo.read('/file')).to eq expected
    end

    it 'calls git to read a specific revision' do
      expect(Open3).to receive(:capture3).with('git show bada55:"./file"') {
        ['', '', success]
      }
      repo.read('file', 'bada55')
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
      init_tmp_repo

      # create a testfile outside repo_path
      file = Pathname(TMP_REPO_PATH).join('file')
      file.write 'fail'

      expect {
        repo.read(file.to_s)
      }.to raise_error(WikiMD::Repository::FileNotFound)

      # construct a relative path to file
      file = file.relative_path_from(repo_path).to_s
      expect {
        repo.read(file)
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end
  end

  describe '#history' do
    it 'returns the history' do
      cmd = %(git log --pretty='format:%h;%cr;%s' --no-decorate --no-color -z -- mah\\ file)
      expect(Open3).to receive(:capture3).with(cmd) {
        ["50ed2fb;17 hours ago;packaging\x00683472c;4 weeks ago;wip", '', success]
      }

      hist = repo.history('mah file')
      expect(hist.length).to eq 2
      expect(hist).to eq [{
          hash: '50ed2fb', date: '17 hours ago', message: 'packaging'
        }, {
          hash: '683472c', date: '4 weeks ago', message: 'wip'
        }
      ]
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
      init_tmp_repo
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
      let(:repo_path) { TMP_REPO_PATH }
      before { init_tmp_repo }

      it 'returns an empty hash' do
        expect(repo.tree).to eq({})
      end
    end

    it 'returns the tree' do
      expected = {
        'file' => { type: :text, path: 'file' },
        'index.md' => { type: :text, path: 'index.md' },
        'syntax.md' => { type: :text, path: 'syntax.md' },
        'list' => {
          type: :directory,
          path: 'list/',
          sub: {
            'fileA' => { type: :text, path: 'list/fileA' },
            'fileB' => { type: :text, path: 'list/fileB' },
            'fileC' => { type: :text, path: 'list/fileC' }
          }
        }
      }
      expect(repo.tree).to eq expected
    end

    it 'returns tree from directory' do
      expected = {
        'fileA' => { type: :text, path: 'list/fileA' },
        'fileB' => { type: :text, path: 'list/fileB' },
        'fileC' => { type: :text, path: 'list/fileC' }
      }
      expect(repo.tree('list')).to eq expected
    end
  end
end
