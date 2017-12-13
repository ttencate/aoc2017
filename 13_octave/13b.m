input = reshape(scanf('%d: %d'), 2, []);
depths = input(1, :);
ranges = input(2, :);
periods = 2 * ranges - 2;
delay = 0;
while ~all(bsxfun(@mod, bsxfun(@plus, delay, depths), periods))
  delay += 1;
endwhile;
disp(delay);
