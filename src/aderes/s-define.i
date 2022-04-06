/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * s-define.i - system-wide defines
 */

/*--------------------------------------------------------------------------*/
/* file lists */
DEFINE {1} SHARED VARIABLE qbf-tables AS CHARACTER NO-UNDO.

DEFINE {1} SHARED TEMP-TABLE qbf-section NO-UNDO
  FIELD qbf-sout AS CHARACTER  /* outline */
  FIELD qbf-stbl AS CHARACTER  /* sub-table list */
  FIELD qbf-sfrm AS CHARACTER  /* frame name for this sect's vars */
  FIELD qbf-shdl AS HANDLE     /* frame handle for this section */
  FIELD qbf-sctr AS INTEGER    /* monotonic sequential section numbers */
  FIELD qbf-smdl AS LOGICAL    /* start of a master-detail level */
  FIELD qbf-sojo AS LOGICAL    /* outer-join flag: false=inner true=outer */
  FIELD qbf-sort AS CHARACTER  /* comma-sep list of order-bys */
  FIELD qbf-sxtb AS CHARACTER  /* cross-tab by this field */
  FIELD qbf-swid AS INTEGER    /* section width */
  INDEX qbf-section-ix1 IS UNIQUE PRIMARY qbf-sout
  INDEX qbf-section-ix2 qbf-sctr. /* do NOT make unique! */

/*
qbf-sout = "1" for main section
         = "1.1" for first subsection
         = "1.1.1" for first subsubsection of first subsection
         = "1.1.2" for second subsubsection of first subsection
         = "1.2" for second subsection
         = "1.2.1" for first subsubsection of second subsection
         = "1.2.2" for second subsubsection of second subsection
         = "1.2.2.1" for first subsubsubsection of above
  and so forth.

qbf-sort = "field [DESC][,field [DESC]]..."
*/

DEFINE {1} SHARED TEMP-TABLE qbf-where /* NOT NO-UNDO */
  FIELD qbf-wtbl AS INTEGER
  FIELD qbf-wrel AS CHARACTER  /* relation where clause */
  FIELD qbf-wrid AS CHARACTER  /* table id that the relation is based on */
  FIELD qbf-acls AS CHARACTER  /* admin defined where clause */
  FIELD qbf-wcls AS CHARACTER  /* selection where clause */
  FIELD qbf-wsec AS CHARACTER  /* security where clause */
  FIELD qbf-wask AS CHARACTER  /* asked clause */
  FIELD qbf-winc AS CHARACTER  /* code to be included at this level */
  FIELD qbf-wojo AS LOGICAL    /* outer-join flag: false=inner true=outer */
  INDEX qbf-where-ix1 IS UNIQUE qbf-wtbl.

/* master sortby list */
DEFINE {1} SHARED VARIABLE qbf-sortby AS CHARACTER NO-UNDO.
/*qbf-sortby = "field [DESC][,field [DESC]]..."*/

/*
DEFINE {1} SHARED TEMP-TABLE qbf-future3 NO-UNDO /* qbf-keys */
  FIELD qbf-kpos AS INTEGER
  FIELD qbf-krec AS RECID
  FIELD qbf-kchr AS CHARACTER EXTENT 16
  FIELD qbf-kdat AS DATE      EXTENT 16
  FIELD qbf-klog AS LOGICAL   EXTENT 16
  FIELD qbf-kint AS INTEGER   EXTENT 16
  FIELD qbf-kdec AS DECIMAL   EXTENT 16 DECIMALS 10.
*/

/*--------------------------------------------------------------------------*/
/*field-level stuff:*/
/*
qbf-rc#
qbf-rcn[]: field-names
      	   Entry 1:  the field name (e.g. demo.Customer.Name or qbf-001)
      	   Entry 2-n depends on the field type as follows:
      	       Percent of Total and Running Total (entry 2):
      	       	  The field name total is based on (e.g. sports.Invoice.Amount)
      	       Counter (entry 2 and 3):
      	       	  n,m (where n is start value and m is increment by value)
      	       String,Date,Numeric,Logical,Math expression (entry 2):
      	       	  entry 2 = expression (e.g., DAY(demo.Order.ODate))
      	       Stacked Array (entry 2)
      	       	  the name of the array field (e.g., demo.Customer.Month-Sales)
      	       Lookup (entries 2 - 7)
      	       	  <source table>,<source field>,<match table>,<match field>,
      	       	  <display field>,<no-match string>
      	       	  (e.g., sports.Customer,State,sports.State,State,Region,?)
      	       	  NOTE: This can refer to tables that are not in the 
      	       	  query.

qbf-rcl[]: field-labels
qbf-rcf[]: field-formats
qbf-rcc[]: calc field stuff
      	   If the field is a regular database field, qbf-rcc = "".
	   Otherwise, entry 1 of rcc indicates the type of calc'ed field
      	   (except when the first character is e - then the auxilliary
      	   info is lumped into entry 1 with the "e"!)
	      r = Running Total
	      p = Percent of Total
	      c = Counter
	      s = String
	      d = Date
	      n = Numeric
	      l = Logical
	      e = Stacked Array
	      x = Lookup
      	   Entry 2-n depends on the field type as follows:
      	      r,p (no other entries)
      	      c (entry 2)
      	       	  < = outer most, > = inner most, * = all sections
      	      s,d,n,l (entry 2 - n):
      	       	  the fields involved in the expression 
      	       	  (e.g., demo.Customer.Name,demo.Customer.City)
      	      e (remainder of entry 1)
      	          the extent of the array field (e.g., e12)
      	      x (no other entries)

qbf-rcg[]: totals/subtotals/totals only summary/hide repeating
	      & = hide repeating values.  This only works on non-stacked-array
		  and non-aggregate fields.  If present, it will be the only 
		  character in qbf-rcg[n].
	      $ = Field is involved in Totals only summary.  May be combined
		  with aggregate specification as described next (e.g., n1$).
      	   The following are aggregate types.  If an aggregate, there will
      	   be one of these letters followed by "0" or "<n>".  0 means
      	   summary line and <n> is an index into the sort field list and
      	   means to aggregate based on a break group (e.g., n2 or t0).
      	   There can be more than one of these for a field (e.g., a1t3).
	      a = average / sub-average
	      n = minimum / sub-minimum
	      x = maximum / sub-maximum
	      c = count / sub-count
	      t = total / sub-total

qbf-rcw[]: field-widths
qbf-rct[]: data-types - 1=char,2=date,3=log,4=int,5=dec
qbf-rcp[]: position "rep-col,rep-row,frm-col,frm-row,lbl-col,lbl-row"
qbf-rcs[]: comma-sep section list in outline (matches qbf-section.qbf-sout)

NOTE: rcl, rcf and rcp are undo-able for cancel support in prop. dialog.
*/
DEFINE {1} SHARED VARIABLE qbf-rc# AS INTEGER             NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcn AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcl AS CHARACTER EXTENT 64.
DEFINE {1} SHARED VARIABLE qbf-rcf AS CHARACTER EXTENT 64.
DEFINE {1} SHARED VARIABLE qbf-rcg AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcc AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcw AS INTEGER   EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rct AS INTEGER   EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-rcp AS CHARACTER EXTENT 64.
DEFINE {1} SHARED VARIABLE qbf-rcs AS CHARACTER EXTENT 64 NO-UNDO.

/* Entries in qbf-rcp comma separted list */
&GLOBAL-DEFINE R_COL 1 	/* report column */
&GLOBAL-DEFINE R_ROW 2  /* report row */
&GLOBAL-DEFINE F_COL 3  /* form column */
&GLOBAL-DEFINE F_ROW 4  /* form row */
&GLOBAL-DEFINE L_COL 5  /* label column */
&GLOBAL-DEFINE L_ROW 6  /* label row */

DEFINE TEMP-TABLE ttField NO-UNDO
  FIELD ttFieldPos   AS INTEGER	 /* position */
  FIELD ttFieldNam   AS CHARACTER	 /* name */
  FIELD ttFieldLbl   AS CHARACTER	 /* label */
  FIELD ttFieldFmt   AS CHARACTER	 /* format */
  FIELD ttFieldAgg   AS CHARACTER	 /* aggregate information */
  FIELD ttFieldTyp   AS CHARACTER	 /* datatype */
  FIELD ttFieldCal   AS CHARACTER	 /* for calculated fields */
  FIELD ttFieldFil   AS INTEGER	 /* table id in qbf-rel-tt */
  FIELD ttFieldDec   AS INTEGER	 /* decimal places */
  FIELD ttFieldWid   AS INTEGER	 /* width */
  FIELD ttFieldHit   AS INTEGER	 /* height */
  FIELD ttFieldRRow  AS INTEGER   /* Report row position */
  FIELD ttFieldRCol  AS INTEGER   /* Report column position */
  FIELD ttFieldFRow  AS INTEGER   /* Form row position */
  FIELD ttFieldFCol  AS INTEGER   /* Form column position */
  FIELD ttFieldLRow  AS INTEGER   /* Label row position */
  FIELD ttFieldLCol  AS INTEGER   /* Label column position */
  FIELD ttFieldBRow  AS INTEGER   /* Browse row position */
  FIELD ttFieldBCol  AS INTEGER   /* Browse column position */
  FIELD ttFieldTOnly AS LOGICAL  /*  totals-only? (y/n)*/
  FIELD ttFieldHideR AS LOGICAL	 /*  hide repeating values? (y/n) */
  FIELD ttFieldReadO AS LOGICAL	 /*  read-only? (y/n) */
  .								 

/*--------------------------------------------------------------------------*/
/*labels stuff:*/
/*
qbf-l-auto[1..10]: can-do style patterns for selecting fields:
                   name,addr1,addr2,addr3,city,state,zip,zip+4,csz,country
qbf-l-text[1..64]: label text and fields (note UNDO-able!)
*/
DEFINE {1} SHARED VARIABLE qbf-l-auto AS CHARACTER EXTENT   10 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-l-text AS CHARACTER EXTENT   66.

/*--------------------------------------------------------------------------*/
/*
 * Global permission stuff. This array holds the availability of views
 * to the user. The information is retrieved once and then stored. This
 * information is used when opeinging a query.
 */

DEFINE {1} SHARED VARIABLE _viewPermission AS LOGICAL EXTENT 5
                                           INITIAL ? NO-UNDO.

DEFINE {1} SHARED VARIABLE _newViewPermission AS LOGICAL EXTENT 5
                                              INITIAL ? NO-UNDO.

/* s-define.i - end of file */

