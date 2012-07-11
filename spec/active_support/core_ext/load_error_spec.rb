describe MissingSourceFile do
  describe 'REGEXPS' do
    it { MissingSourceFile::REGEXPS.should include([/^cannot load such file -- (.+)$/i, 1]) }
  end
end
