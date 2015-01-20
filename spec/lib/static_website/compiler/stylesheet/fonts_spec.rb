require "spec_helper"

describe StaticWebsite::Compiler::Stylesheet::Fonts do
  let(:compile_path) { File.join(Rails.root, "tmp", "spec", "static_website_compiler", "javascripts") }
  let(:fonts) { { primary_font: "Impact", secondary_font: "Times New Roman" } }

  describe "#compile" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Fonts.new(fonts, compile_path) }

    it "compiles view" do
      subject.view.should_receive(:compile).once
      subject.compile
    end
  end

  describe "#view" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Fonts.new(fonts, compile_path) }

    it "is a view object" do
      expect(subject.view).to be_a StaticWebsite::Compiler::View
    end
  end

  describe "#view.compile" do
    context "when compile path is blank" do
      let(:subject) { StaticWebsite::Compiler::Stylesheet::Fonts.new(fonts, nil) }

      it "does nothing" do
        expect(subject.view.compile).to be_nil
      end
    end

    context "when compile path is present" do
      let(:subject) { StaticWebsite::Compiler::Stylesheet::Fonts.new(fonts, compile_path) }

      before do
        FileUtils.rm(subject.compile_path, force: true) if File.exists?(compile_path)
      end

      after do
        FileUtils.rm(subject.compile_path, force: true) if File.exists?(compile_path)
      end

      it "writes file to compile path" do
        expect(File.exists?(subject.compile_path)).to be_falsey
        subject.view.compile
        expect(File.exists?(subject.compile_path)).to be_truthy
      end

      it "renders erb with fonts" do
        subject.view.compile
        expect(File.open(subject.compile_path).read).to eq <<-EOS.strip_heredoc
          $primaryFont: '#{fonts[:primary_font]}';
          $secondaryFont: '#{fonts[:secondary_font]}';
        EOS
      end
    end
  end

  describe "#view_path" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Fonts.new(fonts, compile_path) }

    it "is the compile pages fonts stylesheet" do
      expect(subject.view_path).to eq "web_templates/stylesheets/fonts"
    end
  end

  describe "#view_options" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Fonts.new(fonts, compile_path) }

    it "sets format to scss" do
      expect(subject.view_options).to include(formats: [:scss])
    end

    it "sets layout to none" do
      expect(subject.view_options).to include(layout: false)
    end

    it "sets local primary_font" do
      expect(subject.view_options[:locals]).to include(primary_font: subject.fonts[:primary_font])
    end

    it "sets local secondary_font" do
      expect(subject.view_options[:locals]).to include(secondary_font: subject.fonts[:secondary_font])
    end
  end
end
