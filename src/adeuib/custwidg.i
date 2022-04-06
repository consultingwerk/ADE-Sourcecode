/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: custwidg.i

Description:
    Temp-Table definitions for UIB Custom Widgets.  Each entry in this
    table contains:
      a) Name:  OK Button   Name used in popup menus to describe the entry 
      b) Type:  BUTTON      The base TYPE of widget this entry is based upon 
      c) Desc:  "text"      Long description of the type
      d) Attr:  LIST        String of ATTR VALUE pairs

Input Parameters:
   {1} is "NEW" (or blank)

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1994

Modifed by GFS on 02/09/95 - Added _palette_item TT.
           SLK on 01/01/97 - Added _files for palette_item and _custom
           GFS on 08/31/01 - Added _design* and to _custom for ICF.
           DB  on 02/20/03 - Added _object_name for _custom and _Object_name
                             and _object_type for _palette_item table
-----------------------------------------------------------------------------*/

{adeuib/pre_proc.i}

/*
 * The following defines are the types of objects
 * that are supported in the palette. Those objects
 * that are "more like" the basic set are less
 * than the value of BASIC
 */

&GLOBAL-DEFINE P-XCONTROL 0
&GLOBAL-DEFINE P-BASIC    1
&GLOBAL-DEFINE P-SMART    2
&GLOBAL-DEFINE P-USER     3


DEFINE {1} SHARED TEMP-TABLE _custom  NO-UNDO
   FIELD _name                      AS CHAR     LABEL "Name"                    FORMAT "X(20)"
   FIELD _type                      AS CHAR     LABEL "Base Type"               FORMAT "X(20)"
   FIELD _special                   AS CHAR     LABEL "Special"                 FORMAT "X(20)"
   FIELD _order                     AS INTEGER  
   /* Even though used can enter a description, we ignore it in 7.3A, so
    *  this field is commented out 
    * FIELD _description    AS CHAR     LABEL "Description"  FORMAT "X(80)"
    */
   FIELD _attr                      AS CHAR     LABEL "Attributes"              FORMAT "X(80)"
   FIELD _files                     AS CHAR     LABEL "Cst Files"               FORMAT "X(20)"
   FIELD _static_object             AS LOGICAL  LABEL "Static?"                 INITIAL YES
   FIELD _design_propsheet_file     AS CHAR     LABEL "Design Property Sheet"   FORMAT "X(20)"
   FIELD _design_image_file         AS CHAR     LABEL "Design Image File"       FORMAT "X(20)"
   FIELD _object_type_code          AS CHAR     LABEL "Object Type Code"        FORMAT "X(20)"
   FIELD _design_template_file      AS CHAR     LABEL "Template"                FORMAT "X(20)"
   FIELD _object_name               AS CHAR     LABEL "Object Name"             FORMAT "X(50)" 
 INDEX _type-order IS PRIMARY _type _order
 INDEX _name _name.
 
DEFINE {1} SHARED TEMP-TABLE _palette_item  NO-UNDO
   FIELD _name           AS CHAR     LABEL "Name"        FORMAT "X(20)"
   FIELD _type           AS INTEGER  LABEL "Type" /* P-BASIC, etal*/
   FIELD _label          AS CHAR     LABEL "Label"       FORMAT "X(20)"
   FIELD _label2         AS CHAR     LABEL "Label2"      FORMAT "X(20)" /* minus '&' */
   FIELD _order          AS INTEGER  LABEL "Order"
   FIELD _icon_up        AS CHAR     LABEL "Up Icon"     FORMAT "X(20)"
   FIELD _icon_up_x      AS INTEGER  
   FIELD _icon_up_y      AS INTEGER
   FIELD _h_up_image     AS WIDGET-HANDLE
   FIELD _icon_down      AS CHAR     LABEL "Down Icon"   FORMAT "X(20)"
   FIELD _icon_down_x    AS INTEGER  
   FIELD _icon_down_y    AS INTEGER
   FIELD _New_Template   AS CHAR     LABEL "New Template" FORMAT "X(20)"
   FIELD _dbconnect      AS LOGICAL  INITIAL NO
   FIELD _attr           AS CHAR     /* Holds default settings (like _custom._attr) */
   FIELD _files          AS CHAR     LABEL "Cst Files"    FORMAT "X(256)"
   FIELD _object_class   AS CHAR     LABEL "Object Type Code"        FORMAT "X(20)"
   FIELD _object_name    AS CHAR     LABEL "Object Name"             FORMAT "X(50)" 
   INDEX _name IS PRIMARY _name
   INDEX _order           _order
   INDEX _label2          _label2.

DEFINE {1} SHARED TEMP-TABLE _save_custom NO-UNDO LIKE _custom.
DEFINE {1} SHARED TEMP-TABLE _save_palette_item NO-UNDO LIKE _palette_item.
