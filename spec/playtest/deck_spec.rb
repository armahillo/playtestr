describe Playtest::Deck do

  let!(:card_source) { "spec/data/cards.yml" }
  let!(:alternate_card_source) { "spec/data/alternate_cards.yml" }
  let!(:deck) { described_class.new(card_source) }
  
  describe "Constructor" do
    it "instantiates with no arguments" do
      expect(described_class.new).to be_instance_of(described_class)
    end
    it "can override the source file with an argument" do
      d = described_class.new(card_source)
      expect(d).to be_instance_of(described_class)
      expect(d.cards).to_not be_empty
    end
  end

  describe "Attributes" do
    it "can access the cards read-only" do
      expect(deck.cards.count).to_not be_nil
      expect { deck.cards = 5 }.to raise_error(NoMethodError)
    end
  end

  describe "Methods" do
    it "can load a new YAML file" do
      expect {
        deck.load(alternate_card_source)
      }.to change{deck.cards.count}
    end
  
    context "when enumerating" do
      it "prepares the details hash" do
        details = deck.first
        expect(details).to_not be_nil
        expect(details["name"]).to_not be_nil
      end
    end
  end
end
