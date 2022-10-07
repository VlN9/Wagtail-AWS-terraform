#!/bin/bash
sudo yum -y update
sudo yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="grey">
<h1><font color="gold"> Build by Power of Terraform <font color="red">v1.2.9</font></h1><br>
<font color="green">Server PrivateIP: <font color="aqua">$myip<br><br>

<font color="magenta">
<b>Version 4.0</b>
</body
</html>
EOF

sudo service httpd start
sudo chkconfig httpd on