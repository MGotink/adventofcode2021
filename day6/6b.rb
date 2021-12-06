class Ocean
  def initialize(day_counts)
    @day_counts = day_counts
  end

  def simulate(total_days)
    total_days.times do
      @day_counts = next_day(@day_counts)
    end

    @day_counts.values.sum
  end

  private

  def next_day(day_counts)
    update_day_counts = {}

    day_counts.each do |day, count|
      if day == 0
        update_day_counts[6] ||= 0
        update_day_counts[6] += count
        update_day_counts[8] = count
      else
        update_day_counts[day - 1] ||= 0
        update_day_counts[day - 1] += count
      end
    end

    update_day_counts
  end
end

day_counts = File.open("6.txt", &:readline).split(",").map(&:to_i).tally
ocean = Ocean.new(day_counts)
puts ocean.simulate(256)
