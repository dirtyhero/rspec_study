require 'spec_helper'

RSpec.describe 'Matcher' do
  let(:x) { [1, 2, 3] }
  describe 'eq' do
    it { expect(1 + 2).to eq 3 }
    it { expect(1 + 2).to eq 3 }
    it { expect([]).to be_empty }
  end

  describe 'be_truthy, be_falsey OKP' do
    # どちらもパスする
    it { expect(1).to be_truthy }
    it { expect(nil).to be_falsey }
  end

  xdescribe 'be_truthy, be_falsey NGP' do
    # どちらも失敗する
    it { expect(1).to eq true }
    it { expect(nil).to eq false }
  end

  # expect{ X }.to change{ Y }.from(A).to(B) ＝ 「X すると Y が A から B に変わることを期待する」
  describe 'change + from / to / by' do
    
    context '3 to 2 from to P' do
      it {expect{ x.pop }.to change{ x.size }.from(3).to(2)}
    end
    context '3 to 2 by P' do
      it {expect{ x.pop }.to change{ x.size }.by(-1)}
    end
    context '3 to 4 by P' do
      it {expect{ x.push(10) }.to change{ x.size }.by(1)}
    end
  end

  # changeを応用編
  # changeを使って削除が正常にされていることの確認を行う。
  xdescribe 'description' do
    it 'userを削除すると、userが書いたblogも削除されること' do
      user = User.create(name: 'Tom', email: 'tom@example.com')
      # user が blog を書いたことにする
      user.blogs.create(title: 'RSpec必勝法', content: 'あとで書く')

      expect{ user.destroy }.to change{ Blog.count }.by(-1)
    end
  end

  describe 'include' do
    # 1が含まれていることを検証する
    it {expect(x).to include 1}
    # 1と3が含まれていることを検証する
    it {expect(x).to include 1, 3}
  end
  
  describe 'raise_error' do
    it {expect{ 1 / 0 }.to raise_error ZeroDivisionError}
    
  end
  

  describe ShoppingCart do
    it 'nilを追加するとエラーが発生すること' do
      cart = ShoppingCart.new
      expect{ cart.add nil }.to raise_error 'Item is nil.'
    end
    it 'nilを追加するとエラーが発生すること no method errorは出ないこと' do
      cart = ShoppingCart.new
      expect{ cart.add nil }.not_to raise_error 'Nomethod errer'
    end
  end

  # 「数値 X がプラスマイナス Y の範囲内に収まっていること」を検証する
  describe 'be_within + of' do
    it '当選確率が約25%になっていること' do
      results = Lottery.generate_results(10000)
      win_count = results.count(&:win?)
      probability = win_count.to_f / 10000 * 100

      expect(probability).to be_within(1.0).of(25.0)
    end
  end

end


