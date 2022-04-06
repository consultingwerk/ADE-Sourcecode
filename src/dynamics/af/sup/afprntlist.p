&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afprntlist.p

  Description:  Printer list

  Purpose:      Returns a list of printer names and portnames loaded.

                Example of use:
                DEFINE VARIABLE lv_printname    AS CHARACTER NO-UNDO.
                DEFINE VARIABLE lv_portname     AS CHARACTER NO-UNDO.
                DEFINE VARIABLE lv_drivername   AS CHARACTER NO-UNDO.
                DEFINE VARIABLE lv_sharename    AS CHARACTER NO-UNDO.
                DEFINE VARIABLE lv_servername   AS CHARACTER NO-UNDO.


                RUN af/sup/afprntlist.p(OUTPUT lv_printname,
                OUTPUT lv_portname,
                OUTPUT lv_drivername,
                OUTPUT lv_sharename,
                OUTPUT lv_servername
                ).

                MESSAGE "printer = " lv_printname skip
                "port    = " lv_portname skip
                "driver = " lv_drivername SKIP
                "share = " lv_sharename SKIP
                "server = " lv_servername SKIP
                .

  Parameters:   op_printername
                op_portname
                op_drivername
                op_sharename
                op_servername

  History:
  --------
  (v:010000)    Task:        1239   UserRef:    
                Date:   22/06/1999  Author:     Jenny Bond

  Update Notes: Only lists printers where the driver is installed locally.
                Copied from Jurjen's API site.
                Created from Template aftemprocp.p

  (v:010001)    Task:        2428   UserRef:    
                Date:   24/08/1999  Author:     Anthony Swindells

  Update Notes: Modify to work on NT also

  (v:010002)    Task:        2562   UserRef:    
                Date:   26/08/1999  Author:     Anthony Swindells

  Update Notes: Add error checking

  (v:010003)    Task:        7761   UserRef:    
                Date:   30/01/2001  Author:     Peter Judge

  Update Notes: BUG/ Window system is checking for "Windows NT" instead of "WinNT", and
                so fails to retrieve the list of network printers.

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afprntlist.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE OUTPUT PARAMETER op_printername  AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_portname     AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_drivername   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_sharename    AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_servername   AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.52
         WIDTH              = 47.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{af/sup/windows.i}

DEFINE VARIABLE pPrinterEnum  AS MEMPTR NO-UNDO.
DEFINE VARIABLE pcbNeeded     AS INTEGER NO-UNDO.
DEFINE VARIABLE pcReturned    AS INTEGER NO-UNDO.
DEFINE VARIABLE RetValue      AS INTEGER NO-UNDO.

DEFINE VARIABLE pPrinterInfo  AS MEMPTR NO-UNDO.
DEFINE VARIABLE StructSize    AS INTEGER INITIAL 84.

DEFINE VARIABLE i             AS INTEGER NO-UNDO.
DEFINE VARIABLE lpPrinterName AS MEMPTR  NO-UNDO.
DEFINE VARIABLE lpPortName    AS MEMPTR  NO-UNDO.
DEFINE VARIABLE lpDriverName  AS MEMPTR  NO-UNDO.
DEFINE VARIABLE lpShareName   AS MEMPTR  NO-UNDO.
DEFINE VARIABLE lpServerName  AS MEMPTR  NO-UNDO.

DEFINE VARIABLE lv_winsys     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_memory     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_string     AS CHARACTER NO-UNDO.

  RUN af/sup/afwindsysp.p
      ( OUTPUT lv_winsys,
        OUTPUT lv_memory).

  /* The first call to EnumPrinters is only to 
     get the required memory size */

   SET-SIZE(pPrinterEnum) = 30.  /* A default bobo value */

   IF INDEX(lv_winsys,"Windows NT":U) = 0 AND 
      INDEX(lv_winsys,"WinNT":U)      = 0 THEN
   DO:   
      RUN EnumPrinters{&A} IN hpApi(2, /* = PRINTER_ENUM_LOCAL */
                                    "", 
                                    2, 
                                    GET-POINTER-VALUE(pPrinterEnum),
                                    GET-SIZE(pPrinterEnum), 
                                    OUTPUT pcbNeeded, 
                                    OUTPUT pcReturned, 
                                    OUTPUT RetValue).
   END.
   ELSE
   DO:   
      RUN EnumPrinters{&A} IN hpApi(6, /* = PRINTER_ENUM_LOCAL + Server */
                                    "", 
                                    2, 
                                    GET-POINTER-VALUE(pPrinterEnum),
                                    GET-SIZE(pPrinterEnum), 
                                    OUTPUT pcbNeeded, 
                                    OUTPUT pcReturned, 
                                    OUTPUT RetValue).
   END.

   /* RetValue will now be FALSE (=error) because we did not
      supply enough memory. But at least we know now how much
      memory was required (pcbNeeded) and also how many printers
      were found (pcReturned) */

   /* no printers installed, then return (rare) */
   IF pcbNeeded=0 THEN DO:
/*      message "No printers found".*/
      RUN DeAlloc.
      RETURN.
   END.

   /* Reset the size of pPrinterEnum to the correct size */
   SET-SIZE(pPrinterEnum) = 0.
   SET-SIZE(pPrinterEnum) = pcbNeeded.

   /* The second call actually fills the pPrinterEnum structure */

  IF INDEX(lv_winsys,"Windows NT":U) = 0 AND
     INDEX(lv_winsys,"WinNT":U)      = 0 THEN
     DO:   
        RUN EnumPrinters{&A} IN hpApi(2,  /* = PRINTER_ENUM_LOCAL */
                                      "", 
                                      2,
                                      GET-POINTER-VALUE (pPrinterEnum),
                                      GET-SIZE(pPrinterEnum), 
                                      OUTPUT pcbNeeded,
                                      OUTPUT pcReturned, 
                                      OUTPUT RetValue).
    END.
  ELSE 
     DO:   
        RUN EnumPrinters{&A} IN hpApi(6,  /* = PRINTER_ENUM_LOCAL + Server */
                                      "", 
                                      2,
                                      GET-POINTER-VALUE (pPrinterEnum),
                                      GET-SIZE(pPrinterEnum), 
                                      OUTPUT pcbNeeded,
                                      OUTPUT pcReturned, 
                                      OUTPUT RetValue).
    END.

   /* pPrinterEnum holds a couple of PRINTER_INFO_2 records.
      the number of records is pcReturned.
      the number of bytes copied to pPrinterEnum is pcbNeeded.
      size of one PRINTER_INFO_2 record is 84 bytes.
   */

   DO i=0 TO pcReturned - 1 :       

      SET-POINTER-VALUE(pPrinterInfo) = GET-POINTER-VALUE(pPrinterEnum) + (i * StructSize).

      /* the second LONG field in the PRINTER_INFO_2 structure is 
         a pointer to a string holding the printer name */
      SET-POINTER-VALUE(lpPrinterName) = GET-LONG(pPrinterInfo, 5).

      /* the 4th LONG field in the PRINTER_INFO_2 structure is 
         a pointer to a string holding the port name */
      SET-POINTER-VALUE(lpPortName)    = GET-LONG(pPrinterInfo,13).

      SET-POINTER-VALUE(lpDriverName)  = GET-LONG(pPrinterInfo,17).
      SET-POINTER-VALUE(lpShareName)   = GET-LONG(pPrinterInfo,9).
      SET-POINTER-VALUE(lpServerName)  = GET-LONG(pPrinterInfo,1).

        ASSIGN
        lv_string = IF GET-POINTER-VALUE(lpPrinterName) > 0 THEN GET-STRING(lpPrinterName,1) ELSE "?":U
        op_printername = IF  op_printername = "" OR op_printername = ? THEN 
                            lv_string
                         ELSE op_printername + "|" + lv_string
        lv_string = IF GET-POINTER-VALUE(lpPortName) > 0 THEN GET-STRING(lpPortName,1) ELSE "?":U
        op_portname    = IF  op_portname = "" OR op_portname = ? THEN
                            lv_string
                         ELSE op_portname + "|" + lv_string
        lv_string = IF GET-POINTER-VALUE(lpDriverName) > 0 THEN GET-STRING(lpDriverName,1) ELSE "?":U
        op_drivername  = IF  op_drivername = "" OR op_drivername = ? THEN
                            lv_string
                         ELSE op_drivername + "|" + lv_string
        lv_string = IF GET-POINTER-VALUE(lpShareName) > 0 THEN GET-STRING(lpShareName,1) ELSE "?":U
        op_sharename  = IF  op_sharename = "" OR op_sharename = ? THEN
                            lv_string
                         ELSE op_sharename + "|" + lv_string
        lv_string = IF GET-POINTER-VALUE(lpServerName) > 0 THEN GET-STRING(lpServerName,1) ELSE "?":U
        op_servername  = IF  op_servername = "" OR op_servername = ? THEN
                            lv_string
                         ELSE op_servername + "|" + lv_string
                         .

   END.

    ASSIGN
        op_printername = REPLACE(op_printername,"?":U,"":U)
        op_portname = REPLACE(op_portname,"?":U,"":U)
        op_drivername = REPLACE(op_drivername,"?":U,"":U)
        op_sharename = REPLACE(op_sharename,"?":U,"":U)
        op_servername = REPLACE(op_servername,"?":U,"":U)
        .

   /* Clean Up  */
   RUN DeAlloc.

PROCEDURE DeAlloc:
   SET-SIZE(pPrinterEnum) = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


