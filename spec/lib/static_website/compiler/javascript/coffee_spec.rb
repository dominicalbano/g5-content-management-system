require "spec_helper"

describe StaticWebsite::Compiler::Javascript::Coffee do
  let(:javascript_path) { File.join(Rails.root, "spec", "support", "static_website_compiler", "javascript.coffee") }
  let(:compile_path) { File.join(Rails.root, "tmp", "spec", "static_website_compiler", "javascripts") }

  describe "#compile" do
    let(:subject) { StaticWebsite::Compiler::Javascript::Coffee.new(javascript_path, compile_path) }

    context "when compile path is blank" do
      let(:subject) { StaticWebsite::Compiler::Javascript::Coffee.new(javascript_path, nil) }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when compile path is present" do
      let(:subject) { StaticWebsite::Compiler::Javascript::Coffee.new(javascript_path, compile_path) }

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

      it "compiles coffee into js" do
        subject.compile
        expect(File.open(subject.compile_path).read).to eq <<-EOS
(function() {
  var cubes, list, math, num, number, opposite, race, square,
    __slice = [].slice;

  number = 42;

  opposite = true;

  if (opposite) {
    number = -42;
  }

  square = function(x) {
    return x * x;
  };

  list = [1, 2, 3, 4, 5];

  math = {
    root: Math.sqrt,
    square: square,
    cube: function(x) {
      return x * square(x);
    }
  };

  race = function() {
    var runners, winner;
    winner = arguments[0], runners = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return print(winner, runners);
  };

  if (typeof elvis !== \"undefined\" && elvis !== null) {
    alert(\"I knew it!\");
  }

  cubes = (function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      num = list[_i];
      _results.push(math.cube(num));
    }
    return _results;
  })();

}).call(this);
        EOS
      end
    end
  end

  describe "#compile_directory" do
    let(:subject) { StaticWebsite::Compiler::Javascript::Coffee.new(javascript_path, compile_path) }

    it "is a compile directory object" do
      expect(subject.compile_directory).to be_a StaticWebsite::Compiler::CompileDirectory
    end
  end
end
