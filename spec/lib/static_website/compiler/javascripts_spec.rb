require "spec_helper"

describe StaticWebsite::Compiler::Javascripts do
  let(:javascripts_class) { StaticWebsite::Compiler::Javascripts }
  let(:javascript_class) { StaticWebsite::Compiler::Javascript }
  let(:javascript_path) { "http://codeorigin.jquery.com/jquery-2.0.3.min.js" }
  let(:compile_directory) { File.join(Rails.root, "tmp", "spec") }

  describe "#compile" do
    context "when javascripts is blank" do
      let(:subject) { javascripts_class.new(nil, compile_directory, "some-page") }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when javascripts are present" do
      context "and previewing" do
        let(:preview) { true }
        let(:subject) { javascripts_class.new([javascript_path],
          compile_directory, "some-page", "", preview) }

        before do
          javascript_class.any_instance.stub(:compile)
        end

        it "compiles each one" do
          subject.should_receive(:compile_javascript).once
          subject.compile
        end

        it "does not compress javascripts" do
          subject.javascript_compressor.should_not_receive(:compile)
          subject.compile
        end

        it "does not upload javascripts" do
          subject.javascript_uploader.should_not_receive(:compile)
          subject.compile
        end
      end

      context "and deploying" do
        let(:preview) { false }
        let(:subject) { javascripts_class.new(javascript_path,
                                              compile_directory, 
                                              "some-page",
                                              "",
                                              preview) }

        before do
          javascript_class.any_instance.stub(:compile)
          StaticWebsite::Compiler::Javascript::Uploader.any_instance.stub(:compile) 
        end

        it "compiles each one" do
          subject.should_receive(:compile_javascript).once
          subject.compile
        end

        # it "compresses javascripts" do
        #   subject.javascript_compressor.should_receive(:compile).once
        #   subject.compile
        # end

        it "uploads javascripts" do
          subject.javascript_uploader.should_receive(:compile).once
          subject.compile
        end
      end
    end
  end

  describe "#compile_javascript" do
    context "when javascripts is blank" do
      let(:subject) { javascripts_class.new(nil, compile_directory, "some-page") }

      it "does nothing" do
        expect(subject.compile_javascript(nil)).to be_nil
      end
    end

    context "when javascript is present" do
      let(:subject) { javascripts_class.new(nil, compile_directory, "some-page") }

      before do
        javascript_class.any_instance.stub(:compile)
      end

      it "compile javascript" do
        javascript_class.any_instance.should_receive(:compile).once
        subject.compile_javascript(javascript_path)
      end
    end
  end

  describe "#location_name" do
    let(:subject) { javascripts_class.new(nil, compile_directory, "some-page", "North Shore Oahu") }

    it "sets on initialize" do
      expect(subject.location_name).to eq "North Shore Oahu"
    end
  end

  describe "#compressed_path" do
    let(:subject) { javascripts_class.new(nil, compile_directory, "some-page") }

    it "matches /javascripts/some-page.min.js" do
      allow(Time).to receive(:now).and_return "123"
      expect(subject.compressed_path).to match "/javascripts/some-page-123.min.js"
    end
  end
end
