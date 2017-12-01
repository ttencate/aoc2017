WITH
digits AS (
  SELECT
    to_number(digits.digit, '9') AS digit, (digits.index - 1) AS index
  FROM
    unnest(string_to_array(btrim(pg_read_file('input', 0, 999999), E' \r\n'), NULL))
    WITH ORDINALITY AS digits(digit, index)
),
num_digits AS (
  SELECT
    COUNT(*) as num_digits
  FROM
    digits
),
next_digits AS (
  SELECT
    digit, (index + num_digits / 2) % num_digits AS index
  FROM
    digits
    JOIN num_digits ON true
)
SELECT
  SUM(digits.digit) AS answer
FROM
  digits
  JOIN next_digits USING (index)
WHERE
  digits.digit = next_digits.digit
;
