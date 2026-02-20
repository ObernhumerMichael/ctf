<?php
$data = ['passwd' => [1, 2]];
$query = http_build_query($data);
echo $query;
