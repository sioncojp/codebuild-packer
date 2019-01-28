# codebuild-packer

After setting Codebuild/S3/IAM/SecurityGroup with terraform,

```sh
$ make build IMAGE=images/amazon-linux.json
```

# Important
- terraform: Please change VPC_ID and SUBNET.
- images: Please change SUBNET, SG and your ACCOUNT_ID in json.