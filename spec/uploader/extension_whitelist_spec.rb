
require 'spec_helper'

describe CarrierWave::Uploader do

  before do
    @uploader_class = Class.new(CarrierWave::Uploader::Base)
    @uploader = @uploader_class.new
  end

  after do
    FileUtils.rm_rf(public_path)
  end

  describe '#cache!' do

    before do
      allow(CarrierWave).to receive(:generate_cache_id).and_return('1369894322-345-2255')
    end

    it "should not raise an integrity error if there is no white list" do
      allow(@uploader).to receive(:extension_white_list).and_return(nil)
      running {
        @uploader.cache!(File.open(file_path('test.jpg')))
      }.should_not raise_error(CarrierWave::IntegrityError)
    end

    it "should not raise an integrity error if there is a white list and the file is on it" do
      allow(@uploader).to receive(:extension_white_list).and_return(%w(jpg gif png))
      running {
        @uploader.cache!(File.open(file_path('test.jpg')))
      }.should_not raise_error(CarrierWave::IntegrityError)
    end

    it "should raise an integrity error if there is a white list and the file is not on it" do
      allow(@uploader).to receive(:extension_white_list).and_return(%w(txt doc xls))
      running {
        @uploader.cache!(File.open(file_path('test.jpg')))
      }.should raise_error(CarrierWave::IntegrityError)
    end

    it "should raise an integrity error if there is a white list and the file is not on it, using start of string matcher" do
      allow(@uploader).to receive(:extension_white_list).and_return(%w(txt))
      running {
        @uploader.cache!(File.open(file_path('bork.ttxt')))
      }.should raise_error(CarrierWave::IntegrityError)
    end

    it "should raise an integrity error if there is a white list and the file is not on it, using end of string matcher" do
      allow(@uploader).to receive(:extension_white_list).and_return(%w(txt))
      running {
        @uploader.cache!(File.open(file_path('bork.txtt')))
      }.should raise_error(CarrierWave::IntegrityError)
    end

    it "should compare white list in a case insensitive manner when capitalized extension provided" do
      allow(@uploader).to receive(:extension_white_list).and_return(%w(jpg gif png))
      running {
        @uploader.cache!(File.open(file_path('case.JPG')))
      }.should_not raise_error(CarrierWave::IntegrityError)
    end

    it "should compare white list in a case insensitive manner when lowercase extension provided" do
      allow(@uploader).to receive(:extension_white_list).and_return(%w(JPG GIF PNG))
      running {
        @uploader.cache!(File.open(file_path('test.jpg')))
      }.should_not raise_error(CarrierWave::IntegrityError)
    end

    it "should accept and check regular expressions" do
      allow(@uploader).to receive(:extension_white_list).and_return([/jpe?g/, 'gif', 'png'])
      running {
        @uploader.cache!(File.open(file_path('test.jpeg')))
      }.should_not raise_error(CarrierWave::IntegrityError)
    end
  end

end
