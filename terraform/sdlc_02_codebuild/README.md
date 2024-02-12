# AWS SDLC v2

In this version
1. Create a CodeBuild project
   1. Source: CodeCommit, resusing previous project but for a Java application
   2. Environment: Amazon Linux container with java: corretto17
   3. Using local environment variables and SSM parameters
   4. Artifact: upload the artifact to S3 bucket
   5. Include a Service role definition with the righ permissions required
   6. Create the required s3 Bucket to upload the artifact
   7. Create a SSM parameter to be pulled from Build phase
