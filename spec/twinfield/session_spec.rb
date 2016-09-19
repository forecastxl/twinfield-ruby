require 'spec_helper'

describe Twinfield::LoginSession do
  describe 'successful logon' do
    before(:all) do
      conf = Twinfield::Configuration.new('xxx', 'xxx', 'xxx', 'xxx')
      @session = Twinfield::LoginSession.new(conf)
      @session.logon
    end

    it 'should return successful message' do
      expect(@session.status).to eq('Ok')
    end

    it 'should return that the current session already is connected' do
      expect(@session.logon).to eq('already connected')
    end

    it 'should return that the current session already is connected' do
      expect(@session.relog).to eq('Ok')
    end

    it 'should have a session_id after successful logon' do
      expect(@session.session_id).to_not be_nil
    end

    it 'should have a cluster after successful logon' do
      expect(@session.cluster).to_not be_nil
    end

    it 'should return true for connected' do
      expect(@session.connected?).to be true
    end
  end

  describe 'invalid logon' do
    before(:all) do
      conf = Twinfield::Configuration.new('test', 'test', 'TEST', 'test')

      @session = Twinfield::LoginSession.new(conf)
      @session.logon
    end

    it 'should return invalid message' do
      expect(@session.status).to eq('Invalid')
    end

    it 'should not have a session_id' do
      expect(@session.session_id).to be_nil
    end

    it 'should not have a cluster' do
      expect(@session.cluster).to be_nil
    end

    it 'should return false for connected' do
      expect(@session.connected?).to be false
    end
  end
end
