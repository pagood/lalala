#sym key: [price, happy_price]
price_table = {}
#string key: []
combo_table = {}
#for dp cache
cache = {}

def calculate_without_b3g1f products
  return cache[products] unless cache[products].nil?
  return 0 if products.count == 0
  ans = 2 ** 31 - 1
  product = products[0]
  single = (price_table[product][1].nil? ? price_table[product][0] : price_table[product][1])
  single_left = products.clone.drop(1)
  combos = combo_table.keys.select {|e| e.include? product.to_s}
  unless combos.empty?
    combos.each do |c|
      combo = combo_table[c]
      combo_left = products.clone
      combo_left.delete_at combo_left.index(c.split(',')[0].to_sym)
      combo_left.delete_at combo_left.index(c.split(',')[1].to_sym)
      ans = [ans, [single + calculate_without_b3g1f(single_left), combo + calculate_without_b3g1f(combo_left)].min].min
    end
  end
  cache[products] = ans
  ans 
end

def calculate products
  max_free = products.lenght / 3
  min_price = 2 ** 31 - 1
  for i in 1..max_free do
    permutations = helper(products, i)
    min_b3g1f = 2 ** 31 - 1
    permutations.each do |permutation|
      permutation_price = permutation.map { |e| price_table[products[e]][0] }.sort.drop(2).sum
      left = products.clone
      permutation.each {|e| left[e] = nil }
      left.compact!
      min_b3g1f = [min_b3g1f, permutation_price + calculate_without_b3g1f(left)].min
    end
    min_price = [min_price, min_b3g1f]
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


# permutations = []
# get_permutations [], 0, permutations, 3 ,3
# puts "answer is " + permutations.to_s
