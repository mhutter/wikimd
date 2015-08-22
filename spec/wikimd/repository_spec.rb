require 'pathname'
require 'wikimd/repository'

RSpec.describe WikiMD::Repository do
  let(:repo) { WikiMD::Repository.new(repo_path.to_s) }
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
      expect(repo.path).to eq repo_path
      expect(repo.read('file')).to eq 'content!'
    end

    it 'raises if the file does not exist' do
      expect {
        repo.read('does/not/exist.txt')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'raises if the provided path is a directory' do
      expect {
        repo.read('folder')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'raises if attempting to read a hidden file' do
      expect {
        repo.read('folder/.keep')
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end

    it 'can not read stuff outside the repo path' do
      file = Pathname(TMP_REPO_PATH).join('file')
      file.open('w') { |f| f.write 'fail' }
      expect {
        repo.read(file)
      }.to raise_error(WikiMD::Repository::FileNotFound)
    end
  end
end
