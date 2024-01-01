---
title: PHP Calculator

description: |
  A post rescued from an old blog of mine from the Wayback Machine. I was 14 when I wrote this, so it's a bit cringy.

categories: Engineering
tags:
  - php

importSource: hlx
importDate: 2024-01-01T23:00:00+13:00

date: 2012-11-06T12:02:00+13:00
---

Today I have conjured a small php calculator script, coded in PHP. There are no limits, and I made sure its a little less hackable :)

Well here it is.

```php
<?php

function clean($input){ // Clean the input
	$input = strip_tags($input);
	$input = htmlentities($input);
	return $input;
}

$submit = clean($_POST['submit']);
$value1 = clean($_POST['value1']);
$value2 = clean($_POST['value2']);
$action = clean($_POST['action']);
if($_POST['submit']){ // If they click the button, do this
  if($action === 'plus'){
    $result = $value1+$value2; // If the user selected an addition sum
  }
  else if($action === 'min'){
    $result = $value1 - $value2; // If the user selected a subtraction sum
  }
  else if($action === 'keer'){
    $result = $value1 * $value2; // If the user selected a multiplication sum
  }
  else if($action === 'delen'){
    $result = $value1 / $value2; // If the user selected a division sum
  }
  else if($action === 'procent'){
    $result = $value1 % $value2;  // Work with percentages
  }
}

// Below is the HTML stuff, that the user will see.
?>
<html>
<head>
<title>Calculator</title>
</head>
<body>
<form method="POST" action="calculator.php">
  <p>
    <input  type="text" name="value1" value="fill something in here" onFocus="if(this.value == 'fill something in here') {this.value = '';}" onBlur="if (this.value == '') {this.value = 'fill something in here';}" />
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <select name="action">
      <option value="plus">+</option>
      <option value="min">-</option>
      <option value="keer">*</option>
      <option value="delen">/</option>
      <option value="procent">%</option>
    </select>
    <input type="text" name="value2" value="fill something in here" onFocus="if(this.value == 'fill something in here') {this.value = '';}" onBlur="if (this.value == '') {this.value = 'fill something in here';}" />
    &nbsp;&nbsp; </p>
  <br />
  <br />
  <input type="submit" name="submit" value="Calculate!" />
</form>
<br />
<?php echo $result; ?>
</body>
</html>
```
