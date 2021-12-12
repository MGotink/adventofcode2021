class CaveFactory
  def self.create_cave(name)
    case name
    when "start"
      StartCave.new(name)
    when "end"
      EndCave.new(name)
    when /^[A-Z]+$/
      BigCave.new(name)
    when /^[a-z]+$/
      SmallCave.new(name)
    end
  end
end

class Cave
  attr_reader :name

  def initialize(name)
    @name = name
    @connections = []
  end

  def connect_to(other_cave)
    @connections << other_cave
  end

  def can_visit?
    true
  end

  def visit
  end

  def next_caves
    @connections.filter(&:can_visit?)
  end

  def ==(other)
    @name == other.name
  end

  def eql?(other)
    self == other
  end

  def hash
    @name.hash
  end

  def to_s
    "Cave #{@name}, connections: #{@connections.map(&:name).join(',')}"
  end
end

class StartCave < Cave
  def can_visit?
    false
  end
end

class EndCave < Cave
  def next_caves
    []
  end
end

class BigCave < Cave
end

class SmallCave < Cave
  def can_visit?
    !@visited
  end

  def visit
    @visited = true
  end
end

class CaveSystem
  def initialize
    @caves = []
  end

  def add_path(first_name, second_name)
    first_cave = get_or_create_cave(first_name)
    second_cave = get_or_create_cave(second_name)

    first_cave.connect_to(second_cave)
    second_cave.connect_to(first_cave)
  end

  def possible_paths
    start_cave = @caves.find { |cave| cave.name == "start" }
    paths = visit_caves([start_cave], [[]])
    paths.filter { |path| path[-1].name == "end" }
         .uniq
  end

  def to_s
    @caves.map(&:to_s).join("\n")
  end

  private

  def get_or_create_cave(name)
    cave = CaveFactory.create_cave(name)

    index = @caves.index(cave)
    if index
      @caves[index]
    else
      @caves << cave
      cave
    end
  end

  def visit_caves(caves, paths)
    caves.flat_map do |cave|
      cave = Marshal.load(Marshal.dump(cave))
      path = paths[0].dup

      path = visit_cave(cave, path)

      next_caves = cave.next_caves
      if next_caves.empty?
        paths << path
      else
        visit_caves(next_caves, [path])
      end
    end
  end

  def visit_cave(cave, path)
    path << cave
    cave.visit
    path
  end
end

cave_system = CaveSystem.new

File.readlines("12.txt", chomp: true)
    .each do |line|
      cave_system.add_path(*line.split("-"))
    end

puts cave_system.possible_paths.size

