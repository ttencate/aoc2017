input = reshape(scanf('%d: %d'), 2, []);
depths = input(1, :);
ranges = input(2, :);
total_depth = depths(length(depths));
severities = depths .* ranges;
delay = 0;
while sum(mod(delay + depths, 2 * ranges - 2) == 0) > 0
  delay += 1;
endwhile;
disp(delay);
