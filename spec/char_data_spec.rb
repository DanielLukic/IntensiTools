require 'char_data'

describe CharData do

  before do
    @splicer = FakeSplicer.new
    @data = CharData.new @splicer, nil
  end

  def columns
    @data.columns
  end

  it 'should create correct number of columns' do
    columns.size == FAKE_DATA_WIDTH
  end

  it 'should have increasing column indexes' do
    columns[0].index.should == 0
    columns[1].index.should == 1
    columns[2].index.should == 2
    columns[3].index.should == 3
  end

  describe 'with fake rectangle character data' do

    before do
      @data = CharData.new @splicer, FAKE_RECT_DATA
    end

    it 'should find correct width' do
      @data.find_width.should == 3
    end

  end

  describe 'with fake diagonal line character data' do

    before do
      @data = CharData.new @splicer, FAKE_DIAGONAL_DATA
    end

    it 'should find correct width' do
      @data.find_width.should == 4
    end

  end

  describe 'with fake empty character data' do

    before do
      @data = CharData.new @splicer, FAKE_EMPTY_DATA
    end

    it 'should find correct width' do
      @data.find_width.should == FAKE_ZERO_WIDTH
    end

  end

end
