
# read file and take contents

require 'rspec'
require 'pry'

def execute(filename:)
  input = File.read(filename)
  calculate_zeroes(starting_position: 50, input:)
end

def calculate_zeroes(starting_position:, input:)
  position = starting_position
  zero_hits = 0
  lines = input.lines 
  lines.each do |line|
    direction, movement_amount = line[0], line[1..].to_i
    initial_position = position

    # change direction for left
    movement_amount *= -1 if direction == 'L'
    
    # move to new position based on direction and movement amount
    pre_adjusted_calculated_position = movement_amount + position
    quotient, remainder = (pre_adjusted_calculated_position).divmod(100)
    
    # move to intended position
    position = remainder

    # count times zero was crossed when moving position
    boundary_cross_amount = direction == 'L' && initial_position.zero? ? quotient.abs - 1 : quotient.abs

    should_count_boundary_cross = boundary_cross_amount > 0
    if should_count_boundary_cross
      zero_hits += boundary_cross_amount
    end

    landed_on_zero = position.zero?
    should_count_for_total = landed_on_zero && (boundary_cross_amount.zero? || ((initial_position != position) && direction == 'L'))
    zero_hits +=1 if should_count_for_total

    # debug_vars = {
    #   line:,
    #   pre_adjusted_calculated_position:,
    #   quotient:,
    #   boundary_cross_amount:,
    #   remainder:,
    #   initial_position:,
    #   position:,
    #   zero_hits:,
    #   landed_on_zero:,
    #   should_count_for_total:,
    #   should_count_boundary_cross:
    # }
    # pp vars
    # binding.pry
  end

  zero_hits
end

# puts execute(filename: 'input.txt')

describe('#execute') do

  it 'should satisfy the example' do
    expect(execute(filename: 'example.txt')).to eq 6
  end

  it 'should be correct for the real input' do
    expect(execute(filename: 'input.txt') > 6545).to eq true
  end

  # refactoring regression test
  it 'should stay correct' do
    expect(execute(filename: 'input.txt')).to eq 6638
  end
end

describe('#calculate_zeroes') do
  it 'should allow for left navigation to 0' do
    input = "L50"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 1
  end

  it 'should allow for left navigation (wrap around)' do
    input = "L100"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 1
  end


  it 'should allow for right navigation (wrapping around)' do
    input = "R100"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 1
  end

  it 'should allow for multiple right navigations to land on 0' do
    input ="R10\nR40"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 1
  end

  it 'should allow for boundary crosses being counted even when landing on 0 (R) ' do
    input = "R150"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 2
  end

    it 'should allow for boundary crosses being counted even when landing on 0 (L) ' do
    input = "L150"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 2
  end

   it 'should calculate correctly when boundary crossing and not landing on zero (r)' do
    input = "R151"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 2
  end

  it 'should calculate correctly when boundary crossing and not landing on zero (L)' do
    input = "L151"
    expect(calculate_zeroes(starting_position: 50, input:)).to eq 2
  end


  it 'should calculate correctly when starting at 0 wrapping around not landing on 0 (L)' do
    input = "L5"
    expect(calculate_zeroes(starting_position: 0, input:)).to eq 0
  end

  it 'should calculate correctly when starting at 0 (r)' do
    input = "R5"
    expect(calculate_zeroes(starting_position: 0, input:)).to eq 0
  end


  it 'should calculate correctly when starting at 0 wrapping around not landing on 0 (R)' do
    input = "R105"
    expect(calculate_zeroes(starting_position: 0, input:)).to eq 1
  end
  
  it 'should calculate correctly when starting at 0 wrapping around multiple times' do
    input = "L105"
    expect(calculate_zeroes(starting_position: 0, input:)).to eq 1
  end

  it 'should calculate correctly when starting at 0 wrapping around to land on 0 (L)' do
    input = "L100"
    expect(calculate_zeroes(starting_position: 0, input:)).to eq 1
  end

  it 'should calculate correctly when starting at 0 wrapping around to land on 0 (R)' do
    input = "R100"
    expect(calculate_zeroes(starting_position: 0, input:)).to eq 1
  end
end
