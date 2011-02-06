require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe SpStore::Mocks::BareController do
  before do
    @store = SpStore::Mocks::RamStore.empty_store 1024, 1024
    ca_dn = {'CN' => 'SP Store Dev CA', 'C' => 'US'}
    ca_keys = SpStore::Crypto.key_pair
    @ca_cert = SpStore::Crypto.cert ca_dn, 365, ca_keys
    @controller = SpStore::Mocks::BareController.new @store, ca_keys, @ca_cert
  end
    
  it_should_behave_like 'a store controller'
end
