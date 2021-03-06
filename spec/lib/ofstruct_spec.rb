require "ofstruct"

RSpec.describe OpenFastStruct do
  subject(:ofstruct) { described_class.new }

  it "can be instantiated with no arguments" do
    expect(ofstruct).to be_a(described_class)
  end

  it "works accessor" do
    ofstruct.name = "John"
    expect(ofstruct.name).to eq("John")
  end

  it "works recursive accessor" do
    ofstruct.user.name = "John"
    ofstruct.name = "OpenFastStruct"
    expect(ofstruct.user).to be_a(described_class)
    expect(ofstruct.user.name).to eq("John")
    expect(ofstruct.name).to eq("OpenFastStruct")
  end

  it "works with unexisting values" do
    expect(ofstruct.name).to be_a(described_class)
    expect(ofstruct.nam).to be_a(described_class)
  end

  context "instantiated from arguments" do
    subject(:ofstruct) { described_class.new(args) }

    context "without Hash" do
      let(:args) { double }

      it "raises an exception" do
        expect { ofstruct }.to raise_error(ArgumentError)
      end
    end

    context "with Hash" do
      let(:symbol_args) { Hash[:name  => "John"] }
      let(:string_args) { Hash["name" => "John"] }

      context "with Symbol keys" do
        let(:args) { symbol_args }

        it "works with reader" do
          expect(ofstruct.name).to eq("John")
        end

        it "works accessor" do
          ofstruct.name = "John Smith"
          expect(ofstruct.name).to eq("John Smith")
        end

        describe "#delete_field" do
          it "removes the named key" do
            ofstruct.delete_field(:name)
            expect(ofstruct.name).to be_a(described_class)
          end
        end

        describe "#each_field" do
          it "yields all keys with the values" do
            expect(ofstruct.each_pair.to_a).to eq([[:name, "John"]])
          end

          it "returns an enumerator" do
            expect(ofstruct.each_pair).to be_a(Enumerator)
          end
        end

        describe "#update" do
          it "overwrite previous keys" do
            ofstruct.update(:name => "John Smith")
            expect(ofstruct.name).to eq("John Smith")
          end

          it "adds new keys" do
            ofstruct.update(:surname => "Smith")
            expect(ofstruct.name).to eq("John")
            expect(ofstruct.surname).to eq("Smith")
          end

          context "without Hash" do
            it "raises an exception" do
              expect { ofstruct.update(double) }.to raise_error(ArgumentError)
            end
          end
        end

        describe "#to_h" do
          it "converts to a hash" do
            expect(ofstruct.to_h).to eq(args)
          end
        end

        describe "#inspect" do
          it "returns the human-readable representation" do
            expect(ofstruct.inspect).to eq('#<OpenFastStruct :name="John">')
          end
        end
      end

      context "with String keys" do
        let(:args) { string_args }

        it "works with reader" do
          expect(ofstruct.name).to eq("John")
        end

        describe "#to_h" do
          it "converts to a hash with keys as symbols" do
            expect(ofstruct.to_h).to eq(symbol_args)
          end
        end

        describe "#inspect" do
          it "returns the human-readable representation" do
            expect(ofstruct.inspect).to eq('#<OpenFastStruct :name="John">')
          end
        end
      end
    end
  end
end
