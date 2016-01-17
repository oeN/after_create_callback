require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new email: "bar@bar.com" }
  let(:user) { described_class.create email: "foo@foo.com" }

  it 'retry to generate a different token' do
    allow(SecureRandom).to receive(:hex).and_return user.token, "different_token"
    expect(SecureRandom).to receive(:hex).twice

    subject.save
    expect(subject.token).to_not be_nil
  end

  it 'limit retries to generate a different token' do
    allow(subject).to receive(:retries_limit).and_return 1
    allow(SecureRandom).to receive(:hex).and_return user.token, user.token, "different_token"
    expect(SecureRandom).to receive(:hex).twice

    subject.save
    expect(subject.token).to be_nil
  end
end
