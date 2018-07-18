class PriceCalculator
  attr_reader :best_plan
  def initialize
    #sym key: [price, happy_price]
    @price_table = {:a => [6888, nil], :b => [3300, nil], :c => [6888, 4000], :d => [5000, nil], :e => [4500, nil], :f => [6555, nil]}
    #string key: []
    @combo_table = {'a,b' => 7888}
    #for dp @cache
    @cache = {}
    @best_plan = []
    @current_plan = []
  end

  def calculate_without_b3g1f products
    # return @cache[products] unless @cache[products].nil?
    return 0, [] if products.count == 0
    ans = 2 ** 31 - 1
    product = products[0]
    single = (@price_table[product][1].nil? ? @price_table[product][0] : @price_table[product][1])
    single_left = products.clone.drop(1)
    combos = @combo_table.keys.select {|e| e.include? product.to_s}
    total_price_single, single_plan = calculate_without_b3g1f(single_left)
    plan = []
    if single + total_price_single < ans 
      ans = single + total_price_single
      plan = [product] + single_plan
    end
    unless combos.empty?
      combos.each do |c|
        next unless products.include?(c.split(',')[0].to_sym) && products.include?(c.split(',')[1].to_sym)
        combo = @combo_table[c]
        combo_left = products.clone
        combo_left.delete_at combo_left.index(c.split(',')[0].to_sym)
        combo_left.delete_at combo_left.index(c.split(',')[1].to_sym)
        total_price_combo, combo_plan = calculate_without_b3g1f(combo_left)
        if combo + total_price_combo < ans 
          ans = combo + total_price_combo
          plan = [c] + combo_plan
        end
      end
    end
    # @cache[products] = ans
    return ans, plan
  end

  def calculate products
    max_free = products.length / 3
    min_price = 2 ** 31 - 1
    for i in 0..max_free do
      permutations = helper(products, i)
      min_b3g1f = 2 ** 31 - 1
      permutations.each do |permutation|
        @current_plan = [permutation.map { |e| products[e] }]
        permutation_price = 0
        permutation.map { |e| @price_table[products[e]][0] }.sort.drop(i).each {|e| permutation_price = permutation_price + e}
        left = products.clone
        permutation.each {|e| left[e] = nil }
        left.compact!
        price, plan = calculate_without_b3g1f(left)
        total_price = permutation_price + price
        if min_b3g1f >= total_price
          min_b3g1f = total_price
          @current_plan = @current_plan + plan
        end
      end
      if min_b3g1f < min_price
        min_price = min_b3g1f
        @best_plan = @current_plan
      end
    end
    min_price
  end

  def helper products, free_num
    total_num = free_num * 3
    permutations = []
    get_permutations [], 0, permutations, total_num, products.count - 1
    permutations
  end

  def get_permutations current_array, current_index, permutations, total_num, products_count
    if current_array.count == total_num 
      permutations << current_array
      return
    end
    for i in current_index..products_count do
      get_permutations current_array + [i], i + 1, permutations, total_num, products_count
    end 
  end

end
# permutations = []
# get_permutations [], 0, permutations, 3 ,3
# puts "answer is " + permutations.to_s
c = PriceCalculator.new
puts(c.calculate [:a, :b, :c, :d, :e, :f])
puts(c.best_plan.to_s)