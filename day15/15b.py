from pathfinding.core.diagonal_movement import DiagonalMovement
from pathfinding.core.grid import Grid
from pathfinding.finder.a_star import AStarFinder

with open("15.txt") as file:
  lines = file.readlines()
  cave_template = [list(map(int, list(line.rstrip()))) for line in lines]

cave_matrix = [row[:] for row in cave_template]

rows = len(cave_template)
cols = len(cave_template[0])

for i in range(4):
  for y, line in enumerate(cave_template):
    for x, cost in enumerate(cave_template[y]):
      new_cost = cost + i + 1
      cave_matrix[y].append((new_cost - 1) % 9 + 1)

for i in range(4):
  for y in range(rows):
    line = cave_matrix[y]
    new_line = []
    for x, cost in enumerate(cave_matrix[y]):
      new_cost = cost + i + 1
      new_line.append((new_cost - 1) % 9 + 1)

    cave_matrix.append(new_line)

grid = Grid(matrix=cave_matrix)

start = grid.node(0, 0)
end = grid.node(len(cave_matrix) - 1, len(cave_matrix[0]) - 1)

finder = AStarFinder(diagonal_movement=DiagonalMovement.never)
path, runs = finder.find_path(start, end, grid)

print(grid.grid_str(path=path, start=start, end=end))

def get_cost(coordinate):
  return cave_matrix[coordinate[1]][coordinate[0]]

costs = list(map(get_cost, path))
print(sum(costs) - cave_matrix[0][0])

