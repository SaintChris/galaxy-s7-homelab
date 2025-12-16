<?php
echo "<h1>Galaxy S7 Server Status</h1>";
echo "<h2>System Information:</h2>";
echo "<pre>";
system("uname -a");
echo "\n\n";
system("uptime");
echo "\n\n";
echo "Memory: ";
system("free -h | grep Mem:");
echo "\n";
echo "Disk: ";
system("df -h /data | tail -1");
echo "</pre>";

echo "<h2>Services:</h2>";
echo "<ul>";
echo "<li>NGINX: " . shell_exec("nginx -v 2>&1") . "</li>";
echo "<li>Node.js: " . shell_exec("node --version") . "</li>";
echo "<li>Python: " . shell_exec("python --version 2>&1") . "</li>";
echo "</ul>";
?>
