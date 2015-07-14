require_relative '../lib/stack.rb'

AWS.config(region: 'us-east-1')

test_as = ENV['AS'] || ENV['ALL']
test_cw = ENV['CW'] || ENV['ALL']
test_ec2 = ENV['EC2'] || ENV['ALL']
test_elb = ENV['ELB'] || ENV['ALL']
test_iam = ENV['IAM'] || ENV['ALL']
test_rds = ENV['RDS'] || ENV['ALL']
test_s3 = ENV['S3'] || ENV['ALL']

def create_test_stack(stack_name, template_file)
  @cfn = AWS::CloudFormation.new
  @cfn.client.create_stack({stack_name: stack_name, template_body: read(template_file), capabilities: ["CAPABILITY_IAM"]}) unless @cfn.stacks[stack_name].exists?
  wait_for_stack(@cfn.stacks[stack_name])
end

def wait_for_stack(stack)
  print "\nWaiting for stack #{stack.name} to complete" unless stack.status == "CREATE_COMPLETE"
  until stack.status == "CREATE_COMPLETE"
    sleep 5
    print "."
  end
end

def read(file)
  File.open(file, "r").read
end

describe "AutoScaling Resources" do
  stack_name, template_file = "AS-Test", "./spec/as-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name] 

  it "#autoscaling_group('AutoScalingGroup') => Returns a valid AWS::AutoScaling::AutoScalingGroup resource" do
    asg = stack.autoscaling_group("AutoScalingGroup")
    expect(asg).to exist
  end

  it "#autoscaling_group('foo') => nil" do
    asg = stack.autoscaling_group("foo")
    expect(asg).to be nil
  end

  it "#autoscaling_groups => Returns a hash of valid AWS::AutoScaling::AutoScalingGroup resources mapped to logical_ids" do
    asgs = stack.autoscaling_groups
    expect(asgs.values.last).to exist
  end

  it "#launch_configuration('LaunchConfig') => Returns a valid AWS::AutoScaling::LaunchConfiguration resource" do
    lc = stack.launch_configuration("LaunchConfig")
    expect(lc).to exist
  end

  it "#launch_configuration('foo') => nil" do
    lc = stack.launch_configuration("foo")
    expect(lc).to be nil
  end

  it "#launch_configurations => Returns an array of AWS::AutoScaling::LaunchConfiguration resources" do
    lcs = stack.launch_configurations
    expect(lcs.values.last).to exist
  end

  it "#scaling_policy('AutoScalingGroup','ScaleUpPolicy') => Returns a valid AWS::AutoScaling::ScalingPolicy" do
    sp = stack.scaling_policy("AutoScalingGroup","ScaleUpPolicy")
    expect(sp).to exist
  end

  it "#scaling_policy('foo','ScaleUpPolicy') => nil" do
    sp = stack.scaling_policy("foo","ScaleUpPolicy")
    expect(sp).to be nil
  end

  it "#scaling_policy('AutoScalingGroup','foo') => nil" do
    sp = stack.scaling_policy("AutoScalingGroup","foo")
    expect(sp).to be nil
  end

  it "#scaling_policy('foo','foo') => nil" do
    sp = stack.scaling_policy("foo","foo")
    expect(sp).to be nil
  end

  it "#scaling_policies('AutoScalingGroup') => Returns an array of valid AWS::AutoScaling::ScalingPolicy resources" do
    sps = stack.scaling_policies("AutoScalingGroup")
    expect(sps.values.last).to exist
  end
end if test_as

describe "CloudWatch Resources" do
  stack_name, template_file = "AS-Test", "./spec/as-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "#cloudwatch_alarm('CPUAlarmHigh') => Returns a valid AWS::CloudWatch::Alarm resource" do
    cwa = stack.cloudwatch_alarm("CPUAlarmHigh")
    expect(cwa).to exist
  end

  it "#cloudwatch_alarm('foo') => nil" do
    cwa = stack.cloudwatch_alarm("foo")
    expect(cwa).to be nil
  end

  it "#cloudwatch_alarms => Returns a hash of valid AWS::CloudWatch::Alarm resources" do
    cwas = stack.cloudwatch_alarms
    expect(cwas.values.last).to exist
  end
end if test_cw

describe "EC2 Resources" do
  stack_name, template_file = "EC2-Test", "./spec/ec2-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "#eip('EIP') => Returns a valid AWS::EC2::EIP resource" do
    eip = stack.elastic_ip("EIP")
    expect(eip).to exist
  end

  it "#eip('foo') => nil" do
    eip = stack.elastic_ip("foo")
    expect(eip).to be nil
  end

  it "#eips => Returns a hash of valid AWS::EC2::EIP resources" do
    eips = stack.elastic_ips
    expect(eips).to exist
  end

  it "#instance('Instance') => Returns a valid AWS::EC2::Instance resource" do
    instance = stack.instance("Instance")
    expect(instance).to exist
  end

  it "#instance('Foo') => nil" do
    instance = stack.instance("Foo")
    expect(instance).to be nil
  end


  it "#instances => Returns hash of valid AWS::EC2::Instance resources" do
    instances = stack.instances
    expect(instances.values.last).to exist
  end

  it "#internet_gateway('InternetGateway') => Returns a valid AWS::EC2::InternetGateway resource" do
    igw = stack.igw("InternetGateway")
    expect(igw).to exist
  end

  it "#network_interface('NetworkInterface') => Returns a valid AWS::EC2::NetworkInterface resource" do
    nic =  stack.nic("NetworkInterface")
    expect(nic).to exist
  end

  it "#network_interfaces => Returns a hash of valid AWS::EC2::NetworkInterface resources" do
    nics =  stack.nics
    expect(nics.values.last).to exist
  end

  it "#route_table('RouteTable') => Returns a valid AWS::EC2::RouteTable" do
    expect stack.route_table("RouteTable").main?
  end

  it "#security_group('SecurityGroup') => Returns a valid AWS::EC2::SecurityGroup resource" do
    sg = stack.security_group("SecurityGroup")
    expect(sg).to exist
  end
  
  it "#security_group('foo') => nil" do
    sg = stack.security_group("foo")
    expect(sg).to be nil
  end

  it "#security_groups => Returns a hash of valid AWS::EC2::SecurityGroup resources" do
    sgs = stack.security_groups
    expect(sgs.values.last).to exist
  end

  it "#subnet('Subnet') => Returns an available AWS::EC2::Subnet resource" do
    subnet = stack.subnet("Subnet")
    expect(subnet.state == :available)
  end

  it "#subnet('foo') => nil" do
    subnet = stack.subnet("foo")
    expect(subnet).to be nil
  end

  it "#subnets => Returns a hash of available AWS::EC2::Subnet resources" do
    subnets = stack.subnets
    expect(subnets.values.last.state == :available)
  end

  it "#volume('Volume') => Returns a valid AWS::EC2::Volume resource" do
    volume = stack.volume('Volume')
    expect(volume).to exist
  end

  it "#volumes => Returns a hash of valid AWS::EC2::Volume resources" do
    volumes = stack.volumes
    expect(volumes.values.last).to exist
  end

  it "#vpc('VPC') => Returns a valid AWS::EC2::VPC resource" do
    vpc = stack.vpc('VPC')
    expect(vpc).to exist
  end

  it "#vpcs => Returns a valid AWS::EC2::VPC resource" do
    vpcs = stack.vpcs
    expect(vpcs.values.last).to exist
  end
end if test_ec2

describe "ELB Resources" do
  stack_name, template_file = "AS-Test", "./spec/as-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "#elb('ElasticLoadBalancer') => Returns a vaild AWS::ElasticLoadBalancing::LoadBalancer resource" do
    elb = stack.elb("ElasticLoadBalancer")
    expect(elb).to exist
  end

  it "#elbs => Returns a hash of vaild AWS::ElasticLoadBalancing::LoadBalancer resource" do
    elbs = stack.elbs
    expect(elbs.values.last).to exist
  end
end if test_elb

describe "IAM Resources" do
  stack_name, template_file = "IAM-Test", "./spec/iam-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "#iam_access_key('IAMUser','IAMAccessKey') => Returns a valid AWS::IAM::AccessKey resource" do
    ak = stack.iam_access_key("IAMUser","IAMAccessKey")
    expect(ak.status).to eq :inactive
  end 

  it "#iam_group('IAMGroup') => Returns a valid AWS::IAM::Group resource" do
    group = stack.iam_group("IAMGroup")
    expect(group).to exist
  end

  it "#iam_group('foo') => nil" do
    group = stack.iam_group("foo")
    expect(group).to be nil
  end

  it "#iam_groups => Returns a hash of valid AWS::IAM::Group resources" do
    groups = stack.iam_groups
    expect(groups.values.last).to exist
  end

  it "#iam_user('IAMUser') => Returns a valid AWS::IAM::User resource" do
    user = stack.iam_user("IAMUser")
    expect(user).to exist
  end

  it "#iam_user('foo') => nil" do
    user = stack.iam_user("foo")
    expect(user).to be nil
  end
  
  it "#iam_users => Returns a hash of valid AWS::IAM::User resources" do
    users = stack.iam_users
    expect(users.values.last).to exist
  end
end if test_iam

describe "RDS Resources" do
  stack_name, template_file = "RDS-Test", "./spec/rds-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name] 

  it "#db_instance('myDB') => Returns a valid AWS::RDS::DBInstance resource" do
    dbi = stack.db_instance("myDB")
    expect(dbi).to exist
  end

  it "#db_instances => Returns a hash of valid AWS::RDS::DBInstance resources" do
    dbis = stack.db_instances
    expect(dbis.values.last).to exist
  end 
end if test_rds

describe "S3 Resources" do
  stack_name, template_file = "S3-Test", "./spec/s3-test.template"
  create_test_stack(stack_name,template_file)
  stack = @cfn.stacks[stack_name]

  it "#bucket('S3Bucket') => Returns a valid AWS::S3::Bucket resource" do
    bucket = stack.bucket("S3Bucket")
    expect(bucket).to exist
  end

  it "#buckets => Returns a hash of valid AWS::S3::Bucket resources" do
    buckets = stack.buckets
    expect(buckets.values.last).to exist
  end
end if test_s3