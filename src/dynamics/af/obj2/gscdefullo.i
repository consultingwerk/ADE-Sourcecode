  FIELD dataset_entity_obj LIKE gsc_dataset_entity.dataset_entity_obj VALIDATE ~
  FIELD deploy_dataset_obj LIKE gsc_dataset_entity.deploy_dataset_obj VALIDATE ~
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code VALIDATE ~
  FIELD entity_sequence LIKE gsc_dataset_entity.entity_sequence VALIDATE ~
  FIELD entity_mnemonic LIKE gsc_dataset_entity.entity_mnemonic VALIDATE ~
  FIELD primary_entity LIKE gsc_dataset_entity.primary_entity VALIDATE ~
  FIELD join_entity_mnemonic LIKE gsc_dataset_entity.join_entity_mnemonic VALIDATE ~
  FIELD join_field_list LIKE gsc_dataset_entity.join_field_list VALIDATE ~
  FIELD filter_where_clause LIKE gsc_dataset_entity.filter_where_clause VALIDATE ~
  FIELD delete_related_records LIKE gsc_dataset_entity.delete_related_records VALIDATE ~
  FIELD keep_own_site_data LIKE gsc_dataset_entity.keep_own_site_data VALIDATE ~
  FIELD overwrite_records LIKE gsc_dataset_entity.overwrite_records VALIDATE ~
  FIELD deletion_action LIKE gsc_dataset_entity.deletion_action VALIDATE ~
  FIELD relationship_obj LIKE gsc_dataset_entity.relationship_obj VALIDATE ~
  FIELD use_relationship LIKE gsc_dataset_entity.use_relationship VALIDATE ~
  FIELD exclude_field_list LIKE gsc_dataset_entity.exclude_field_list
