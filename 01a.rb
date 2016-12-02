puts gets
  .strip
  .split(", ")
  .map { |command| [command[0], command[1..-1].to_i] }
  .inject([0, -1, 0, 0]) { |(dx, dy, x, y), (dir, len)| dir == 'L' ? [dy, -dx, x + len * dy, y + len * -dx] : [-dy, dx, x + len * -dy, y + len * dx] }[2..3]
  .map(&:abs)
  .inject(:+)
