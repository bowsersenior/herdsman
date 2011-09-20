require 'spec_helper'

describe Herdsman::Parser do
  it "should read a file with the passed options" do
    parser = Herdsman::Parser.new('some_file', :fields => ['a', 'b', 'c'])
    parser.file.should == 'some_file'
    parser.fields.should == ['a', 'b', 'c']
  end

  it "should convert the file to json format using the fields parameters" do
    parser = Herdsman::Parser.new('some_file', :fields => ['a', 'b', 'c'])

    stubbed_file_lines  = ["kitkat 1.99 chocolate\n", "skittles 0.89 candy\n", "ketchup 2.99 vegetable\n"]
    stubbed_fields  = %w(name price group)

    File.stub(:open).with('some_file').and_return(stubbed_file_lines)
    parser.stub(:fields).and_return(stubbed_fields)

    # one json object per line : format used by mongoimport & mongoexport
    parser.to_s.should == <<-EOS
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

  describe :line2arr do
    it "puts quotation marks around brackets" do
      parser = Herdsman::Parser.new('', {})
      parser.send(:line2arr, "a [01/Sept/2011:18:00:00 +0000] b").should == ["a", "[01/Sept/2011:18:00:00 +0000]", "b"]
    end
  end
end