require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Heroku::Command::Switch do
  describe "on plugin load" do
    before(:each) do
      @directory = File.expand_path(File.dirname(__FILE__) + "/../../../")
      @plugin_name = File.basename(File.expand_path(File.dirname(__FILE__) + "/../../"))
      @plugin_path = "#{@directory}/#{@plugin_name}"
      stub(Heroku::Plugin).list { [@plugin_name] }
      stub(Heroku::Plugin).directory { @directory }
    end

    it "should include plugin directory in path" do
      Heroku::Plugin.load!
      $:.include?("#{@plugin_path}/lib").should be_true
    end

    it "should load the init file" do
      init_file = @plugin_path + "/init.rb"
      stub(Heroku::Plugin).load(init_file)
      Heroku::Plugin.load!
    end
  end
end
