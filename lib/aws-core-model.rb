require 'aws-sdk-v1'

module AWS
  module Core
    module Model

      def stack
        stack_name = tag_value "aws:cloudformation:stack-name"
        AWS::CloudFormation::Stack.new(stack_name)
      end

      private

      def tag_value(tag_key)
        begin
          self.tags[tag_key]
        rescue NoMethodError => e
          puts "#{self.class} does not support the :tags method, so we cannot determine the stack for this resource type"
        end
      end

    end
  end
end