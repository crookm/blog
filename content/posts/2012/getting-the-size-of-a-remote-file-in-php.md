---
title: Getting the Size of a Remote File in PHP

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.
  
  I was still new to PHP and programming in general, so I believed that complex code was better code.

categories: Engineering
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-06T12:01:00+13:00
---

This script gets the external file size of anything. This script is really good for forum systems, or anything with a limit of file size.

Here:

```php
<?php

// NOTE FROM THE FUTURE:
// > This code is actually insecure, do not use it -
//    bonus points if you can find the vulnerabilities.
// > It is kept here as a record of my progress as a programmer.

$url = "https://mattcrook.io/favicon.ico"; // Put the URL you want to get the filesize of here

function getRemoteFileSize($urll){
  $parsed = parse_url($urll);
  $host = $parsed["host"];
  $fp = @fsockopen($host, 80, $errno, $errstr, 20);
  if(!$fp){
    return false;
  }else{
    @fputs($fp, "HEAD $urll HTTP/1.1\r\n");
    @fputs($fp, "HOST: $host\r\n");
    @fputs($fp, "Connection: close\r\n\r\n");
    $headers = "";
    while(!@feof($fp)){
      $headers .= @fgets ($fp, 128);
    }
  }
  @fclose ($fp);
  $return = false;
  $arr_headers = explode("\n", $headers);
  foreach($arr_headers as $header){
    $s = "Content-Length: ";
    if(substr(strtolower ($header), 0, strlen($s)) == strtolower($s)) {
      $return = trim(substr($header, strlen($s)));
      break;
    }
  }
  if($return){
    $size = round($return / 1024, 2);
    $sz = "KB";
    if ($size > 1024) {
      $size = round($size / 1024, 2);
      $sz = "MB";
    }
    $return = "$size $sz";
  }
  return $return;
}

echo "Total filesize: " . getRemoteFileSize($url) .""; // Final

?>
```

Hope this helps out :)
