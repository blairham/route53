action :create do
  require 'aws-sdk-core'

  @zones = { 'A' => 'Z38ROTMZFQYWIJ', 'PTR' => 'Z1U3P2W8H9ACLE', 'CNAME' => 'Z38ROTMZFQYWIJ' }
  @region = 'us-east-1'
  @domain = 'optimizely'
  @vpc_id = 'vpc-18b7407d'

  def create_record(name, value, record_type, ttl)
    @route53 ||= Aws::Route53::Client.new(region: @region)
    Chef::Log.debug "Record for #{name} to #{value} of type #{record_type}"
    @route53.change_resource_record_sets(
      hosted_zone_id: new_resource.zone_id || @zones[record_type],
      change_batch: {
        changes: [
          {
            action: 'UPSERT',
            resource_record_set: {
              name: name.strip,
              type: record_type,
              ttl: ttl,
              resource_records: [{ value: value.strip }],
            },
          },
        ],
      },
    )
  end

  create_record(new_resource.name, new_resource.value, new_resource.type, new_resource.ttl)
end

action :delete do
  require 'aws-sdk-core'

  @zones = { 'A' => 'Z38ROTMZFQYWIJ', 'PTR' => 'Z1U3P2W8H9ACLE', 'CNAME' => 'Z38ROTMZFQYWIJ' }
  @region = 'us-east-1'
  @domain = 'optimizely'
  @vpc_id = 'vpc-18b7407d'

  def delete_record(name, value, record_type, ttl)
    @route53 ||= Aws::Route53::Client.new(region: @region)
    Chef::Log.debug "Deleting record for #{name} of type #{record_type}"
    @route53.change_resource_record_sets(
      hosted_zone_id: new_resource.zone_id || @zones[record_type],
      change_batch: {
        changes: [
          {
            action: 'DELETE',
            resource_record_set: {
              name: name.strip,
              type: record_type,
              ttl: ttl,
              resource_records: [{ value: value.strip }],
            },
          },
        ],
      },
    )
  end

  delete_record(new_resource.name, new_resource.value, new_resource.type, new_resource.ttl)
end
