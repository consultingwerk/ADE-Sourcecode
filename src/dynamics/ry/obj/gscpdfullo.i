  FIELD package_dataset_obj LIKE gsc_package_dataset.package_dataset_obj VALIDATE ~
  FIELD deploy_dataset_obj LIKE gsc_package_dataset.deploy_dataset_obj VALIDATE ~
  FIELD deploy_package_obj LIKE gsc_package_dataset.deploy_package_obj VALIDATE ~
  FIELD package_code LIKE gsc_deploy_package.package_code VALIDATE ~
  FIELD package_description LIKE gsc_deploy_package.package_description VALIDATE ~
  FIELD deploy_full_data LIKE gsc_package_dataset.deploy_full_data~
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code VALIDATE ~
  FIELD dataset_description LIKE gsc_deploy_dataset.dataset_description VALIDATE ~
  FIELD default_ado_filename LIKE gsc_deploy_dataset.default_ado_filename VALIDATE 
