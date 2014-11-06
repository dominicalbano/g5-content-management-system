require "spec_helper"

describe StaticWebsite::Compiler::Stylesheet::Colors do
  let(:compile_path) { File.join(Rails.root, "tmp", "spec", "static_website_compiler", "javascripts") }
  let(:colors) { { primary_color: "#FF0000", secondary_color: "#00FFFF", tertiary_color: "#FFFFFF" } }

  describe "#compile" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Colors.new(colors, compile_path) }

    it "compiles view" do
      subject.view.should_receive(:compile).once
      subject.compile
    end
  end

  describe "#view" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Colors.new(colors, compile_path) }

    it "is a view object" do
      expect(subject.view).to be_a StaticWebsite::Compiler::View
    end
  end

  describe "#view.compile" do
    context "when compile path is blank" do
      let(:subject) { StaticWebsite::Compiler::Stylesheet::Colors.new(colors, nil) }

      it "does nothing" do
        expect(subject.view.compile).to be_nil
      end
    end

    context "when compile path is present" do
      let(:subject) { StaticWebsite::Compiler::Stylesheet::Colors.new(colors, compile_path) }

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

      it "renders erb with colors" do
        subject.view.compile
        expect(File.open(subject.compile_path).read).to eq <<-EOS.strip_heredoc
          $primaryColor: #{colors[:primary_color]};
          $secondaryColor: #{colors[:secondary_color]};
          $tertiaryColor: #{colors[:tertiary_color]};
        EOS
      end
    end
  end

  describe "#view_path" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Colors.new(colors, compile_path) }

    it "is the compile pages colors stylesheet" do
      expect(subject.view_path).to eq "web_templates/stylesheets/colors"
    end
  end

  describe "#view_options" do
    let(:subject) { StaticWebsite::Compiler::Stylesheet::Colors.new(colors, compile_path) }

    it "sets format to scss" do
      expect(subject.view_options).to include(formats: [:scss])
    end

    it "sets layout to none" do
      expect(subject.view_options).to include(layout: false)
    end

    it "sets local primary_color" do
      expect(subject.view_options[:locals]).to include(primary_color: subject.colors[:primary_color])
    end

    it "sets local secondary_color" do
      expect(subject.view_options[:locals]).to include(secondary_color: subject.colors[:secondary_color])
    end

    it "sets local tertiary_color" do
      expect(subject.view_options[:locals]).to include(tertiary_color: subject.colors[:tertiary_color])
    end
  end
end
