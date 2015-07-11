require 'aws-sdk-v1'

module AWS
  class ELB
    class LoadBalancer

      def tags
        client = AWS::ELB::Client.new
        client.describe_tags(load_balancer_names: [name]).tag_descriptions.first.tags.inject({}) { |hash, (k,v)| hash[k[:key]] = k[:value]; hash }
      end

    end
  end
end