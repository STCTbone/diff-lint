module DiffLint
  class StatusReader
    def initialize(logger = DiffLint::NullLogger.new)
      @changed_files = []
      @logger = logger
    end
    def changed_files
      @changed_files
    end

    def read_changes
      git_obj = Git.open(Dir.pwd, log: @logger).status
      git_obj.changed.each do |file|
        add_file(file)
      end
      git_obj.untracked.each do |file|
        add_file(file)
      end
    end

    private

    def add_file(file)
      @changed_files << file.path
    end
  end

  class NullLogger
    def debug(*) end
    def info(*) end
    def warn(*) end
    def error(*) end
    def fatal(*) end
  end

end