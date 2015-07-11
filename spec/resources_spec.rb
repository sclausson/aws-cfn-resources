require_relative '../lib/stack.rb'
require_relative '../lib/resources.rb'

def create_test_stack(stack_name, template_file)
  @cfn = AWS::CloudFormation.new
  @cfn.client.create_stack({stack_name: stack_name, template_body: read(template_file), capabilities: ["CAPABILITY_IAM"]}) unless @cfn.stacks[stack_name].exists?
  wait_for_stack(@cfn.stacks[stack_name])
end

def wait_for_stack(stack)
  print "Waiting for stack #{stack.name} to complete" unless stack.status == "CREATE_COMPLETE"
  until stack.status == "CREATE_COMPLETE"
    sleep 5
    print "."
  end
end

def read(file)
  File.open(file, "r").read
end

describe "AutoScaling, CloudWatch, ELB Resources for AS-Test Stack" do
  stack_name, template_file = "AS-Test", "./spec/as-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "AWS::ELB::LoadBalancer#stack => Returns the AWS::CloudFormation::Stack resource that created the ELB" do
    resource = stack.elb('ElasticLoadBalancer')
    expect(resource.stack.name).to eq "AS-Test"
    expect(resource.stack.status).to eq "CREATE_COMPLETE"
  end

  it "AWS::AutoScaliing::Group#stack => Returns the AWS::CloudFormation::Stack resource that created the AutoScalingGroup" do
    resource = stack.autoscaling_group('AutoScalingGroup')
    expect(resource.stack.name).to eq "AS-Test"
    expect(resource.stack.status).to eq "CREATE_COMPLETE"
  end

end

describe "EC2 Resources for EC2-Test Stack" do
  stack_name, template_file = "EC2-Test", "./spec/ec2-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "AWS::EC2::EIP#stack => Exception raised and returns back a nil AWS::CloudFormation::Stack" do
    resource = stack.eip('EIP')
    expect(resource.stack.name).to be nil
  end

  it "AWS::EC2::Instance#stack => Returns the AWS::CloudFormation::Stack resource that created the Instance" do
    resource = stack.instance('Instance')
    expect(resource.stack).to exist
  end

  it "AWS::EC2::InternetGateway#stack => AWS::CloudFormation::Stack resource that created the Internet Gateway" do
    resource = stack.igw('InternetGateway')
    expect(resource.stack).to exist
  end

  it "AWS::EC2::NetworkInterface#stack => AWS::CloudFormation::Stack resource that created the Network Interface" do
    resource = stack.nic('NetworkInterface')
    expect(resource.stack).to exist
  end

  it "AWS::EC2::SecurityGroup#stack => AWS::CloudFormation::Stack resource that created the Security Group" do
    resource = stack.security_group('SecurityGroup')
    expect(resource.stack).to exist
  end

  it "AWS::EC2::Volume#stack => AWS::CloudFormation::Stack resource that created the Volume" do
    resource = stack.volume('Volume')
    expect(resource.stack).to exist
  end

  it "AWS::EC2::VPC#stack => AWS::CloudFormation::Stack resource that created the VPC" do
    resource = stack.vpc('VPC')
    expect(resource.stack).to exist
  end

  it "AWS::CloudFormation#new#stacks still functions properly" do
    this_stack = AWS::CloudFormation.new.stacks["EC2-Test"]
    expect(this_stack.status).to eq "CREATE_COMPLETE"
    expect(this_stack).to exist
  end

  it "AWS::CloudFormation::Stack still functions properly" do
    this_stack = AWS::CloudFormation::Stack.new("EC2-Test")
    expect(this_stack.status).to eq "CREATE_COMPLETE"
    expect(this_stack).to exist
  end

  it "AWS::CloudFormation::Client still functions properly" do
    client = AWS::CloudFormation::Client.new
    expect(client.describe_stacks({stack_name: "EC2-Test"}).stacks.first.stack_status).to eq "CREATE_COMPLETE"
  end
end

describe "S3 Resources for S3-Test Stack" do
  stack_name, template_file = "S3-Test", "./spec/s3-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "AWS::S3::Bucket#stack => Returns the AWS::CloudFormation::Stack resource that created the Bucket" do
    resource = stack.bucket('S3Bucket')
    expect(resource.stack).to exist
  end
end

#CustomerGateway, DHCPOptions, Image, Instance, InternetGateway, NetworkACL, NetworkInterface, ReservedInstances, ReservedInstancesOffering, ResourceObject, RouteTable, SecurityGroup, Snapshot, Subnet, VPC, VPNConnection, VPNGateway, Volume
