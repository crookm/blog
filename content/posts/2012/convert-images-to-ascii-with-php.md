---
title: Convert Images to ASCII With PHP

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.

  I'm not convinced I did this all by myself, probably bodging from across the internet - but yeah it's interesting.

categories: Development
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-30T12:01:00+13:00
---

Some forums, bulletin boards, blogs, and other text platforms allow basic BBcode but are strict against images. With this simple PHP script, you can convert any JPG image to HTML (or BBcode) text.

```php
<?php

function getext($filename) {
  $pos = strrpos($filename,'.');
  $str = substr($filename, $pos);
  return $str;
}

$image = 'image.jpg';
$ext = getext($image);
if($ext == ".jpg"){
  $img = imagecreatefromjpeg($image);
}
else{
  echo'Wrong File Type';
}

$width = imagesx($img);
$height = imagesy($img);

for($h=0;$h<$height;$h++){
  for($w=0;$w<=$width;$w++){
    $rgb = imagecolorat($img, $w, $h);
    $r = ($rgb >> 16) & 0xFF;
    $g = ($rgb >> 8) & 0xFF;
    $b = $rgb & 0xFF;
    if($w == $width){
      echo '<br>';
    }else{
      echo '<span style="color:rgb('.$r.','.$g.','.$b.');">#</span>';
    }
  }
}

?>
```

**NOTE**: Like all GD-based scripts, this needs a really decent server to adequately run without interference.
