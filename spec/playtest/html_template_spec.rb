describe Playtestr::HtmlTemplate do

  let!(:destination) { "spec/data/default.html" }
  let!(:default_css) { "spec/data/default.css" }

  describe "Constructor" do
    it "instantiates with a specified output file" do
      expect(described_class.new(destination)).to be_instance_of(described_class)
    end
    it "can override the css source" do
      expect(described_class.new(destination, default_css)).to be_instance_of(described_class)
    end
  end

  describe "Attributes" do
    let!(:template) { described_class.new(destination, default_css) }
    
    it "allows public access to html and css source filenames" do
      expect(template.destination).to eq(destination)
      expect(template.css).to eq(default_css)
    end
  end

  describe "Methods" do
    context "when rendering html format" do
      describe "html format" do
        it "dumps the results to an html file" do
          skip("Stub out filesystem operations")
        end
      end
    end
  end
end
