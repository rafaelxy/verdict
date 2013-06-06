require 'digest/md5'

module Experiments::Segmenter

  class Base

    attr_reader :experiment, :groups

    def initialize(experiment)
      @experiment = experiment
      @groups = {}
    end

    def verify!
    end

    def group(identifier, subject, context)
      raise NotImplementedError
    end
  end

  class StaticPercentage < Base
    def initialize(experiment)
      super
      @total_percentage_segmented = 0
    end

    def verify!
      raise Experiments::SegmentationError, "Should segment exactly 100% of the cases, but segments add up to #{@total_percentage_segmented}%." if @total_percentage_segmented != 100
    end

    def group(label, size, &block)
      percentage = size.kind_of?(Hash) && size[:percentage] ? size[:percentage] : size
      n = case percentage
        when :rest; 100 - @total_percentage_segmented
        when :half; 50
        when Integer; percentage
        else Integer(percentage)
      end
        
      @groups[label] = @total_percentage_segmented ... (@total_percentage_segmented + n)
      @total_percentage_segmented += n
    end

    def assign(identifier, subject, context)
      percentile = Digest::MD5.hexdigest("#{@experiment.name}#{identifier}").to_i(16) % 100
      segment_label, _ = groups.find { |_, percentile_range| percentile_range.include?(percentile) }
      raise Experiments::SegmentationError, "Could not get segment for subject #{identifier.inspect}!" unless segment_label
      segment_label
    end
  end
end
