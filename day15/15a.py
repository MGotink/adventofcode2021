from pathfinding.core.diagonal_movement import DiagonalMovement
from pathfinding.core.grid import Grid
from pathfinding.finder.a_star import AStarFinder

with open("15.txt") as file:
  lines = file.readlines()
  cave_matrix = [list(map(int, list(line.rstrip()))) for line in lines]

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

