  FIELD dataset_entity_obj LIKE gsc_dataset_entity.dataset_entity_obj VALIDATE ~
  FIELD deploy_dataset_obj LIKE gsc_dataset_entity.deploy_dataset_obj VALIDATE ~
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code VALIDATE ~
  FIELD entity_sequence LIKE gsc_dataset_entity.entity_sequence VALIDATE ~
  FIELD entity_mnemonic LIKE gsc_dataset_entity.entity_mnemonic VALIDATE  LABEL "Entity"~
  FIELD primary_entity LIKE gsc_dataset_entity.primary_entity VALIDATE ~
  FIELD join_entity_mnemonic LIKE gsc_dataset_entity.join_entity_mnemonic VALIDATE  LABEL "Join Entity"~
  FIELD join_field_list LIKE gsc_dataset_entity.join_field_list VALIDATE ~
  FIELD filter_where_clause LIKE gsc_dataset_entity.filter_where_clause VALIDATE ~
  FIELD delete_related_records LIKE gsc_dataset_entity.delete_related_records VALIDATE ~
  FIELD keep_own_site_data LIKE gsc_dataset_entity.keep_own_site_data VALIDATE ~
  FIELD overwrite_records LIKE gsc_dataset_entity.overwrite_records VALIDATE 
