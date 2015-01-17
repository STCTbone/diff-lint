module DiffLint
  class LintManager
    def initialize(changes=[])
      @changes = changes
    end

    def lint_changes
      @changes.each do |change|
        lint_factory.call change
      end
    end

    private

    def lint_factory
      DiffLint::FileMatcher.public_method :match_file
    end
  end
end