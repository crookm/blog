---
title: Secure PHP Encryption

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.

  This was from a time when I was fascinated by login systems, and I thought I was a genius for using two salts and a hash algo nobody had heard of.

categories: Engineering
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-07T12:00:00+13:00
---

Hi,

This PHP script will take a given username and password, and output a secure hash. Simply include the script in any page that you plan on it using, and have a more secure login system!

Please note, that this script will not return the username in any way. You must supply and store that yourself.

```php
<?php

// NOTE FROM THE FUTURE:
// > Pretty safe to say that you should not use this code,
//    use the industry-standard bcrypt instead.
// > It is kept here as a record of my progress as a programmer.

function secure_enc($username, $password){
  $coresalt = "1ug7DL6aj96^FCknUujhg64pNG2!o";
  $usersalt = md5($username);
  $passlen = 6*strlen($password);
  $num1 = substr($passlen, 0, 1);
  $num2 = substr($passlen, 1, 2);
  $num3 = $num1 * $num2;
  $truesalt = sha1($num3. $usersalt. $coresalt);
  $endresult = $truesalt. ":". $password;
  for ($i=1; $i < 100; $i++)  {
    $endresult = hash("whirlpool", $endresult);
  }
  return $endresult;
}

?>
```

Sorry for the short post, I just don’t have a lot that needs doing today :)
