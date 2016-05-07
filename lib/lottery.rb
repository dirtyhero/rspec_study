class Lottery
  KUJI = %w(あたり はずれ はずれ はずれ)
  def initialize
    @result = KUJI.sample
  end
  def win?
    @result == 'あたり'
  end
  def self.generate_results(count)
    Array.new(count){ self.new }
  end
end
