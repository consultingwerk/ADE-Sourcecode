/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
  FIELD dataset_deployment_obj LIKE gsm_dataset_deployment.dataset_deployment_obj VALIDATE ~
  FIELD deploy_dataset_obj LIKE gsm_dataset_deployment.deploy_dataset_obj VALIDATE ~
  FIELD dataset_code LIKE gsc_deploy_dataset.dataset_code VALIDATE ~
  FIELD owner_site_code LIKE gsc_deploy_dataset.owner_site_code VALIDATE ~
  FIELD deployment_number LIKE gsm_dataset_deployment.deployment_number VALIDATE ~
  FIELD deployment_description LIKE gsm_dataset_deployment.deployment_description VALIDATE ~
  FIELD deployment_date LIKE gsm_dataset_deployment.deployment_date VALIDATE ~
  FIELD deployment_time LIKE gsm_dataset_deployment.deployment_time VALIDATE ~
  FIELD baseline_deployment LIKE gsm_dataset_deployment.baseline_deployment VALIDATE ~
  FIELD xml_filename LIKE gsm_dataset_deployment.xml_filename VALIDATE ~
  FIELD xml_exception_file LIKE gsm_dataset_deployment.xml_exception_file VALIDATE ~
  FIELD import_date LIKE gsm_dataset_deployment.import_date VALIDATE ~
  FIELD import_time LIKE gsm_dataset_deployment.import_time VALIDATE ~
  FIELD import_user LIKE gsm_dataset_deployment.import_user VALIDATE 
