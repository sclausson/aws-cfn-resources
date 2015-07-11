require 'aws-sdk-v1'

module AWS
  class AutoScaling
    class Group

      private

      def tag_value(tag_key)
        tags.select {|tag| tag.key == tag_key}.first.value
      end

    end
  end
end