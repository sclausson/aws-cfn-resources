aws-cfn-resources gem
=====================

## Description

CloudFormation is ideal for creating resources on AWS. Each resource in a CloudFormation template is described using a Logical_Resource description. During stack creation, physical resources are instantiated from these logical resource descriptions.  When stack creation is complete, we are left with a mapping of (known) Logical_Resource_Ids to (AWS generated) Physical_Resource_Ids.  

By mixing methods into AWS::CloudFormation::Stack, the aws-cfn-resources gem is meant to make it easy to retrieve these physical resources in the form of AWS::* objects.

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

Given a CloudFormation template snippet a stack named "myStack":
```json
Resources: {
    "myWebInstance" : {
      "Type" : "AWS::EC2::Instance",
      "Properties" : {
        ...
      }
    },
    "myDbInstance" : {
      "Type" : "AWS::EC2::Instance",
      "Properties" : {
        ...
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
 # <AWS::EC2::Instance id:i-abc12345>
```

Return a hash containting all AWS::EC2::Instance resource types created by the cfn stack
```ruby
stack = cfn.stacks['myStack']
instances = stack.instances
# {:myWebInstance=><AWS::EC2::Instance id:i-abc12345>,:myDbInstance=><AWS::EC2::Instance id:i-def67890>}