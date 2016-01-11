  FIELD deployment_obj LIKE gst_deployment.deployment_obj VALIDATE ~
  FIELD deploy_package_obj LIKE gst_deployment.deploy_package_obj VALIDATE ~
  FIELD package_code LIKE gsc_deploy_package.package_code VALIDATE ~
  FIELD originating_site_number LIKE gst_deployment.originating_site_number~
  FIELD deployment_number LIKE gst_deployment.deployment_number~
  FIELD deployment_description LIKE gst_deployment.deployment_description~
  FIELD deployment_date LIKE gst_deployment.deployment_date~
  FIELD deployment_time LIKE gst_deployment.deployment_time~
  FIELD baseline_deployment LIKE gst_deployment.baseline_deployment~
  FIELD manual_record_selection LIKE gst_deployment.manual_record_selection~
  FIELD package_control_file LIKE gst_deployment.package_control_file~
  FIELD package_exception_file LIKE gst_deployment.package_exception_file~
  FIELD load_after_deployment_obj LIKE gst_deployment.load_after_deployment_obj VALIDATE 
