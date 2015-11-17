require 'spec_helper'

describe Twinfield::Configuration do

  it "creates a configuration object" do
    conf = Twinfield::Configuration.new(
      "my_username", "my_password", "my_organisation", "my_company"
    )
    conf.username.should == "my_username"
    conf.password.should == "my_password"
    conf.organisation.should == "my_organisation"
    conf.company.should == "my_company"
  end

  it "returns a hash object" do
    conf = Twinfield::Configuration.new(
      "my_username", "my_password", "my_organisation", "my_company"
    )
    conf_hash = conf.to_hash
    conf_hash['user'].should == "my_username"
    conf_hash['password'].should == "my_password"
    conf_hash['organisation'].should == "my_organisation"
    conf_hash['company'].should == "my_company"
  end


end