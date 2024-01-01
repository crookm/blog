---
title: Validate if Files Are Images in PHP

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.

  I think I was just excited to figure this out, it's not really that useful. Even the docs I link to say not to use it for this purpose.

categories: Engineering
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-30T12:00:00+13:00
---

If you host image files, eg imgur.com, then you're going to want to make sure its actually an image that the public is uploading, and not a malicious PHP file.

This PHP function looks for any image mimetype, and gets its width and height. If it isn't an image mimetype, then the function returns false. We can simply use this function to catch if the image uploaded will return true or false.

More on [getimagesize()](https://php.net/manual/function.getimagesize.php).

```php
<?php

// NOTE FROM THE FUTURE:
// > The PHP docs actually say not to use this function for this purpose.
// > It is kept here as a record of my progress as a programmer.

function isImage($img){
  if(!getimagesize($img)){
    return FALSE;
  }else{
    return TRUE;
  }
}

?>
```
