require 'aws-sdk-v1' 

#set AWS.config(region: 'region-name')
#initialize stack with stack = AWS::CloudFormation::Stack.new('stack-name')

module AWS
  class CloudFormation
    class Stack
      
      def autoscaling_group(logical_id)
        AWS::AutoScaling.new.groups[autoscaling_group_ids[logical_id.to_sym]]
      end

      def autoscaling_groups
        autoscaling_group_ids.inject({}) { |hash, (k,v)| hash[k] = autoscaling_group(k); hash }
      end

      def autoscaling_group_ids
        get_resources "AWS::AutoScaling::AutoScalingGroup" 
      end

      def bucket(logical_id)
        AWS::S3.new.buckets[bucket_ids[logical_id.to_sym]]
      end

      def buckets
        bucket_ids.inject({}) { |hash, (k,v)| hash[k] = bucket(k); hash }
      end

      def bucket_ids
        get_resources "AWS::S3::Bucket"
      end

      def cloudwatch_alarm(logical_id)
        AWS::CloudWatch.new.alarms[cloudwatch_alarm_ids[logical_id.to_sym]]
      end

      def cloudwatch_alarms
        cloudwatch_alarm_ids.inject({}) { |hash, (k,v)| hash[k] = cloudwatch_alarm(k); hash }
      end

      def cloudwatch_alarm_ids
        get_resources "AWS::CloudWatch::Alarm"
      end

      def db_instance(logical_id)
        AWS::RDS.new.db_instances[db_instance_ids[logical_id.to_sym]]
      end

      def db_instances
        db_instance_ids.inject({}) { |hash, (k,v)| hash[k] = db_instance(k); hash }
      end

      def db_instance_ids
        get_resources "AWS::RDS::DBInstance"
      end

      def eip(logical_id)
        AWS::EC2.new.elastic_ips[eip_ids[logical_id.to_sym]]
      end

      alias_method :elastic_ip, :eip

      def eips
        eip_ids.inject({}) { |hash, (k,v)| hash[k] = eip(k) }
      end

      alias_method :elastic_ips, :eips

      def eip_ids
        get_resources "AWS::EC2::EIP"
      end

      def elb(logical_id)
        AWS::ELB.new.load_balancers[elb_ids[logical_id.to_sym]]
      end

      def elbs
        elb_ids.inject({}) { |hash, (k,v)| hash[k] = elb(k); hash }
      end
      
      def elb_ids
        get_resources "AWS::ElasticLoadBalancing::LoadBalancer"
      end

      def iam_access_key(user_logical_id, key_logical_id)
        iam_user(user_logical_id).access_keys[iam_access_key_ids[key_logical_id.to_sym]]
      end

      def iam_access_key_ids
        get_resources "AWS::IAM::AccessKey"
      end

      def iam_group(logical_id)
        AWS::IAM.new.groups[iam_group_ids[logical_id.to_sym]]
      end

      def iam_groups
        iam_group_ids.inject({}) { |hash, (k,v)| hash[k] = iam_group(k); hash }
      end

      def iam_group_ids
        get_resources "AWS::IAM::Group"
      end

      def iam_policy
       puts "use Stack.iam_group#policies or Stack.iam_user#policies"
      end

      alias_method :iam_policies, :iam_policy

      def iam_policy_ids
        get_resources "AWS::IAM::Policy"
      end

      def iam_user(logical_id)
        AWS::IAM.new.users[iam_user_ids[logical_id.to_sym]]
      end

      def iam_users
        iam_user_ids.inject({}) { |hash, (k,v)| hash[k] = iam_user(k); hash }
      end

      def iam_user_ids
        get_resources "AWS::IAM::User"
      end

      def instance(logical_id)
        AWS::EC2.new.instances[instance_ids[logical_id.to_sym]]
      end

      def instances
        instance_ids.inject({}) { |hash, (k,v)| hash[k] = instance(k); hash }
      end

      def instance_ids
        get_resources "AWS::EC2::Instance"
      end

      def internet_gateway(logical_id)
        AWS::EC2.new.internet_gateways[internet_gateway_ids[logical_id.to_sym]]
      end

      alias_method :igw, :internet_gateway

      def internet_gateway_ids
        get_resources "AWS::EC2::InternetGateway"
      end

      def launch_configuration(logical_id)
        AWS::AutoScaling.new.launch_configurations[launch_configuration_ids[logical_id.to_sym]]
      end

      alias_method :launch_config, :launch_configuration

      def launch_configurations
        launch_configuration_ids.inject({}) { |hash, (k,v)| hash[k] = launch_configuration(k); hash }
      end

      alias_method :launch_configs, :launch_configurations

      def launch_configuration_ids
        get_resources "AWS::AutoScaling::LaunchConfiguration"
      end

      def network_interface(logical_id)
        AWS::EC2.new.network_interfaces[network_interface_ids[logical_id.to_sym]]
      end

      alias_method :nic, :network_interface

      def network_interfaces
        network_interface_ids.inject({}) { |hash, (k,v)| hash[k] = network_interface(k); hash }
      end

      alias_method :nics, :network_interfaces

      def network_interface_ids
        get_resources "AWS::EC2::NetworkInterface"
      end

      def route_table(logical_id)
        AWS::EC2.new.route_tables[route_table_ids[logical_id.to_sym]]
      end

      def route_table_ids
        get_resources "AWS::EC2::RouteTable"
      end

      def scaling_policy(as_group_logical_id, policy_logical_id)
        group = autoscaling_group(as_group_logical_id)
        policy = scaling_policy_ids[policy_logical_id.to_sym].split('/')[-1]
        AWS::AutoScaling::ScalingPolicy.new(group, policy)
      end

      def scaling_policies(as_group_logical_id)
        scaling_policy_ids.inject({}) { |hash, (k,v)| hash[k] = scaling_policy(as_group_logical_id,k.to_s); hash }
      end

      def scaling_policy_ids
        get_resources "AWS::AutoScaling::ScalingPolicy"
      end

      #v1
      def security_group(logical_id)
        AWS::EC2.new.security_groups.filter('group-id',security_group_ids[logical_id.to_sym]).first
      end

      #v1
      def security_groups
        security_group_ids.inject({}) { |hash, (k,v)| hash[k] = security_group(k); hash }
      end

      def security_group_ids
        get_resources "AWS::EC2::SecurityGroup"
      end

      def subnet(logical_id)
        AWS::EC2.new.subnets[subnet_ids[logical_id.to_sym]]
      end

      def subnets
        subnet_ids.inject({}) { |hash, (k,v)| hash[k] = subnet(k); hash }
      end

      def subnet_ids
        get_resources "AWS::EC2::Subnet"
      end

      def volume(logical_id)
        AWS::EC2.new.volumes[volume_ids[logical_id.to_sym]]
      end

      def volumes
        volume_ids.inject({}) { |hash, (k,v)| hash[k] = volume(k); hash }
      end

      def volume_ids
        get_resources "AWS::EC2::Volume"
      end

      def vpc(logical_id)
        AWS::EC2.new.vpcs[vpc_ids[logical_id.to_sym]]
      end

      def vpcs
        vpc_ids.inject({}) { |hash, (k,v)| hash[k] = vpc(k); hash }
      end

      def vpc_ids
        get_resources "AWS::EC2::VPC"
      end

      private

      def get_resources(resource_type)
        hash = {}
        resource_summaries.select { |rs| rs[:resource_type] == "#{resource_type}" }.collect { |r| hash[r[:logical_resource_id].to_sym] = r[:physical_resource_id] }
        return hash
      end

    end
  end
end

