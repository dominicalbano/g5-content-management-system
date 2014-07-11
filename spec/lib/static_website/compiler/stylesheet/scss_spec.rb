require "spec_helper"

describe StaticWebsite::Compiler::Stylesheet::Scss do
  let(:stylesheet_path) { File.join(Rails.root, "spec", "support", "static_website_compiler", "stylesheet.scss") }
  let(:compile_dir) { File.join(Rails.root, "tmp", "spec", "static_website_compiler", "stylesheets") }
  let(:compile_path) { File.join(compile_dir, "stylesheet.scss") }
  let(:local_stylesheets_path) { File.join(Rails.root, "app", "views", "web_templates", "stylesheets") }

  describe "#compile" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Scss.new(stylesheet_path, compile_path) }

    context "when compile path is blank" do
      let(:subject) { StaticWebsite::Compiler::Stylesheet::Scss.new(stylesheet_path, nil) }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when compile path is present" do
      let(:subject) { StaticWebsite::Compiler::Stylesheet::Scss.new(stylesheet_path, compile_path) }

      before do
        remove_path(subject.compile_path)
      end

      after do
        remove_path(subject.compile_path)
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

      it "compiles scss into css" do
        subject.compile
        expect(File.open(subject.compile_path).read).to eq <<-EOS.strip_heredoc
          .content-navigation {
            border-color: #3bbfce;
            color: #2ca2af; }

          .border {
            padding: 8px;
            margin: 8px;
            border-color: #3bbfce; }
        EOS
      end
    end
  end

  describe "#compile_directory" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Scss.new(stylesheet_path, compile_path) }

    it "is a compile directory object" do
      expect(subject.compile_directory).to be_a StaticWebsite::Compiler::CompileDirectory
    end
  end

  describe "#options" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Scss.new(stylesheet_path, compile_path) }

    it "sets synax to scss" do
      expect(subject.options).to include(syntax: :scss)
    end

    it "sets compile dir and local stylesheets path as the load paths" do
      expect(subject.options).to include(load_paths: [compile_dir, local_stylesheets_path])
    end
  end
end
