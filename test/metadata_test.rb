require 'test_helper'

class MetadataTest < MiniTest::Unit::TestCase

  def test_experiment_metadata
    experiment = Experiments::Experiment.new('experiment metadata') do
      name "Metadata test"
      description "For testing metadata functionality"
      screenshot "http://example.com/image.png"
    end

    assert_equal "Metadata test", experiment.name
    assert_equal "For testing metadata functionality", experiment.description
    assert_equal "http://example.com/image.png", experiment.screenshot

    assert_equal experiment.metadata, {
      :name => 'Metadata test',
      :description => 'For testing metadata functionality',
      :screenshot => 'http://example.com/image.png'
    }
  end

  def test_group_metadata
    experiment = Experiments::Experiment.new('group metadata') do
      groups do
        group :all, 100 do
          name "Group metadata test"
          description "For testing metadata functionality"
          screenshot "http://example.com/image.png"
        end
      end
    end

    assert_equal "Group metadata test", experiment.group(:all).name
    assert_equal "For testing metadata functionality", experiment.group(:all).description
    assert_equal "http://example.com/image.png", experiment.group(:all).screenshot

    assert_equal experiment.group(:all).metadata, {
      :name => 'Group metadata test',
      :description => 'For testing metadata functionality',
      :screenshot => 'http://example.com/image.png'
    }
  end
end