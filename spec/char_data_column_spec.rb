require 'char_data'

describe CharData do

  def fake_data(data)
    FakeData.new data, FAKE_DATA_WIDTH
  end

  describe 'with fake rectangle character data' do

    before do
      @data = fake_data FAKE_RECT_DATA
    end

    it 'should return true for used first column' do
      column(0).has_non_zero_alpha_value.should == true
    end

    it 'should return true for used second column' do
      column(1).has_non_zero_alpha_value.should == true
    end

    it 'should return true for used third column' do
      column(2).has_non_zero_alpha_value.should == true
    end

    it 'should return false for empty last column' do
      column(3).has_non_zero_alpha_value.should == false
    end

  end

  describe 'with fake diagonal line character data' do

    before do
      @data = fake_data FAKE_DIAGONAL_DATA
    end

    it 'should return true for used first column' do
      column(0).has_non_zero_alpha_value.should == true
    end

    it 'should return true for used second column' do
      column(1).has_non_zero_alpha_value.should == true
    end

    it 'should return true for used third column' do
      column(2).has_non_zero_alpha_value.should == true
    end

    it 'should return true for used last column' do
      column(3).has_non_zero_alpha_value.should == true
    end

  end

  def column(index)
    CharDataColumn.new @data, index
  end

end
