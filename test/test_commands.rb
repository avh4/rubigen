require File.join(File.dirname(__FILE__), "test_helper.rb")
require 'rubigen/commands'

class TestCommandsGenerator < Test::Unit::TestCase
  
  TMP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..", "tmp"))
  SOURCE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "files"))
  
  def setup
    FileUtils.mkdir_p(TMP_ROOT)
    
    # Set up the mock logger
    @mock_logger = mock("logger")
    @mock_logger.stubs(:skip)
    @mock_logger.stubs(:create)
    @mock_logger.stubs(:identical)
    
    # Set up the mock generator
    @mock_generator = mock("generator")
    def @mock_generator.source_path(path)
      File.expand_path(File.join(SOURCE_ROOT, path))
    end
    def @mock_generator.destination_path(path)
      File.expand_path(File.join(TMP_ROOT, path))
    end
    @mock_generator.stubs(:options).returns({:collision => :skip})
    @mock_generator.stubs(:logger).returns(@mock_logger)
    
    # Get an instance of the Commands object
    @command = RubiGen::Commands.instance("create", @mock_generator)
  end
  
  def teardown
    FileUtils.rm_rf TMP_ROOT
  end
  
  def test_file_command
    @command.file "file1.txt", "file1.txt"
    assert File.exist?(tmp_file("file1.txt"))
  end
  
  def test_file_command_with_symlink
    @command.file "symlink_to_file1.txt", "symlink_to_file1.txt"
    assert File.symlink?(tmp_file("symlink_to_file1.txt"))
    assert_equal "file1.txt", File.readlink(tmp_file("symlink_to_file1.txt"))
  end
  
  def test_directory_command
    @command.directory "folderX"
    assert File.exist?(tmp_file("folderX"))
    assert File.directory?(tmp_file("folderX"))
  end
  
  private
  def tmp_file(path)
    File.join(TMP_ROOT, path)
  end
end