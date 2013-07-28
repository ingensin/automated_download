<?php
$filename = '/volume1/web/GitHub/automated_download/.git';

if (file_exists($filename)) {
	$output = system('/opt/bin/git pull https://github.com/ingensin/automated_download.git');
	// echo "<pre>$output</pre>";
	// echo "EXIST";
} else {
	$output = system('/opt/bin/git init');
	// echo "<pre>$output</pre>";
	// echo "NEW";
}
// echo "\n END" 
?>
