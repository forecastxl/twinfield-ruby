require 'spec_helper'

describe Twinfield::Configuration do
  it 'creates a configuration object' do
    conf = Twinfield::Configuration.new(
      'my_username', 'my_password', 'my_organisation', 'my_company'
    )

    expect(conf.username).to eq('my_username')
    expect(conf.password).to eq('my_password')
    expect(conf.organisation).to eq('my_organisation')
    expect(conf.company).to eq('my_company')
  end

  it 'returns a hash object' do
    conf = Twinfield::Configuration.new(
      'my_username', 'my_password', 'my_organisation', 'my_company'
    ).to_hash

    expect(conf['user']).to eq('my_username')
    expect(conf['password']).to eq('my_password')
    expect(conf['organisation']).to eq('my_organisation')
    expect(conf['company']).to eq('my_company')
  end
end
