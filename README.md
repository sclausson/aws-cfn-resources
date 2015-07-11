aws-cfn-resources gem [![Gem Version](https://badge.fury.io/rb/aws-cfn-resources.svg)](http://badge.fury.io/rb/aws-cfn-resources)
=====================

## Description

CloudFormation is ideal for creating resources on AWS. Each resource in a CloudFormation template is described using a Logical_Resource description. During stack creation, physical resources are instantiated from these logical resource descriptions.  When stack creation is complete, we are left with a mapping of (known) Logical_Resource_Ids to (AWS generated) Physical_Resource_Ids.  

By mixing methods into AWS::CloudFormation::Stack, the aws-cfn-resources gem is meant to make it easy to retrieve these physical resources in the form of AWS::* objects.

It also makes sense to go the other direction, and to retrieve the AWS::CloudFormation::Stack responsible for creating a particular resource.  So this gem provides a stack method for most AWS taggable resources.

## Installation
* `gem install aws-cfn-resources`
* `require aws-cfn-resources`

## Basic Configuration

You need to provide your AWS security credentials and choose a default region.

```
AWS.config(access_key_id: '...', secret_access_key: '...', region: 'us-east-1')
```

You can also specify these values via `ENV`:

    export AWS_ACCESS_KEY_ID='...'
    export AWS_SECRET_ACCESS_KEY='...'
    export AWS_REGION='us-east-1'

## Basic Usage

Create a stack object

```
cfn = AWS::CloudFormation.new
stack = cfn.stacks['myStack']
```

***Example 1***

Given a CloudFormation template snippet for a stack named "myStack":
```json
Resources: {
  "myWebInstance" : {
    "Type" : "AWS::EC2::Instance",
    "Properties" : {
      "..."
    }
  },
  "myDbInstance" : {
    "Type" : "AWS::EC2::Instance",
    "Properties" : {
      "..."
    }
  }
}
```
Return an AWS::EC2::Instance object for "myWebInstance"
```ruby
require 'aws-cfn-resources'
cfn = AWS::CloudFormation.new

stack = cfn.stacks['myStack']
instance = stack.instance('myWebInstance')
#=> <AWS::EC2::Instance id:i-abc12345>
```

Return a hash containting all AWS::EC2::Instance resource types created by the cfn stack
```ruby
stack = cfn.stacks['myStack']
instances = stack.instances
#=> {:myWebInstance=><AWS::EC2::Instance id:i-abc12345>,:myDbInstance=><AWS::EC2::Instance id:i-def67890>}
```

***Example 2***

Given a Cloudformation template snippet for a stack named "VpcCreator":
```json
Resources: {
  "myVpc" : {
    "Type" : "AWS::EC2::VPC",
    "Properties" : {
      "..."
    }
  },
  "WebSubnet" : {
    "Type" : "AWS::EC2::Subnet",
    "Properties" : {
      "..."
    }
  }
}
```
Return VPC and Subnet names to be used as parameter values in a dependent template
```ruby
vpc_stack = cfn.stacks['VpcCreator']
vpc_id = vpc_stack.vpc('myVpc').id
web_subnet_id = vpc_stack.subnet('WebSubnet').id

resp = cfn.client.create_stack({stack_name: 'webStack', template_body: web_template, parameters: [{ParameterKey: "VpcId", ParameterValue: vpc_id}, {ParameterKey: "WebSubnetId", ParameterValue: web_subnet_id}] })
```
Cloudformation snippet for web.template used to create "webStack":
```json
Parameters : {
  "VpcId" : {
    "..."
  },
  "WebSubnetId" : {
    "..."
  }
}
```

***Example 3***

Return AWS::CloudFormation::Stack that created a specific AWS resource

```ruby
ec2 = AWS::EC2.new
web_instance = ec2.instances['i-abc12345']
vpc = ec2.vpcs['vpc-def67890']

web_instance.stack
#=> <AWS::CloudFormation::Stack stack_name:webStack> 

vpc.stack
#=> <AWS::CloudFormation::Stack stack_name:VpcCreator>
```

## Testing
**WARNING:** Running Rspec will create stacks and real AWS resources (that cost real money!!)  Make sure to delete these stacks when testing is complete.

**Note:** Test tasks are only meant to be deployed to the 'us-east-1' region for now.  Making the test templates multi-region is on the roadmap.

**TODO:** use a Rakefile to make testing easier/better.

But for now, you can test with:

```sh
rspec ./spec/stack_spec.rb #queries stacks and returns resources
rspec ./spec/resources_spec.rb #queries resources and returns stacks 
rspec #both 

## toggle variables in ./spec/stack_spec.rb to test more or less
test_as = true #autoscaling resources
test_cw = false #cloudwatch alarm resource
test_ec2 = true #ec2 resources
test_elb = false #elastic load balancer resource
test_iam = false #IAM resources
test_rds = false #db_instanace resource
test_s3 = true #S3 bucket resource
```




