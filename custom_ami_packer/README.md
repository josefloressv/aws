```bash

# Create the Bucket to upload the CloudFormation template
aws s3api create-bucket --bucket packer-bucket-jf --region us-east-1

# Create the CloudFormation Stack
aws cloudformation create-stack \
  --stack-name SSMAutomationPackerStack \
  --template-body file://cf-stack.yaml \
  --parameters ParameterKey=PackerTemplateS3BucketLocation,ParameterValue=packer-bucket-jf \
  --capabilities CAPABILITY_NAMED_IAM

## In case update is needed
aws cloudformation update-stack \
  --stack-name SSMAutomationPackerStack \
  --template-body file://cf-stack.yaml \
  --parameters ParameterKey=PackerTemplateS3BucketLocation,ParameterValue=packer-bucket-jf \
  --capabilities CAPABILITY_NAMED_IAM

# Test and Build the image with Packer
packer validate packer.json
packer build packer.json

# Run the EC2 instance with the new AMI
  aws ec2 run-instances \
  --image-id ami-0df8d006ecdd1eff6 \
  --instance-type t3.medium \
  --security-group-ids sg-0cb7de04f63e260b8 \
  --subnet-id subnet-04382cb4a618aa6d4 \
  --associate-public-ip-address

```


ToDO
* Add the creation to the S3 bucket in CloudFormation
* Create a Security Group for the Packer with SSH inbound
* Create a Security Group for the new EC2 instance and allow HTTP
* Automate the creation for the SG with CloudFormation
* Add variable customization to the Packer template