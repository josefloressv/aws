# AWS SDLC v0

In this version
1. Create a CodeCommit repository `demo`
   1. Include an approval rule with at least one approver from a Team Lead
   2. Include a trigger that send Push events to an SNS topic
2. Create two groups of users Dev and Team Leaders
   1. Each group has two users and allow login from AWS Console (the password is printed as plain text)
   2. Developers can use the repository, create branches and pull request but can't push to `main` branch
   3. Developers is attached the policy `AWSCodeCommitPowerUser`
   4. Team Leaders have attached the policy `AWSCodeCommitFullAccess`
   5. Team Leaders can merge changes to `main` branch
3. Create an SNS topic and attach a subscription by email address
