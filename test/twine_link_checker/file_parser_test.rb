# frozen_string_literal: true

require 'test_helper'

describe TwineLinkChecker::VERSION do
  it 'has a version number' do
    refute_nil TwineLinkChecker::VERSION
  end
end
TESTFILE_CONTENT = <<~'TESTURLS'
  jpgjpgpngmeow
  random;url.jpg;stuff;url.jpg
  [[./abc.gif]]
  /longer\\filename.webm20349
  ./garçon/ಠ_ಠ.png
TESTURLS

describe TwineLinkChecker::FileParser do
  let(:fp) { TwineLinkChecker::FileParser }

  let(:tempfile) do
    Tempfile.new.tap do |f|
      f.write(TESTFILE_CONTENT)
      f.rewind
      f.extend(fp)
    end
  end
  it 'finds paths' do
    expected = [
      'url.jpg',
      'url.jpg',
      './abc.gif',
      '/longer/filename.webm',
      './garçon/ಠ_ಠ.png'
    ]
    results = tempfile.each_path.to_a
    assert_equal(expected, results)
  end

  it 'finds missing paths' do
    Tempfile.create(['url', '.jpg']) do |f|
      Dir.chdir(File.dirname(File.expand_path(f))) do
        tempfile.read
        tempfile.<< "\n./" + File.basename(f)
        results = tempfile.missing_paths
        expected = [
          'url.jpg',
          './abc.gif',
          '/longer/filename.webm',
          './garçon/ಠ_ಠ.png'
        ]
        assert_equal(expected, results)
      end
    end
  end
  it 'finds real paths' do
    in_tmpdir do |dir|
      f1 = Tempfile.new(['path', '.jpg'], dir)
      nested = Dir.mktmpdir('images', dir)
      f2 = Tempfile.new(['nested', '.webm'], nested)

      f1path, f2path = [f1, f2].map do |f|
        Pathname.new(File.expand_path(f)).relative_path_from(dir).to_s
      end
      tempfile = Tempfile.new(['file', '.html'], dir)
      tempfile.write(TESTFILE_CONTENT)
      tempfile.extend(fp)
      [f1path, f2path].each do |p|
        tempfile << p.upcase
      end
      results = tempfile.real_paths
      expected = [
        ['url.jpg', nil],
        ['./abc.gif', nil],
        ['/longer/filename.webm', nil],
        ['./garçon/ಠ_ಠ.png', nil],
        [f1path.upcase, f1path],
        [f2path.upcase, f2path]
      ]
      assert_equal(expected, results)
    end
  end

  it 'fixes bad paths' do
    in_tmpdir do |dir|
      f1 = Tempfile.new(['path', '.jpg'], dir)
      nested = Dir.mktmpdir('images', dir)
      f2 = Tempfile.new(['nested', '.webm'], nested)

      f1path, f2path = [f1, f2].map do |f|
        Pathname.new(File.expand_path(f)).relative_path_from(dir).to_s
      end
      tempfile = Tempfile.new(['file', '.html'], dir)
      tempfile.write(TESTFILE_CONTENT)
      tempfile.extend(fp)
      [f1path, f2path].each do |p|
        tempfile << p.upcase
      end
      Tempfile.create(['new', '.html'], dir) do |new_file|
        new_file.write(tempfile.fix_paths)
        results = new_file.extend(fp).missing_paths
        expected = [
          'url.jpg',
          './abc.gif',
          '/longer/filename.webm',
          './garçon/ಠ_ಠ.png'
        ]
        assert_equal(expected, results)
      end
    end
  end
end
