require "spec_helper"

def path_exists
  path = File.join(Rails.root, "tmp", "spec", "path_exists")
  FileUtils.mkdir_p(path)
  path
end

def path_does_not_exist
  path = File.join(Rails.root, "tmp", "spec", "path_does_not_exist")
  FileUtils.rm_rf(path)
  path
end

describe StaticWebsite::Compiler::CompileDirectory do
  describe "#compile" do
    context "when path is blank" do
      let(:subject) { StaticWebsite::Compiler::CompileDirectory.new(nil) }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when directory at path exists" do
      let(:subject) { StaticWebsite::Compiler::CompileDirectory.new(path_exists) }

      it "does nothing" do
        expect(Dir.exists?(subject.path)).to be_truthy
        expect(subject.compile).to be_nil
      end
    end

    context "when directory at path does not exist" do
      let(:subject) { StaticWebsite::Compiler::CompileDirectory.new(path_does_not_exist) }

      it "makes a directory at the path" do
        expect(Dir.exists?(subject.path)).to be_falsey
        expect(subject.compile).to eq [subject.path]
        expect(Dir.exists?(subject.path)).to be_truthy
      end
    end
  end

  describe "#clean_up" do
    context "when path is blank" do
      let(:subject) { StaticWebsite::Compiler::CompileDirectory.new(nil) }

      it "does nothing" do
        expect(subject.clean_up).to be_nil
      end
    end

    context "when directory at path does not exist" do
      let(:subject) { StaticWebsite::Compiler::CompileDirectory.new(path_does_not_exist) }

      it "does nothing" do
        expect(Dir.exists?(subject.path)).to be_falsey
        expect(subject.clean_up).to be_nil
      end
    end

    context "when directory at path exists" do
      let(:subject) { StaticWebsite::Compiler::CompileDirectory.new(path_exists) }

      it "removes directory at the path" do
        expect(Dir.exists?(subject.path)).to be_truthy
        expect(subject.clean_up).to eq [subject.path]
        expect(Dir.exists?(subject.path)).to be_falsey
      end
    end
  end
end
