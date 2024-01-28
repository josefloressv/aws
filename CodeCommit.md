# Connect to CodeCommit from SSH
https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-without-cli.html

## Step 1: generate SSH key pair

```bash
ssh-keygen -t rsa -b 4096 -C "jose@example.com"

#copy the public key
cat ~/.ssh/id_rsa.pub
```

## Step 2: Associate your public key with your IAM user
1. Go to the [IAM console](https://console.aws.amazon.com/iam/) and choose your IAM user
   1. or go to [Security Credentials](https://console.aws.amazon.com/iam/home?#security_credential) from the top right menu
2. On the AWS CodeCommit Credentials tab,, choose Upload SSH public key.
3. Paste the contents of your SSH public key into the field, and then choose Upload SSH Key.
4. Copy the SSH key ID generated

## Step 3: Add CodeCommit to your SSH configuration

```bash
vi ~/.ssh/config

Host git-codecommit.*.amazonaws.com
User Your-SSH-Key-ID, such as APKAEIBAERJR2EXAMPLE
IdentityFile Your-Private-Key-File, such as ~/.ssh/codecommit_rsa or ~/.ssh/id_rsa
         
```

## Step 4: Test your SSH configuration
```bash
ssh git-codecommit.us-east-1.amazonaws.com
```