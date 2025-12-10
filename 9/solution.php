<?php

$filename = "input.txt";
$file = fopen($filename, "r") or die("Unable to open file!");
$data = fread($file, filesize($filename));
fclose($file);

$lines = array_filter(explode("\n", $data), function ($line) {
    return !empty($line);
});

$data = array_map(function ($line) {
    $raw_numbers = explode(",", $line);
    $number1 = intval($raw_numbers[0]);
    $number2 = intval($raw_numbers[1]);
    return [$number2, $number1];
}, $lines);

$result = 0;

for ($i = 0; $i < count($data); $i++) {
    for ($j = 0; $j < $i; $j++) {
        $area = (abs($data[$i][0] - $data[$j][0]) + 1) * (abs($data[$i][1] - $data[$j][1]) + 1);
        if ($area > $result) {
            $result = $area;
        }
    }
}

echo "Part 1 answer: " . $result . PHP_EOL;

$data_set = [];
foreach ($data as $point) {
    $data_set[$point[0] . ',' . $point[1]] = true;
}

$x_edges = [];
$y_edges = [];

$last = end($data);

$global_max_x = max(array_column($data, 0)) + 1;
$global_max_y = max(array_column($data, 1)) + 1;

foreach ($data as $point) {
    if ($point[0] == $last[0]) {
        if (!isset($x_edges[$point[0]])) {
            $x_edges[$point[0]] = [];
        }
        $x_edges[$point[0]][] = [min($point[1], $last[1]), max($point[1], $last[1])];
    } else {
        if (!isset($y_edges[$point[1]])) {
            $y_edges[$point[1]] = [];
        }
        $y_edges[$point[1]][] = [min($point[0], $last[0]), max($point[0], $last[0])];
    }
    $last = $point;
}


$is_in_cache = [];

function is_in($point)
{
    global $x_edges, $y_edges, $global_max_x, $global_max_y, $data_set, $is_in_cache;
    $is1 = false;
    $is2 = false;
    $is3 = false;
    $is4 = false;


    if (isset($is_in_cache[$point[0] . ',' . $point[1]])) {
        return $is_in_cache[$point[0] . ',' . $point[1]];
    }

    for ($x = $point[0]; $x <= $global_max_x; $x++) {
        if (isset($data_set[$x . ',' . $point[1]])) {
            $is1 = true;
            break;
        }
        if (isset($is_in_cache[$x . ',' . $point[1]]) && $is_in_cache[$x . ',' . $point[1]]) {
            $is1 = true;
            break;
        }
        if (!isset($x_edges[$x])) {
            continue;
        }
        $edge = array_find($x_edges[$x], function ($edge) use ($x, $point) {
            return $edge[0] <= $point[1] && $edge[1] >= $point[1];
        });
        if ($edge) {
            $is1 = true;
            break;
        }
    }

    if (!$is1) {
        $is_in_cache[$point[0] . ',' . $point[1]] = $is1;
        return false;
    }

    for ($x = $point[0]; $x >= 0; $x--) {
        if (isset($data_set[$x . ',' . $point[1]])) {
            $is2 = true;
            break;
        }
        if (isset($is_in_cache[$x . ',' . $point[1]]) && $is_in_cache[$x . ',' . $point[1]]) {
            $is2 = true;
            break;
        }
        if (!isset($x_edges[$x])) {
            continue;
        }
        $edge = array_find($x_edges[$x], function ($edge) use ($x, $point) {
            return $edge[0] <= $point[1] && $edge[1] >= $point[1];
        });
        if ($edge) {
            $is2 = true;
            break;
        }
    }

    if (!$is2) {
        $is_in_cache[$point[0] . ',' . $point[1]] = false;
        return false;
    }

    for ($y = $point[1]; $y <= $global_max_y; $y++) {
        if (isset($data_set[$point[0] . ',' . $y])) {
            $is3 = true;
            break;
        }
        if (isset($is_in_cache[$point[0] . ',' . $y]) && $is_in_cache[$point[0] . ',' . $y]) {
            $is3 = true;
            break;
        }
        if (!isset($y_edges[$y])) {
            continue;
        }
        $edge = array_find($y_edges[$y], function ($edge) use ($y, $point) {
            return $edge[0] <= $point[0] && $edge[1] >= $point[0];
        });
        if ($edge) {
            $is3 = true;
            break;
        }
    }

    if (!$is3) {
        $is_in_cache[$point[0] . ',' . $point[1]] = false;
        return false;
    }

    for ($y = $point[1]; $y >= 0; $y--) {
        if (isset($data_set[$point[0] . ',' . $y])) {
            $is4 = true;
            break;
        }
        if (isset($is_in_cache[$point[0] . ',' . $y]) && $is_in_cache[$point[0] . ',' . $y]) {
            $is4 = true;
            break;
        }
        if (!isset($y_edges[$y])) {
            continue;
        }
        $edge = array_find($y_edges[$y], function ($edge) use ($y, $point) {
            return $edge[0] <= $point[0] && $edge[1] >= $point[0];
        });
        if ($edge) {
            $is4 = true;
            break;
        }
    }

    $is_in_cache[$point[0] . ',' . $point[1]] = $is4;
    return $is4;
}

$result = 0;

for ($i = 0; $i < count($data); $i++) {
    for ($j = 0; $j < $i; $j++) {
        $area = (abs($data[$i][0] - $data[$j][0]) + 1) * (abs($data[$i][1] - $data[$j][1]) + 1);
        if ($area > $result) {
            $min_x = min($data[$j][0], $data[$i][0]);
            $max_x = max($data[$j][0], $data[$i][0]);
            $min_y = min($data[$j][1], $data[$i][1]);
            $max_y = max($data[$j][1], $data[$i][1]);
            $valid = true;
            $are_corners_in = is_in([$min_x, $min_y]) && is_in([$max_x, $min_y]) && is_in([$min_x, $max_y]) && is_in([$max_x, $max_y]);
            if (!$are_corners_in) {
                continue;
            }
            for ($x = $min_x; $x <= $max_x; $x++) {
                $is_point_in = is_in([$x, $min_y]) && is_in([$x, $max_y]);
                if (!$is_point_in) {
                    $valid = false;
                    break;
                }
            }
            if (!$valid) {
                continue;
            }
            for ($y = $min_y; $y <= $max_y; $y++) {
                $is_point_in = is_in([$min_x, $y]) && is_in([$max_x, $y]);
                if (!$is_point_in) {
                    $valid = false;
                    break;
                }
            }
            if (!$valid) {
                continue;
            }
            $result = $area;
        }
    }
}

echo "Part 2 answer: " . $result . PHP_EOL;
