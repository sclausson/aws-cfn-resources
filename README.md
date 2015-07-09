aws-cfn-resources gem
=====================

## Description

CloudFormation is ideal for creating resources on AWS. Each resource in a CloudFormation template is described using a Logical_Resource description.  During stack creation, physical resources are instantiated from these logical resource descriptions.  
When stack creation is complete, we are left with a mapping of (known) Logical_Resource_Ids to (AWS generated) Physical_Resource_Ids.  The aws-cfn-resources gem is meant to make it easy to retrieve these physical resources in the form of AWS::* objects.


