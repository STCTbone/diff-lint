require_relative 'spec_helper'
require_relative '../lib/lint_manager'
require_relative '../lib/file_matcher'

describe DiffLint::LintManager do

  describe '.initialize' do
    it 'stores the passed in set of changes' do
      mock_changes = double
      test_manager = described_class.new mock_changes
      expect(test_manager.instance_variable_get(:@changes)).to eq (mock_changes)
    end
  end

  describe '.lint_changes' do
    it 'iterates through each change' do
      test_manager = described_class.new
      expect(test_manager.instance_variable_get(:@changes)).to receive(:each)
      test_manager.lint_changes
    end

    it 'passes each change path to FileMatcher' do
      mock_change = double(Object)
      mock_changes = [mock_change, mock_change, mock_change]
      expect(DiffLint::FileMatcher).to receive(:match_file)
                                         .with(mock_change).exactly(3).times
      test_manager = described_class.new mock_changes
      test_manager.lint_changes
    end
  end
end