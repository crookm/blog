---
title: Overlay Watermarks on Images in PHP

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.

categories: Engineering
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-07T12:01:00+13:00
---

Hi,

This PHP script will overlay an image on an image. This is useful for photography galleries and blogs.

```php
<?php

// NOTE FROM THE FUTURE:
// > Working with files is risky business, it is best to make use
//    of a service dedicated to this sort of thing.
// > It is kept here as a record of my progress as a programmer.

function add_watermark($image) {
  $overlay = 'OVERLAY_IMAGE_HERE.png';

  $w_offset = 0;
  $h_offset = 0;

  $extension = strtolower(substr($image, strrpos($image, ".") +1));

  switch ($extension) {
    case 'jpg':
      $background = imagecreatefromjpeg($image);
      break;
    case 'jpeg':
      $background = imagecreatefromjpeg($image);
      break;
    case 'png':
      $background = imagecreatefrompng($image);
      break;
    default:
      die("Image type not supported");
  }

  $base_width = imagesx($background);
  $base_height = imagesy($background);
  imagealphablending($background, true);

  $overlay = imagecreatefrompng($overlay);

  imagesettile($background, $overlay);

  // Make the image repeat
  imagefilledrectangle($background, 0, 0, $base_width, $base_height, IMG_COLOR_TILED);
  header('Content-type: image/png');
  imagepng($background);
}

echo add_watermark('IMAGE_FILE_HERE.png'); // Insert an image here.

?>
```

**NOTE**: This script does not cache files. I may post a tutorial later about caching dynamic files.
