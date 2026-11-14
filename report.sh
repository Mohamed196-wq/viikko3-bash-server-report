#!/usr/bin/env bash
set -euo pipefail

OUTPUT="/var/www/html/viikko3/index.html"

GENERATED_AT=$(date '+%Y-%m-%d %H:%M:%S %Z')
UPTIME_TEXT=$(uptime -p)
DISK_PERCENT=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
RAM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
RAM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

disk_status() {
    if [ "$1" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS=$(disk_status "$DISK_PERCENT")

cat > "$OUTPUT" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Week 3 - Server Status Report</title>
<style>
body { font-family: Arial; background: #eaf3ff; padding: 40px; }
main { background: white; padding: 30px; max-width: 700px; margin: auto; border-radius: 15px; }
h1 { color: #1264a3; }
p { font-size: 18px; }
</style>
</head>
<body>
<main>
<h1>My Linux Server Status Report</h1>
<h2>Week 3 - Bash Assignment</h2>
<p><b>Report generated:</b> $GENERATED_AT</p>
<p><b>Server uptime:</b> $UPTIME_TEXT</p>
<p><b>Disk usage:</b> $DISK_PERCENT%</p>
<p><b>Disk status:</b> $DISK_STATUS</p>
<p><b>Total RAM:</b> $RAM_TOTAL MiB</p>
<p><b>Available RAM:</b> $RAM_AVAILABLE MiB</p>

<hr>
<h2>How the report works</h2>
<p>This report is created with a Bash script on my Ubuntu Linux server.</p>
<p>The script uses variables, command substitution, a pipe, an if statement
and a function called disk_status.</p>

<h2>Linux commands used</h2>
<p><b>date:</b> Shows the current date, time and time zone.</p>
<p><b>uptime -p:</b> Shows how long the server has been running.</p>
<p><b>df -P / | awk 'NR==2 {print &#36;5}':</b>
Uses a pipe to extract the disk usage percentage.</p>
<p><b>free -m:</b> Shows total and available RAM.</p>

<h2>Automatic updates</h2>
<p>A systemd timer runs the Bash script every minute.
The timer is enabled to start automatically after a server reboot.</p>

<h2>Test results</h2>
<p>Bash syntax check: PASSED.</p>
<p>Manual script execution: PASSED.</p>
<p>Disk status tests: 50% = OK, 80% = WARNING, 90% = WARNING.</p>
<p>Automatic updates observed at 17:49:01 and 17:51:01 UTC.</p>
<p>Reboot test: PASSED. The Week 3 report and Week 2 application
opened after reboot, and automatic updates continued.</p>

<h2>Problem solved</h2>
<p>The server initially displayed UTC time.
I changed the time zone to Europe/Helsinki.
The report now displays Finnish local time (EET).</p>

</main>
</body>
</html>
HTML

echo "Week 3 report created successfully!"
