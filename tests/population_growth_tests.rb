require 'test/unit'
require 'lib/population_bucket'

class PopulationGrowthTests < Test::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_existence_of_class
    assert PopulationBucket
  end

  def test_basic_bucket_works
    # Test that we can create a bucket that starts with two people, grows
    # by one person per step, shrinks by zero people per step, and that
    # successfully has three people in it at step 1
    bucket = PopulationBucket.new :initial_population => 2, :inflow => lambda{ 1 }, :outflow => lambda{ 0 }
    assert_equal 3, bucket.population_at_step(1)
  end

  def test_bucket_with_population_dependent_function
    # We should be able to create a bucket that grows at a rate of
    # ((9/12) * (bucket.population / 2) (simulating a monogamous
    # society having children as quickly as they possibly can)
    #
    # We're ignoring death for now.
    bucket = PopulationBucket.new({
      :initial_population => 2.0,
      :inflow  => lambda{|b| (12.0/9.0) * (b.population/2.0) },
      :outflow => lambda{ 0 }
    })
    assert_equal ((1.0 * 12.0/9.0) + 2.0), bucket.population_at_step(1)
  end
end
