require "spec_helper"

describe StaticWebsite::Compiler::RemoteFile do
  let(:remote_path) { "http://codeorigin.jquery.com/jquery-2.0.3.min.js" }
  let(:compile_path) { File.join(Rails.root, "tmp", "spec", "static_website_compiler", "remote_file.js") }

  describe "#compile" do
    context "when compile path is blank" do
      let(:subject) { StaticWebsite::Compiler::RemoteFile.new(remote_path, nil) }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when compile path is present", vcr: VCR_OPTIONS do
      let(:subject) { StaticWebsite::Compiler::RemoteFile.new(remote_path, compile_path) }

      before do
        FileUtils.rm(subject.compile_path, force: true) if File.exists?(compile_path)
      end

      after do
        FileUtils.rm(subject.compile_path, force: true) if File.exists?(compile_path)
      end

      it "compiles compile directory" do
        subject.compile_directory.should_receive(:compile).once
        subject.stub(:write_to_file)
        subject.compile
      end

      it "writes file to compile path" do
        expect(File.exists?(subject.compile_path)).to be_falsey
        subject.compile
        expect(File.exists?(subject.compile_path)).to be_truthy
      end
    end
  end

  describe "#compile_directory" do
    let(:subject) { StaticWebsite::Compiler::RemoteFile.new(remote_path, compile_path) }

    it "is a compile directory object" do
      expect(subject.compile_directory).to be_a StaticWebsite::Compiler::CompileDirectory
    end
  end
end
