/* Fix program for the setting the value of the new scm_tool_obj field on the 
   gsc_security_control and other tables. 
    
  This fix will enable the use of the new gsc_scm_tool table which replaces 
  hard-coded text strings for the SCM tool being used. 
*/

FIND FIRST gsc_scm_tool WHERE gsc_scm_tool.scm_tool_code = "RTB":U NO-LOCK NO-ERROR. 

FIND FIRST gsc_security_control EXCLUSIVE-LOCK NO-ERROR. 

IF AVAILABLE gsc_security_control THEN
DO:
  PUBLISH "DCU_WriteLog":U ("Setting gsc_scm_tool.scm_tool_obj on gsc_security_control table  ...").
  PUBLISH "DCU_SetStatus":U ("Setting gsc_scm_tool.scm_tool_obj on gsc_security_control table  ...").
  
  ASSIGN gsc_security_control.scm_tool_obj = gsc_scm_tool.scm_tool_obj. 
  
  PUBLISH "DCU_WriteLog":U ("Setting of gsc_scm_tool.scm_tool_obj on gsc_security_control table complete.").
END.

RETURN.


