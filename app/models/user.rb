class User < ActiveRecord::Base
  before_create :generate_token
  after_rollback :retry_token, on: :create

  attr_accessor :retry_count

  def save
    super
  rescue ActiveRecord::RecordNotUnique
  end

  def save!
    super
  rescue ActiveRecord::RecordNotUnique
  end

  private

  def generate_token
    self.token = SecureRandom.hex(8)
  end

  def retries_limit
    3
  end

  def retry_token
    @retry_count = (@retry_count || 0) + 1
    save if @retry_count <= retries_limit
  end
end
