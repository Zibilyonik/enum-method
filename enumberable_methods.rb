# frozen_string_literal: true

# rubocop:disable Style/CaseEquality, Style/For, Style/Documentation, Style/ExplicitBlockArgument, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength

module Enumerable
  def my_each
    return enum_for unless block_given?

    for item in self do
      yield item
    end
  end

  def my_each_with_index
    return enum_for unless block_given?

    if is_a?(Hash)
      for item in self do
        yield(item, self[item])
      end
    elsif is_a?(Range)
      arr = *self
      for item in arr do
        yield(item, arr.index(item))
      end
    else
      for item in self do
        yield(item, index(item))
      end
    end
  end

  def my_select
    return enum_for unless block_given?

    arr = []
    for item in self do
      arr << item if yield(item)
    end
    arr
  end

  def my_all?(pattern = nil)
    return true if length <= 0

    if pattern.nil? && !block_given?
      my_each { |item| return false unless item }
      return true
    end
    if pattern
      my_each { |item| return false unless item === pattern }
      return true
    end
    my_each { |item| return false if yield(item) === false }

    true
  end

  def my_any?(pattern = nil)
    return false if length <= 0

    if pattern.nil? && !block_given?
      my_each { |item| return true if item }
      return false
    end
    if pattern
      my_each { |item| return true if item === pattern }
      return false
    end
    my_each { |item| return true if yield(item) === true }

    false
  end

  def my_none?(pattern = nil)
    return true if length <= 0

    if pattern.nil? && !block_given?
      my_each { |item| return false if item }
      return true
    end

    if pattern
      my_each { |item| return false if item === pattern }
      return true
    end
    my_each { |item| return false if yield(item) === true }

    true
  end

  def my_count(number = nil)
    unless number.nil?
      i = 0
      for item in self do
        i += 1 if item == number
      end
      return i
    end
    return length unless block_given?

    my_select { |x| yield(x) }.length
  end

  def my_inject(*args)
    memo = 0
    if args[0].is_a?(Integer)
      memo = args.first
      args.shift
    end
    sym = args.first if args[0].is_a?(Symbol)
    if sym
      my_each { |item| memo = memo ? memo.send(sym, item) : item }
    elsif block_given?
      my_each { |item| memo = yield(memo, item) }
    end
    memo
  end

  def my_map(proc = nil)
    return enum_for unless block_given?

    fin = []
    if proc
      my_each { |x| fin << proc.call(x) }
    else
      my_each { |x| fin << yield(x) }
    end
    fin
  end

  def multiply_els
    my_inject(1, :*)
  end
end

# Arr = [20, 50, 120, 600, 21]
# Arr2 = %w[a b c d e f]
# Hash1 = {cat: 3, dog: 4, rat: 5}
# Arr.my_each{|x| p x + 5}
# p Hash1.my_each
# p (0..9).my_each
# p Arr.my_each{|x| x+5}
# Arr.my_each_with_index{|x, i| p "number: #{x+5}, index: #{i}"}
# p Hash1.my_each_with_index{|key, value| key = value}
# p (0..9).my_each_with_index{|x, i| x+i}
# p Arr.my_select{|x| x.even?}
# p Arr.my_all?{|x| x.even?}
# p Arr2.my_all?
# p Arr.my_any?{|x| x < 100}
# p Arr2.my_any?
# p Arr.my_none?{|x| x < 20}
# p Arr.my_count
# p Arr2.my_count
# p Arr2.my_count("a")
# p Arr2.my_count{|x| x[/[[:upper:]]/] }
# p Arr.my_count(20)
# p Arr.my_count{|x| x % 3 == 2}
# p Arr.my_inject(5, :*)
# p Arr.my_map{|x| x+5}
# p Arr2.my_map{|x| x.upcase}
# p Arr.multiply_els
# rubocop:enable Style/CaseEquality, Style/For, Style/Documentation, Style/ExplicitBlockArgument, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength
