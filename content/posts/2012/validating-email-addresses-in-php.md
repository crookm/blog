---
title: Validating Email Addresses in PHP

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.

  It works well, because the built-in PHP filter_var function is used - imagine that!

categories: Engineering
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-20T12:00:00+13:00
---

This script will validate emails with PHP, good for anything like contact forms where you want to be able to contact them afterward.

### Typical

```php
<?php

if (isset($_POST['email'])) {
  $email = $_POST['email'];
  if (filter_var($email, FILTER_VALIDATE_EMAIL)){
    echo 'Valid :)';
  } else {
    echo 'Invalid :/';
  }
}

?>

<form action="" method="post">
  Email: <input type="text" name="email" value=" <?php echo $_POST['email']; ?> ">
  <input type="submit" value="Check Email">
</form>
```
