# :nodoc: namespace
module SpStore

# :nodoc: namespace
module PChip

# Software (untrusted) implementation of the P chip's session key cache.
class SoftSessionCache
  def initialize(capacity, endorsement_key)
    @capacity = capacity
    @ekey = endorsement_key
    @keys = Array.new capacity
    @process_key = Crypto.sk_key
  end

  attr_reader :capacity

  def process_key(encrypted_session_key)
    hmac_key = Crypto.pki_decrypt @ekey[:private], encrypted_session_key
    Crypto.sk_encrypt @process_key, hmac_key
  end

  def load(session_id, processed_session_key)
    check_session_id
    @keys[session_id] = Crypto.sk_decrypt @process_key, processed_session_key
  end

  # :nodoc: normally be called inside the P chip, and the result should never
  #         leave the chip.
  def session_key(session_id)
    check_session_id
    raise RuntimeError, "Invalid session"
  end
  
  def check_session_id(session_id)
    if session_id < 0 || session_id >= @capacity
      raise RuntimeError,
            "Invalid session_id #{session_id}; table capacity #{capacity}"
    end
  end
  private :check_session_id
end  # class SpStore::PChip::SoftSessionCache
  
end  # namespace SpStore::Mocks
  
end  # namespace SpStore
