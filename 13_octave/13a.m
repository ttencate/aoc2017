input = reshape(scanf('%d: %d'), 2, []);
depths = input(1, :);
ranges = input(2, :);
total_depth = depths(length(depths));
severities = depths .* ranges;
caught = mod(depths, 2 * ranges - 2) == 0;
disp(sum(caught .* severities));
