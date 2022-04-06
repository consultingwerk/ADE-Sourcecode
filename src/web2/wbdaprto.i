/*********************************************************************
* Copyright (C) 2000,2009 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: C:\1a\src\web2\wbdaprto.i
 * Created from procedure: C:\1a\web2\wbdata.p at 10:52 on 11/06/98
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE ProcessWebRequest IN SUPER:
END PROCEDURE.

PROCEDURE assignFields IN SUPER:
END PROCEDURE.

PROCEDURE start-super-proc IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
END PROCEDURE.

FUNCTION columnValMsg RETURNS CHARACTER
  (INPUT pColumn AS CHARACTER) IN SUPER.

FUNCTION deleteBuffer RETURNS LOGICAL
  (INPUT phBuffer AS HANDLE) IN SUPER.

FUNCTION deleteRow RETURNS LOGICAL IN SUPER.

FUNCTION getDeleteTables RETURNS CHARACTER IN SUPER.

FUNCTION getFrameHandle RETURNS HANDLE IN SUPER.

FUNCTION LockRow RETURNS LOGICAL
  (INPUT pLock AS CHARACTER) IN SUPER.

FUNCTION setAddMode RETURNS LOGICAL
  (INPUT plAdd AS LOGICAL) IN SUPER.

FUNCTION setDeleteTables RETURNS LOGICAL
  (INPUT pcDeleteTables AS CHARACTER) IN SUPER.

FUNCTION setFrameHandle RETURNS LOGICAL
  (INPUT pHdl AS HANDLE) IN SUPER.

FUNCTION validateColumns RETURNS LOGICAL IN SUPER.

FUNCTION convert-datetime RETURNS CHARACTER
  (INPUT p_conversion AS CHARACTER,
   INPUT p_idate AS DATE,
   INPUT p_itime AS INTEGER,
   OUTPUT p_odate AS DATE,
   OUTPUT p_otime AS INTEGER) IN SUPER.

FUNCTION format-datetime RETURNS CHARACTER
  (INPUT p_format AS CHARACTER,
   INPUT p_date AS DATE,
   INPUT p_time AS INTEGER,
   INPUT p_options AS CHARACTER) IN SUPER.

FUNCTION get-cgi RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-fieldEx RETURNS LONGCHAR
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-value RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-valueEx RETURNS LONGCHAR
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-user-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION hidden-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER) IN SUPER.

FUNCTION hidden-field-list RETURNS CHARACTER
  (INPUT p_name-list AS CHARACTER) IN SUPER.

FUNCTION html-encode RETURNS CHARACTER
  (INPUT p_in AS CHARACTER) IN SUPER.

FUNCTION output-content-type RETURNS LOGICAL
  (INPUT p_type AS CHARACTER) IN SUPER.

FUNCTION output-http-header RETURNS CHARACTER
  (INPUT p_header AS CHARACTER,
   INPUT p_value AS CHARACTER) IN SUPER.

FUNCTION set-user-field RETURNS LOGICAL
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER) IN SUPER.

FUNCTION set-wseu-cookie RETURNS CHARACTER
  (INPUT p_cookie AS CHARACTER) IN SUPER.

FUNCTION url-decode RETURNS CHARACTER
  (INPUT p_in AS CHARACTER) IN SUPER.

FUNCTION url-encode RETURNS CHARACTER
  (INPUT p_value AS CHARACTER,
   INPUT p_enctype AS CHARACTER) IN SUPER.

FUNCTION url-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER,
   INPUT p_delim AS CHARACTER) IN SUPER.

FUNCTION url-field-list RETURNS CHARACTER
  (INPUT p_name-list AS CHARACTER,
   INPUT p_delim AS CHARACTER) IN SUPER.

FUNCTION url-format RETURNS CHARACTER
  (INPUT p_url AS CHARACTER,
   INPUT p_name-list AS CHARACTER,
   INPUT p_delim AS CHARACTER) IN SUPER.

FUNCTION delete-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_path AS CHARACTER,
   INPUT p_domain AS CHARACTER) IN SUPER.

FUNCTION get-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION set-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER,
   INPUT p_date AS DATE,
   INPUT p_time AS INTEGER,
   INPUT p_path AS CHARACTER,
   INPUT p_domain AS CHARACTER,
   INPUT p_options AS CHARACTER) IN SUPER.

FUNCTION available-messages RETURNS LOGICAL
  (INPUT p_grp AS CHARACTER) IN SUPER.

FUNCTION get-messages RETURNS CHARACTER
  (INPUT p_grp AS CHARACTER,
   INPUT p_delete AS LOGICAL) IN SUPER.

FUNCTION get-message-groups RETURNS CHARACTER IN SUPER.

FUNCTION output-messages RETURNS INTEGER
  (INPUT p_option AS CHARACTER,
   INPUT p_grp AS CHARACTER,
   INPUT p_message AS CHARACTER) IN SUPER.

FUNCTION queue-message RETURNS INTEGER
  (INPUT p_grp AS CHARACTER,
   INPUT p_message AS CHARACTER) IN SUPER.

FUNCTION check-agent-mode RETURNS LOGICAL
  (INPUT p_mode AS CHARACTER) IN SUPER.

FUNCTION get-config RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

