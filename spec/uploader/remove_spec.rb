# encoding: utf-8

require 'spec_helper'

describe CarrierWave::Uploader do

  before do
    @uploader_class = Class.new(CarrierWave::Uploader::Base)
    @uploader = @uploader_class.new
  end

  after do
    FileUtils.rm_rf(public_path)
  end

  describe '#remove!' do
    before do
      @file = File.open(file_path('test.jpg'))

      @stored_file = double('a stored file')
      allow(@stored_file).to receive(:path).and_return('/path/to/somewhere')
      allow(@stored_file).to receive(:url).and_return('http://www.example.com')
      allow(@stored_file).to receive(:identifier).and_return('this-is-me')
      allow(@stored_file).to receive(:delete)

      @storage = double('a storage engine')
      allow(@storage).to receive(:store!).and_return(@stored_file)

      allow(@uploader_class.storage).to receive(:new).and_return(@storage)
      @uploader.store!(@file)
    end

    it "should reset the current path" do
      @uploader.remove!
      @uploader.current_path.should be_nil
    end

    it "should not be cached" do
      @uploader.remove!
      @uploader.should_not be_cached
    end

    it "should reset the url" do
      @uploader.cache!(@file)
      @uploader.remove!
      @uploader.url.should be_nil
    end

    it "should reset the identifier" do
      @uploader.remove!
      @uploader.identifier.should be_nil
    end

    it "should delete the file" do
      @stored_file.should_receive(:delete)
      @uploader.remove!
    end

    it "should reset the cache_name" do
      @uploader.cache!(@file)
      @uploader.remove!
      @uploader.cache_name.should be_nil
    end

    it "should do nothing when trying to remove an empty file" do
      running { @uploader.remove! }.should_not raise_error
    end
  end

end
