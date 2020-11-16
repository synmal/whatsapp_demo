require 'rails_helper'

RSpec.describe Recipient, type: :model do
  describe 'validations' do
    it{ should validate_presence_of(:number) }
    it{ should validate_uniqueness_of(:number) }
  end
end
