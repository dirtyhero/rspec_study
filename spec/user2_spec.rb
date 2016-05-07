require 'spec_helper'

RSpec.describe User do
  describe '#greet' do
    let(:user) { User.new(name: 'たろう', age: age) }
    subject{ user.greet }
    context 'when 0 years old' do
      let(:age) { 0 }
      it { is_expected.to eq 'ぼくはたろうだよ。'}
      
    end
    context '12歳の場合' do
      let(:age) { 12 }
      it { is_expected.to eq 'ぼくはたろうだよ。' }
    end

    context '13歳の場合' do
      let(:age) { 13 }
      it { is_expected.to eq '僕はたろうです。' }
    end
    context '100歳の場合' do
      let(:age) { 100 }
      it { is_expected.to eq '僕はたろうです。' }
    end

  end
  
end

# shared_examples と it_behaves_likeを使ってリファクタリング

RSpec.describe User do
  describe '#greet' do
    let(:user) { User.new(name: 'たろう', age: age) }
    subject{ user.greet }
    shared_examples '子どものあいさつ' do
      it { is_expected.to eq 'ぼくはたろうだよ。'}
    end
    context 'when 0 years old' do
      let(:age) { 0 }
      it_behaves_like '子どものあいさつ'
    end
    context '12歳の場合' do
      let(:age) { 12 }
      it_behaves_like '子どものあいさつ'
    end

    shared_examples '大人のあいさつ' do
      it { is_expected.to eq '僕はたろうです。'}
    end
    context '13歳の場合' do
      let(:age) { 13 }
      it_behaves_like '大人のあいさつ'
    end
    context '100歳の場合' do
      let(:age) { 100 }
      it_behaves_like '大人のあいさつ'
    end

  end
  
end



# child?もテストする

RSpec.describe User do
  describe '#greet' do
    let(:user) { User.new(name: 'たろう', age: age) }
    subject { user.greet }
    context '12歳以下の場合' do
      let(:age) { 12 }
      it { is_expected.to eq 'ぼくはたろうだよ。' }
    end
    context '13歳以上の場合' do
      let(:age) { 13 }
      it { is_expected.to eq '僕はたろうです。' }
    end
  end

  describe '#child?' do
    let(:user) { User.new(name: 'たろう', age: age) }
    subject { user.child? }
    context '12歳以下の場合' do
      let(:age) { 12 }
      it { is_expected.to eq true }
    end
    context '13歳以上の場合' do
      let(:age) { 13 }
      it { is_expected.to eq false }
    end
  end
end



# shared_context と include_context を使ってリファクタする

RSpec.describe User do
  let(:user) { User.new(name: 'たろう', age: age) }
  subject { user.greet }
  
  shared_context '12歳以下' do
    let(:age) { 12 }
  end
  shared_context '13歳以上' do
    let(:age) { 13 }
  end

  describe '#greet' do

    context '12歳以下の場合' do
      include_context '12歳以下'
      it { is_expected.to eq 'ぼくはたろうだよ。' }
    end
    context '13歳以上の場合' do
      include_context '13歳以上'
      it { is_expected.to eq '僕はたろうです。' }
    end
  end

  describe '#child?' do
    let(:user) { User.new(name: 'たろう', age: age) }
    subject { user.child? }
    context '12歳以下の場合' do
      include_context '12歳以下'
      it { is_expected.to eq true }
    end
    context '13歳以上の場合' do
      include_context '13歳以上'
      it { is_expected.to eq false }
    end

    # be_truthy / be_falsey という書き方
    context '12歳以下の場合' do
      include_context '12歳以下'
      it { is_expected.to be_truthy }
    end
    context '13歳以上の場合' do
      include_context '13歳以上'
      it { is_expected.to be_falsey }
    end
  end
end
