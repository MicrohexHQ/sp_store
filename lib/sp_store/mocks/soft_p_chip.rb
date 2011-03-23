# :nodoc: namespace
module SpStore

# :nodoc: namespace
module Mocks

# Software (untrusted) implementation of the P chip.
class SoftPChip
  # Instantiates a new soft implementation of the P chip.
  #
  # Args:
  #   p_key:: the P chip's symmetric key; was generated during the manufacturing
  #           process
  #   ca_public_key:: the public key of the S-P chip pair's manufacturer root
  #                   CA; this is burned in the P chip's ROM
  #   options:: supports the following keys
  #             cache_size:: entries in the simulated chip's node cache
  #             capacity:: number of data blocks supported by the simulated chip
  #             session_cache_size:: number of session keys supported by the
  #                                  simulated chip's session cache
  def initialize(p_key, ca_public_key, options)
    @boot_logic = SpStore::PChip::SoftBootLogic.new p_key, ca_public_key, self
    @session_cache = SpStore::PChip::SoftSessionCache.new(
         options[:session_cache_size])
    @node_cache = SpStore::PChip::SoftNodeCache.new options[:cache_size],
         options[:capacity], session_cache

    @boot_logic.reset
  end
  
  attr_reader :capacity
  attr_reader :cache_size
  attr_reader :session_cache_size
  
  def booted(root_hash, endorsement_key)
    @node_cache.set_root_hash root_hash
    @session_cache.set_endorsement_key endorsement_key
  end
  
  def hash_block(data)
    Crypto.crypto_hash data
  end
end  # class SpStore::Mocks::SoftPChip
  
end  # namespace SpStore::Mocks
  
end  # namespace SpStore
