describe Playtestr::PdfTemplate do

  let!(:destination) { "spec/data/export.pdf" }
  let!(:template) { described_class.new(destination) }
  
  describe "Constructor" do
    it "instantiates with an export filename" do
      expect(described_class.new(destination)).to be_instance_of(described_class)
    end
  end

  describe "Methods" do
    context "when outputting" do
      describe "pdf format" do
        it "dumps the results to a PDF file" do
          skip("Check PDFKit API docs for test case details")
        end
      end
    end
  end
  
end
