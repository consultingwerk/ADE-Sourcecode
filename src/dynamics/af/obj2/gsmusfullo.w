&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" dTables _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDataObjectWizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* SmartDataObject Wizard
Welcome to the SmartDataObject Wizard! During the next few steps, the wizard will lead you through creating a SmartDataObject. You will define the query that you will use to retrieve data from your database(s) and define a set of field values to make available to visualization objects. Press Next to proceed.
adm2/support/_wizqry.w,adm2/support/_wizfld.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmusfullo.w

  Description:  User SmartDataObject

  Purpose:      User SmartDataObject

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/07/2002  Author:     Mark Davies (MIP)

  Update Notes: This SDO was regenerated to create the new logic procedure.

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmusfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{src/adm2/globals.i}

&glob DATA-LOGIC-PROCEDURE       af/app/gsmusplipp.p

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsm_user gsm_user_category gsc_language

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  confirm_password user_category_obj user_full_name user_login_name~
 user_creation_date user_creation_time profile_user~
 created_from_profile_user_obj external_userid user_password~
 password_minimum_length password_preexpired password_fail_count~
 password_fail_date password_fail_time password_creation_date~
 password_creation_time password_expiry_date password_expiry_time~
 update_password_history check_password_history last_login_date~
 last_login_time language_obj disabled password_expiry_days~
 maintain_system_data default_login_company_obj user_email_address~
 development_user
&Scoped-define ENABLED-FIELDS-IN-gsm_user user_category_obj user_full_name ~
user_login_name user_creation_date user_creation_time profile_user ~
created_from_profile_user_obj external_userid user_password ~
password_minimum_length password_preexpired password_fail_count ~
password_fail_date password_fail_time password_creation_date ~
password_creation_time password_expiry_date password_expiry_time ~
update_password_history check_password_history last_login_date ~
last_login_time language_obj disabled password_expiry_days ~
maintain_system_data default_login_company_obj user_email_address ~
development_user 
&Scoped-Define DATA-FIELDS  user_obj confirm_password c_profile_user fmt_user_create_time~
 fmt_user_login_time fmt_password_fail_time fmt_password_create_time~
 fmt_password_expire_time user_category_obj user_category_code~
 user_full_name user_login_name user_creation_date user_creation_time~
 profile_user created_from_profile_user_obj external_userid user_password~
 password_minimum_length password_preexpired password_fail_count~
 password_fail_date password_fail_time password_creation_date~
 password_creation_time password_expiry_date password_expiry_time~
 update_password_history check_password_history last_login_date~
 last_login_time language_obj language_code disabled password_expiry_days~
 maintain_system_data default_login_company_obj user_email_address~
 development_user oldPasswordExpiryDate
&Scoped-define DATA-FIELDS-IN-gsm_user user_obj user_category_obj ~
user_full_name user_login_name user_creation_date user_creation_time ~
profile_user created_from_profile_user_obj external_userid user_password ~
password_minimum_length password_preexpired password_fail_count ~
password_fail_date password_fail_time password_creation_date ~
password_creation_time password_expiry_date password_expiry_time ~
update_password_history check_password_history last_login_date ~
last_login_time language_obj disabled password_expiry_days ~
maintain_system_data default_login_company_obj user_email_address ~
development_user 
&Scoped-define DATA-FIELDS-IN-gsm_user_category user_category_code 
&Scoped-define DATA-FIELDS-IN-gsc_language language_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmusfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_user NO-LOCK, ~
      FIRST gsm_user_category WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj NO-LOCK, ~
      FIRST gsc_language WHERE gsc_language.language_obj = gsm_user.language_obj OUTER-JOIN NO-LOCK ~
    BY gsm_user.user_login_name INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_user NO-LOCK, ~
      FIRST gsm_user_category WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj NO-LOCK, ~
      FIRST gsc_language WHERE gsc_language.language_obj = gsm_user.language_obj OUTER-JOIN NO-LOCK ~
    BY gsm_user.user_login_name INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_user gsm_user_category ~
gsc_language
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_user
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsm_user_category
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_language


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProfileUser dTables  _DB-REQUIRED
FUNCTION getProfileUser RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_user, 
      gsm_user_category
    FIELDS(gsm_user_category.user_category_code), 
      gsc_language
    FIELDS(gsc_language.language_code) SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "ICFDB.gsm_user,ICFDB.gsm_user_category WHERE ICFDB.gsm_user ...,ICFDB.gsc_language WHERE ICFDB.gsm_user ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION "
     _TblOptList       = ", FIRST USED, FIRST OUTER USED"
     _OrdList          = "ICFDB.gsm_user.user_login_name|yes"
     _JoinCode[2]      = "gsm_user_category.user_category_obj = gsm_user.user_category_obj"
     _JoinCode[3]      = "ICFDB.gsc_language.language_obj = ICFDB.gsm_user.language_obj"
     _FldNameList[1]   > ICFDB.gsm_user.user_obj
"user_obj" "user_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 24 yes
     _FldNameList[2]   > "_<CALC>"
"STRING(RowObject.user_password)" "confirm_password" "Confirm Password" "x(35)" "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[3]   > "_<CALC>"
"getProfileUser()" "c_profile_user" "Based on Profile" "x(15)" "character" ? ? ? ? ? ? no ? no 15 no
     _FldNameList[4]   > "_<CALC>"
"STRING(RowObject.user_creation_time,""HH:MM:SS"":U)" "fmt_user_create_time" "User Creation Time" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no
     _FldNameList[5]   > "_<CALC>"
"STRING(RowObject.last_login_time,""HH:MM:SS"":U)" "fmt_user_login_time" "Last Login Time" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no
     _FldNameList[6]   > "_<CALC>"
"STRING(RowObject.password_fail_time,""HH:MM:SS"":U)" "fmt_password_fail_time" "Password Fail Time" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no
     _FldNameList[7]   > "_<CALC>"
"STRING(RowObject.password_creation_time,""HH:MM:SS"":U)" "fmt_password_create_time" "Password Creation Time" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no
     _FldNameList[8]   > "_<CALC>"
"STRING(RowObject.password_expiry_time,""HH:MM:SS"":U)" "fmt_password_expire_time" "Password Expiry Time" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no
     _FldNameList[9]   > ICFDB.gsm_user.user_category_obj
"user_category_obj" "user_category_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[10]   > ICFDB.gsm_user_category.user_category_code
"user_category_code" "user_category_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[11]   > ICFDB.gsm_user.user_full_name
"user_full_name" "user_full_name" ? ? "character" ? ? ? ? ? ? yes ? no 140 no
     _FldNameList[12]   > ICFDB.gsm_user.user_login_name
"user_login_name" "user_login_name" ? ? "character" ? ? ? ? ? ? yes ? no 30 no
     _FldNameList[13]   > ICFDB.gsm_user.user_creation_date
"user_creation_date" "user_creation_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[14]   > ICFDB.gsm_user.user_creation_time
"user_creation_time" "user_creation_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[15]   > ICFDB.gsm_user.profile_user
"profile_user" "profile_user" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[16]   > ICFDB.gsm_user.created_from_profile_user_obj
"created_from_profile_user_obj" "created_from_profile_user_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[17]   > ICFDB.gsm_user.external_userid
"external_userid" "external_userid" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[18]   > ICFDB.gsm_user.user_password
"user_password" "user_password" ? ? "character" ? ? ? ? ? ? yes ? no 70 no
     _FldNameList[19]   > ICFDB.gsm_user.password_minimum_length
"password_minimum_length" "password_minimum_length" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[20]   > ICFDB.gsm_user.password_preexpired
"password_preexpired" "password_preexpired" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[21]   > ICFDB.gsm_user.password_fail_count
"password_fail_count" "password_fail_count" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[22]   > ICFDB.gsm_user.password_fail_date
"password_fail_date" "password_fail_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[23]   > ICFDB.gsm_user.password_fail_time
"password_fail_time" "password_fail_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[24]   > ICFDB.gsm_user.password_creation_date
"password_creation_date" "password_creation_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[25]   > ICFDB.gsm_user.password_creation_time
"password_creation_time" "password_creation_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[26]   > ICFDB.gsm_user.password_expiry_date
"password_expiry_date" "password_expiry_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[27]   > ICFDB.gsm_user.password_expiry_time
"password_expiry_time" "password_expiry_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[28]   > ICFDB.gsm_user.update_password_history
"update_password_history" "update_password_history" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[29]   > ICFDB.gsm_user.check_password_history
"check_password_history" "check_password_history" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[30]   > ICFDB.gsm_user.last_login_date
"last_login_date" "last_login_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[31]   > ICFDB.gsm_user.last_login_time
"last_login_time" "last_login_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[32]   > ICFDB.gsm_user.language_obj
"language_obj" "language_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[33]   > ICFDB.gsc_language.language_code
"language_code" "language_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[34]   > ICFDB.gsm_user.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[35]   > ICFDB.gsm_user.password_expiry_days
"password_expiry_days" "password_expiry_days" ? ? "integer" ? ? ? ? ? ? yes ? no 4 no
     _FldNameList[36]   > ICFDB.gsm_user.maintain_system_data
"maintain_system_data" "maintain_system_data" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[37]   > ICFDB.gsm_user.default_login_company_obj
"default_login_company_obj" "default_login_company_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[38]   > ICFDB.gsm_user.user_email_address
"user_email_address" "user_email_address" ? ? "character" ? ? ? ? ? ? yes ? no 70 no
     _FldNameList[39]   > ICFDB.gsm_user.development_user
"development_user" "development_user" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[40]   > "_<CALC>"
"RowObject.password_expiry_date" "oldPasswordExpiryDate" ? "99/99/9999" "Date" ? ? ? ? ? ? no ? no 3.4 no
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.confirm_password = (STRING(RowObject.user_password))
         rowObject.c_profile_user = (getProfileUser())
         rowObject.fmt_password_create_time = (STRING(RowObject.password_creation_time,"HH:MM:SS":U))
         rowObject.fmt_password_expire_time = (STRING(RowObject.password_expiry_time,"HH:MM:SS":U))
         rowObject.fmt_password_fail_time = (STRING(RowObject.password_fail_time,"HH:MM:SS":U))
         rowObject.fmt_user_create_time = (STRING(RowObject.user_creation_time,"HH:MM:SS":U))
         rowObject.fmt_user_login_time = (STRING(RowObject.last_login_time,"HH:MM:SS":U))
         rowObject.oldPasswordExpiryDate = (RowObject.password_expiry_date)
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProfileUser dTables  _DB-REQUIRED
FUNCTION getProfileUser RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER bgsm_user FOR gsm_user.

    IF AVAILABLE rowObject THEN
    DO:
        FIND FIRST bgsm_user NO-LOCK
            WHERE bgsm_user.user_obj = rowObject.created_from_profile_user_obj
            NO-ERROR.
        IF AVAILABLE bgsm_user THEN
        DO:
            RETURN bgsm_user.USER_login_name.
        END.
        ELSE
            RETURN "":U.
    END.
    ELSE       
       RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

