class User < ActiveRecord::Base
  after_create :generate_token
  
  attr_accessor :retry_count

  private

  def generate_token
    update_column :token, SecureRandom.hex(8)
  rescue ActiveRecord::RecordNotUnique
    @retry_count = @retry_count.to_i + 1
    retry if @retry_count <= retries_limit
  end

  def retries_limit
    3
  end
end
