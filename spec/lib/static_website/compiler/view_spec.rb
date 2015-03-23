require "spec_helper"

describe StaticWebsite::Compiler::View do
  let(:view_path) { File.join(Rails.root, "spec", "support", "static_website_compiler", "view") }
  let(:view_options) { { layout: false, locals: { foo: :bar } } }
  let(:compile_path) { File.join(Rails.root, "tmp", "spec", "static_website_compiler", "view.html") }

  describe "#compile" do
    let(:subject) { StaticWebsite::Compiler::View.new(view_path, view_options, compile_path) }

    context "when compile path is blank" do
      let(:subject) { StaticWebsite::Compiler::View.new(view_path, view_options, nil) }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when compile path is present", vcr: VCR_OPTIONS do
      let(:subject) { StaticWebsite::Compiler::View.new(view_path, view_options, compile_path) }

      before do
        FileUtils.rm(compile_path, force: true) if File.exists?(compile_path)
      end

      after do
        FileUtils.rm(compile_path, force: true) if File.exists?(compile_path)
      end

      it "compiles compile directory" do
        subject.compile_directory.should_receive(:compile).once
        subject.stub(:render_to_file)
        subject.compile
      end

      it "writes file to compile path" do
        expect(File.exists?(subject.compile_path)).to be_falsey
        subject.compile
        expect(File.exists?(subject.compile_path)).to be_truthy
      end

      it "renders erb with options" do
        subject.compile
        expect(File.open(compile_path).read).to eq "bar\n"
      end
    end
  end

  describe "#compile_directory" do
    let(:subject) { StaticWebsite::Compiler::View.new(view_path, view_options, compile_path) }

    it "is a compile directory object" do
      expect(subject.compile_directory).to be_a StaticWebsite::Compiler::CompileDirectory
    end
  end
end
