require_relative 'spec_helper'
require_relative '../lib/status_reader'
require 'git'
require 'logger'

describe DiffLint::StatusReader do
  describe '.changed_files' do
    it 'returns an object that responds to .each' do
      expect(described_class.new.changed_files).to respond_to(:each)
    end
  end

  let(:test_path) { 'foo/bar' }
  describe '.read_changes' do
    let(:test_changed_item) { double(Object, path: test_path) }
    let(:test_objects) { [test_changed_item,test_changed_item,test_changed_item] }
    let(:test_status) { double(Object, changed: test_objects, untracked: [])}
    let(:test_git) { double(Object, status: test_status) }
    before { allow(Git).to receive(:open).and_return test_git }

    it 'instantiates a new Git object' do
      test_logger = DiffLint::NullLogger.new
      expect(Git).to receive(:open).with(Dir.pwd, log: test_logger)
      DiffLint::StatusReader.new(test_logger).read_changes
    end

    it 'adds each changed file path to @changed_files' do
      test_reader = DiffLint::StatusReader.new
      test_reader.read_changes
      expect(test_reader.instance_variable_get(:@changed_files))
        .to eq test_objects.map(&:path)
    end

    it 'adds each untracked file path to @changed_files' do
      test_untracked_status = double(Object, changed: [], untracked: test_objects)
      test_untracked_git = double(Object, status: test_untracked_status)
      allow(Git).to receive(:open).and_return test_untracked_git
      test_reader = DiffLint::StatusReader.new
      test_reader.read_changes
      expect(test_reader.instance_variable_get(:@changed_files))
        .to eq test_objects.map(&:path)
    end
  end

  describe '.add_file' do
    it 'adds a file path to @changed_files' do
      test_reader = DiffLint::StatusReader.new
      test_file = double(Object, path: test_path)
      test_reader.send(:add_file, test_file)
      expect(test_reader.instance_variable_get(:@changed_files).count).to eq 1
      expect(test_reader.instance_variable_get(:@changed_files)).to include test_path
    end
  end
end
