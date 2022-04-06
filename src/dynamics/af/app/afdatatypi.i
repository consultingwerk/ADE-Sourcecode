/*---------------------------------------------------------------------------------
         File: afdatatypi.i
         
  Description: Contains pre-processor code which maps a name to a value
               for data-types.
  
        Notes: * This information is used when storing attributes since 
                 the data-type is stored in integer form. These preprocessors
                 make the integer values more human()or at elast developer)
                 -readable.

      History:
      --------
      14 March 2002   PeterJudge    Created from scratch.
  
---------------------------------------------------------------------------*/
&GLOBAL-DEFINE CHARACTER-DATA-TYPE    1
&GLOBAL-DEFINE DATE-DATA-TYPE         2
&GLOBAL-DEFINE LOGICAL-DATA-TYPE      3
&GLOBAL-DEFINE INTEGER-DATA-TYPE      4
&GLOBAL-DEFINE DECIMAL-DATA-TYPE      5
/* Reserved for future use
&GLOBAL-DEFINE -DATA-TYPE             6
*/
&GLOBAL-DEFINE RECID-DATA-TYPE        7
&GLOBAL-DEFINE RAW-DATA-TYPE          8
&GLOBAL-DEFINE ROWID-DATA-TYPE        9
&GLOBAL-DEFINE HANDLE-DATA-TYPE      10
&GLOBAL-DEFINE BLOB-DATA-TYPE        18
&GLOBAL-DEFINE CLOB-DATA-TYPE        19
&GLOBAL-DEFINE DATETIME-DATA-TYPE    34
&GLOBAL-DEFINE DATETIME-TZ-DATA-TYPE 40
&GLOBAL-DEFINE INT64-DATA-TYPE       41

/*EOF*/
