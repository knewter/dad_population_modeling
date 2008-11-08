# A PopulationBucket consists of an inflow equation and an outflow equation,
# each in terms of a given step length.
#
# For example, imagine a universe in which two people exist, and they can have
# children once every nine months.  None of these people will ever die.  Also, 
# this society is entirely monogamous.  Then the PopulationBucket parameters 
# for this system would look something like:
# 
# {
#   :initial_population => 2,
#   :inflow  => lambda{|b| 12/9 * (b.population/2.0) },
#   :outflow => lambda{ 0 }
# }
#
# NOTE: The above-described bucket can be found in the population_growth_tests
#
class PopulationBucket
  attr_accessor :population, :inflow, :outflow, :options

  VALIDATIONS = {
    :initial_population => "You must pass in an initial population",
    :inflow => "You must pass in an inflow equation",
    :outflow => "You must pass in an outflow equation"
  }

  def initialize options={}
    @options = options
    VALIDATIONS.each_pair do |key, value|
      raise value unless @options[key]
    end
    reset
  end

  def reset
    @population = @options[:initial_population].to_f
    @inflow     = @options[:inflow]
    @outflow    = @options[:outflow]
  end

  def population_at_step(step_number)
    reset
    step_number.times do |i|
      add_inflow
      subtract_outflow
    end
    @population
  end

  def add_inflow
    @population += @inflow.call(self)
  end

  def subtract_outflow
    @population -= @outflow.call(self)
  end
end
