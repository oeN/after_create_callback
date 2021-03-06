class User < ActiveRecord::Base
  after_commit :generate_token, on: :create

  attr_accessor :retry_count

  private

  def generate_token
    update_column :token, SecureRandom.hex(8)
  rescue ActiveRecord::RecordNotUnique
    @retry_count = (@retry_count || 0) + 1
    retry if @retry_count <= retries_limit
  end

  def retries_limit
    3
  end
end
