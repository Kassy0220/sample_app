require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it 'full_titleヘルパーが正しいタイトルを表示する' do
    expect(helper.full_title).to eq('Ruby on Rails Tutorial Sample App')
    expect(helper.full_title('Home')).to eq('Home | Ruby on Rails Tutorial Sample App')
  end  
end