http://checkip.amazonaws.com Find my public IP Address
```bash
curl http://checkip.amazonaws.com
```
https://cloudping.info/ Use this page to measure latency from your browser to various cloud provider datacenters.

# EC2 metadata

Amazon Linux 2023
```bash
ec2-metadata -i #instance id
```
https://manpages.ubuntu.com/manpages/impish/man8/ec2-metadata.8.html

Other versions
```bash
#Get the Instance ID from metadata
INSTANCEID=$(curl http://169.254.169.254/2016-06-30/meta-data/instance-id)
#Get public DNS from metadata
PUBLICIP=$(curl http://169.254.169.254/2016-06-30/meta-data/public-ipv4)
```
