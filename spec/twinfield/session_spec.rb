require 'spec_helper'

describe Twinfield::LoginSession do
  describe "successful logon" do

    before(:all) do
      conf = Twinfield::Configuration.new('xxx', 'xxx', 'xxx', 'xxx')
      @session = Twinfield::LoginSession.new(conf)
      @session.logon
    end

    it "should return successful message" do
      @session.status.should == "Ok"
    end

    it "should return that the current session already is connected" do
      @session.logon.should == "already connected"
    end

    it "should return that the current session already is connected" do
      @session.relog.should == "Ok"
    end

    it "should have a session_id after successful logon" do
      @session.session_id.should_not == nil
    end

    it "should have a cluster after successful logon" do
      @session.cluster.should_not == nil
    end

    it "should return true for connected" do
      @session.connected?.should == true
    end
  end

  describe "invalid logon" do

    before(:all) do
      conf = Twinfield::Configuration.new('test', 'test', 'TEST', 'test')

      @session = Twinfield::LoginSession.new(conf)
      @session.logon
    end

    it "should return invalid message" do
      @session.status.should == "Invalid"
    end

    it "should not have a session_id" do
      @session.session_id.should == nil
    end

    it "should not have a cluster" do
      @session.cluster.should == nil
    end

    it "should return false for connected" do
      @session.connected?.should == false
    end
  end
end