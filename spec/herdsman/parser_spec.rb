require 'spec_helper'

describe Herdsman::Parser do
  let(:stubbed_hashes) {
    [
      {
        "name"  => "kitkat",
        "price" => "1.99",
        "group" => "chocolate"
      },
      {
        "name"  => "skittles",
        "price" => "0.89",
        "group" => "candy"
      },
      {
        "name"  => "ketchup",
        "price" => "2.99",
        "group" => "vegetable"
      }
    ]
  }

  let(:stubbed_lines) {
    ["kitkat 1.99 chocolate\n", "skittles 0.89 candy\n", "ketchup 2.99 vegetable\n"]
  }

  let(:stubbed_fields) {
    %w(name price group)
  }

  let(:stubbed_parser) {
    Herdsman::Parser.new('', {})
  }

  it "should read a file with the passed options" do
    parser = Herdsman::Parser.new('some_file', :fields => ['a', 'b', 'c'])
    parser.file.should == 'some_file'
    parser.fields.should == ['a', 'b', 'c']
  end

  describe :to_array do
    it "converts the file to an array of hashes with keys based on the fields parameter" do
      stubbed_parser.stub(:read_file).and_return(stubbed_lines)
      stubbed_parser.stub(:fields).and_return(stubbed_fields)

      stubbed_parser.to_array.should == stubbed_hashes
    end
  end

  describe :to_s do
    it "should convert the file to json format using the fields parameters" do
      stubbed_parser.stub(:to_array).and_return(stubbed_hashes)

      # one json object per line : format used by mongoimport & mongoexport
      stubbed_parser.to_s.should == <<-EOS.gsub(/^ {8}/, '').strip
        {
          "name": "kitkat",
          "price": "1.99",
          "group": "chocolate"
        }
        {
          "name": "skittles",
          "price": "0.89",
          "group": "candy"
        }
        {
          "name": "ketchup",
          "price": "2.99",
          "group": "vegetable"
        }
      EOS
    end
  end

  describe :parse_hash_from do

  end

  describe :add_fields_to_array do
    it "raises an error if the fields array has a different size than the passed array" do
      stubbed_parser.stub(:fields).and_return([:a])

      expect {
        stubbed_parser.send(:add_fields_to_array, [:c, :d])
      }.to raise_error(Herdsman::Parser::FieldCountMismatch, "Expected 2 fields, got 1.")
    end
  end

  describe :line2arr do
    it "puts quotation marks around brackets" do
      stubbed_parser.send(:line2arr, "a [01/Sept/2011:18:00:00 +0000] b").should == ["a", "[01/Sept/2011:18:00:00 +0000]", "b"]
    end
  end
end