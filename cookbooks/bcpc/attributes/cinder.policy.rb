###########################################
#
#  Cinder policy Settings
#
###########################################
default['bcpc']['cinder']['policy'] = {
  "context_is_admin" => "role:admin",
  "admin_or_owner" => "is_admin:True or project_id:%(project_id)s",
  "default" => "rule:admin_or_owner",

  "admin_api" => "is_admin:True",

  "volume:create" => "",
  "volume:delete" => "",
  "volume:get" => "",
  "volume:get_all" => "",
  "volume:get_volume_metadata" => "",
  "volume:get_volume_admin_metadata" => "rule:admin_api",
  "volume:delete_volume_admin_metadata" => "rule:admin_api",
  "volume:update_volume_admin_metadata" => "rule:admin_api",
  "volume:get_snapshot" => "",
  "volume:get_all_snapshots" => "",
  "volume:extend" => "",
  "volume:update_readonly_flag" => "",
  "volume:retype" => "",

  "volume_extension:types_manage" => "rule:admin_api",
  "volume_extension:types_extra_specs" => "rule:admin_api",
  "volume_extension:volume_type_access" => "",
  "volume_extension:volume_type_access:addProjectAccess" => "rule:admin_api",
  "volume_extension:volume_type_access:removeProjectAccess" => "rule:admin_api",
  "volume_extension:volume_type_encryption" => "rule:admin_api",
  "volume_extension:volume_encryption_metadata" => "rule:admin_or_owner",
  "volume_extension:extended_snapshot_attributes" => "",
  "volume_extension:volume_image_metadata" => "",

  "volume_extension:quotas:show" => "",
  "volume_extension:quotas:update" => "rule:admin_api",
  "volume_extension:quota_classes" => "",

  "volume_extension:volume_admin_actions:reset_status" => "rule:admin_api",
  "volume_extension:snapshot_admin_actions:reset_status" => "rule:admin_api",
  "volume_extension:backup_admin_actions:reset_status" => "rule:admin_api",
  "volume_extension:volume_admin_actions:force_delete" => "rule:admin_api",
  "volume_extension:volume_admin_actions:force_detach" => "rule:admin_api",
  "volume_extension:snapshot_admin_actions:force_delete" => "rule:admin_api",
  "volume_extension:volume_admin_actions:migrate_volume" => "rule:admin_api",
  "volume_extension:volume_admin_actions:migrate_volume_completion" => "rule:admin_api",

  "volume_extension:volume_host_attribute" => "rule:admin_api",
  "volume_extension:volume_tenant_attribute" => "rule:admin_or_owner",
  "volume_extension:volume_mig_status_attribute" => "rule:admin_api",
  "volume_extension:hosts" => "rule:admin_api",
  "volume_extension:services" => "rule:admin_api",

  "volume_extension:volume_manage" => "rule:admin_api",
  "volume_extension:volume_unmanage" => "rule:admin_api",

  "volume:services" => "rule:admin_api",

  "volume:create_transfer" => "",
  "volume:accept_transfer" => "",
  "volume:delete_transfer" => "",
  "volume:get_all_transfers" => "",

  "volume_extension:replication:promote" => "rule:admin_api",
  "volume_extension:replication:reenable" => "rule:admin_api",

  "backup:create" => "role:admin",
  "backup:delete" => "role:admin",
  "backup:get" => "",
  "backup:get_all" => "",
  "backup:restore" => "role:admin",
  "backup:backup-import" => "rule:admin_api",
  "backup:backup-export" => "rule:admin_api",

  "snapshot_extension:snapshot_actions:update_snapshot_status" => "",

  "consistencygroup:create" => "group:nobody",
  "consistencygroup:delete" => "group:nobody",
  "consistencygroup:update" => "group:nobody",
  "consistencygroup:get" => "group:nobody",
  "consistencygroup:get_all" => "group:nobody",

  "consistencygroup:create_cgsnapshot" => "group:nobody",
  "consistencygroup:delete_cgsnapshot" => "group:nobody",
  "consistencygroup:get_cgsnapshot" => "group:nobody",
  "consistencygroup:get_all_cgsnapshots" => "group:nobody",

  "scheduler_extension:scheduler_stats:get_pools" => "rule:admin_api"
}
