/*********************************************************************
* Copyright (C) 2000,2009 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: D:\Progress\Wrk\src\web2\Admwprto.i
 * Created from procedure: D:\Progress\Wrk\web2\Admweb.p at 09:56 on 10/29/98
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE timingOut IN SUPER:
END PROCEDURE.

PROCEDURE set-attribute-list IN SUPER:
  DEFINE INPUT PARAMETER p-attr-list AS CHARACTER.
END PROCEDURE.

PROCEDURE getAttribute IN SUPER:
  DEFINE INPUT PARAMETER p_attr-name AS CHARACTER.
END PROCEDURE.

PROCEDURE destroy IN SUPER:
END PROCEDURE.

PROCEDURE start-super-proc IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
END PROCEDURE.

FUNCTION getWebState RETURNS CHARACTER IN SUPER.

FUNCTION getWebTimeout RETURNS DECIMAL IN SUPER.

FUNCTION getWebTimeRemaining RETURNS DECIMAL IN SUPER.

FUNCTION getWebToHdlr RETURNS CHARACTER IN SUPER.

FUNCTION setWebState RETURNS LOGICAL
  (INPUT pdWebTimeout AS DECIMAL) IN SUPER.

FUNCTION setWebToHdlr RETURNS LOGICAL
  (INPUT pcWebToHdlr AS CHARACTER) IN SUPER.

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

