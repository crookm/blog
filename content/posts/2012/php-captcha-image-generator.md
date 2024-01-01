---
title: PHP Captcha Image Generator

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.

  If computer vision hadn't advanced so much, this script would have actually still been quite sound.

categories: Engineering
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-18T12:00:00+13:00
---

This PHP script will show you how to make and implement your own anti-spam CAPTCHA system. Though this is PHP, GD image libraries are required for it to run (installed on most hosts anyway).

This script is most likely to impact system performance, should somebody abuse it. So its recommended to have this hosted on a professional host (Eg. x10premium.com) 000webhost.com is simply not good enough. I may go into detail as to why I hate 000webhost in a different post at some point, but not now.

Here is the code.

### Generating the image (image.php)

```php
<?php 

$font = 'FONT_LOCATION.ttf'; // Make sure it is a TTF FONT!
$lineCount = 40;
$fontSize = 40;
$height = 50;
$width = 150;
$img_handle = imagecreate ($width, $height) or die ("Cannot Create image");
$backColor = imagecolorallocate($img_handle, 255, 255, 255);
$lineColor = imagecolorallocate($img_handle, 175, 238, 238);
$txtColor = imagecolorallocate($img_handle, 135, 206, 235); 

$string = "abcdefghijklmnopqrstuvwxyz0123456789";
for($i=0;$i<6;$i++){
  $pos = rand(0,36);
  $str .= $string{$pos};
}
$textbox = imagettfbbox($fontSize, 0, $font, $str) or die('Error in imagettfbbox function');
$x = ($width - $textbox[4])/2;
$y = ($height - $textbox[5])/2;
imagettftext($img_handle, $fontSize, 0, $x, $y, $txtColor, $font , $str) or die('Error in imagettftext function');
for($i=0;$i<$lineCount;$i++){
  $x1 = rand(0,$width);$x2 = rand(0,$width);
  $y1 = rand(0,$width);$y2 = rand(0,$width);
  imageline($img_handle,$x1,$y1,$x2,$y2,$lineColor);
}
header('Content-Type: image/jpeg');
imagejpeg($img_handle,NULL,100);
imagedestroy($img_handle);

session_start();
$_SESSION['img_number'] = $str;

?>
```

### Displaying the image (form.php)

```php
<form action="check.php" method="post">
  <img alt="Random Number" src="image.php"> 
  <input type="text" name="num"><br>
  <input type="submit" name="submit" value="Check">
</form>
```

### Checking the image (check.php)

```php
<?php 
session_start();

if($_SESSION['img_number'] != $_POST['num']){
  echo'That is not what the image said... Try again.';
}else{
  echo'The numbers match!';
}

?>
```

Hope you have fun!
