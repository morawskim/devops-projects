<?php

echo "file_put_contents" . PHP_EOL;
file_put_contents(
    '/var/www/html/foo/test-file-put-contents.txt',
    'test-file-pus-contents' . PHP_EOL,
);

echo "file_put_contents append" . PHP_EOL;
file_put_contents(
    '/var/www/html/test-file-put-contents-append.txt',
    'test-file-pus-contents' . PHP_EOL,
    FILE_APPEND
);


echo "fopen & fwrite" . PHP_EOL;
$handler = fopen('/var/www/html/foo/test-fopen.txt', 'w+');
fwrite($handler, 'lorem');
fwrite($handler, PHP_EOL);
fclose($handler);
