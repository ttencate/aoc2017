#!/usr/bin/php
<?php

$registers = ["a" => 1];
$instructions = [];
$pc = 0;
$mul_count = 0;

$get_register = function($register) use (&$registers) {
  if (array_key_exists($register, $registers)) {
    return $registers[$register];
  } else {
    return 0;
  }
};

$set_register = function($register, $value) use (&$registers) {
  $registers[$register] = $value;
};

$constant_value = function($value) {
  return $value;
};

$set = function($register, $value_func) use (&$pc, $set_register) {
  $set_register($register, $value_func());
  $pc++;
};

$sub = function($register, $value_func) use (&$pc, $get_register, $set_register) {
  $set_register($register, $get_register($register) - $value_func());
  $pc++;
};

$mul = function($register, $value_func) use (&$pc, &$mul_count, $get_register, $set_register) {
  $set_register($register, $get_register($register) * $value_func());
  $pc++;
  $mul_count++;
};

$jnz = function($condition_func, $offset_func) use (&$pc) {
  if ($condition_func() != 0) {
    $pc += $offset_func();
  } else {
    $pc++;
  }
};

function parse_value($value) {
  global $get_register;
  global $constant_value;
  if (is_numeric($value)) {
    return bind($constant_value, intval($value));
  } else {
    return bind($get_register, $value);
  }
}

function bind($closure, ...$arguments) {
  return function() use ($closure, $arguments) {
    return $closure(...$arguments);
  };
}

while ($line = fgets(STDIN)) {
  $parts = explode(" ", rtrim($line));
  $instruction = null;
  switch ($parts[0]) {
  case "set":
    $instruction = bind($set, $parts[1], parse_value($parts[2]));
    break;
  case "sub":
    $instruction = bind($sub, $parts[1], parse_value($parts[2]));
    break;
  case "mul":
    $instruction = bind($mul, $parts[1], parse_value($parts[2]));
    break;
  case "jnz":
    $instruction = bind($jnz, parse_value($parts[1]), parse_value($parts[2]));
    break;
  }
  $instructions[] = $instruction;
}

while (array_key_exists($pc, $instructions)) {
  $instructions[$pc]();
  print_r($registers);
}
echo $mul_count, "\n";

?>
