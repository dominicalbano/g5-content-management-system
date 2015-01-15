require "spec_helper"

describe StaticWebsite::Compiler::Stylesheets do
  let(:stylesheets_klass) { StaticWebsite::Compiler::Stylesheets }
  let(:stylesheet_klass) { StaticWebsite::Compiler::Stylesheet }
  let(:stylesheet_path) { "http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" }
  let(:compile_directory) { File.join(Rails.root, "tmp", "spec") }

  describe "#compile" do
    context "when stylesheets is blank" do
      let(:subject) { stylesheets_klass.new(nil, compile_directory) }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when stylesheets are present" do
      context "and previewing" do
        let(:preview) { true }
        let(:subject) { stylesheets_klass.new([stylesheet_path],
          compile_directory, {}, {}, "", preview) }

        before do
          subject.colors_stylesheet.stub(:compile)
          subject.fonts_stylesheet.stub(:compile)
          stylesheet_klass.any_instance.stub(:compile)
        end

        it "compiles colors stylesheet" do
          subject.colors_stylesheet.should_receive(:compile).once
          subject.compile
        end

        it "compiles fonts stylesheet" do
          subject.fonts_stylesheet.should_receive(:compile).once
          subject.compile
        end

        it "compiles each one" do
          subject.should_receive(:compile_stylesheet).once
          subject.compile
        end

        it "does not compress stylesheets" do
          subject.stylesheet_compressor.should_not_receive(:compile)
          subject.compile
        end

        it "does not upload stylesheets" do
          subject.stylesheet_uploader.should_not_receive(:compile)
          subject.compile
        end
      end

      context "and deploying" do
        let(:preview) { false }
        let(:subject) { stylesheets_klass.new([stylesheet_path],
          compile_directory, {}, {}, "", preview) }

        before do
          subject.colors_stylesheet.stub(:compile)
          subject.fonts_stylesheet.stub(:compile)
          stylesheet_klass.any_instance.stub(:compile)
          subject.stylesheet_compressor.stub(:compile)
          subject.stylesheet_uploader.stub(:compile)
        end

        it "compiles colors stylesheet" do
          subject.colors_stylesheet.should_receive(:compile).once
          subject.compile
        end

        it "compiles fonts stylesheet" do
          subject.fonts_stylesheet.should_receive(:compile).once
          subject.compile
        end

        it "compiles each one" do
          subject.should_receive(:compile_stylesheet).once
          subject.compile
        end

        it "compresses stylesheets" do
          subject.stylesheet_compressor.should_receive(:compile).once
          subject.compile
        end

        it "uploads stylesheets" do
          subject.stylesheet_uploader.should_receive(:compile).once
          subject.compile
        end
      end
    end
  end

  describe "#colors_stylesheet" do
    let(:subject) { stylesheets_klass.new(nil, compile_directory) }

    it "is a colors stylesheet object" do
      expect(subject.colors_stylesheet).to be_a StaticWebsite::Compiler::Stylesheet::Colors
    end
  end

  describe "#fonts_stylesheet" do
    let(:subject) { stylesheets_klass.new(nil, compile_directory) }

    it "is a fonts stylesheet object" do
      expect(subject.fonts_stylesheet).to be_a StaticWebsite::Compiler::Stylesheet::Fonts
    end
  end

  describe "#compile_stylesheet" do
    context "when stylesheets is blank" do
      let(:subject) { stylesheets_klass.new(nil, compile_directory) }

      it "does nothing" do
        expect(subject.compile_stylesheet(nil)).to be_nil
      end
    end

    context "when stylesheet is present" do
      let(:subject) { stylesheets_klass.new(nil, compile_directory) }

      before do
        stylesheet_klass.any_instance.stub(:compile)
      end

      it "compiles stylesheet" do
        stylesheet_klass.any_instance.should_receive(:compile).once
        subject.compile_stylesheet(stylesheet_path)
      end
    end
  end

  describe "#location_name" do
    let(:subject) { stylesheets_klass.new(nil, compile_directory, {}, {}, "North Shore Oahu") }

    it "sets on initialize" do
      expect(subject.location_name).to eq "North Shore Oahu"
    end
  end

  describe "#compressed_path" do
    let(:subject) { stylesheets_klass.new(nil, compile_directory) }

    it "matches /stylesheets/application.min.css" do
      expect(subject.compressed_path).to match "/stylesheets/application.min.css"
    end
  end
end
