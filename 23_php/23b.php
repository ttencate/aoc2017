#!/usr/bin/php
<?php

$h = 0;
for ($b = 106500; $b <= 123500; $b += 17) {
  for ($e = 2; $e * $e <= $b; $e++) {
    if ($b % $e == 0) {
      $h++;
      break;
    }
  }
}
echo $h, "\n";

?>
