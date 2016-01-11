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
/* s-exp.i - expressions table */

ASSIGN
  qbf-x[001] = 's|s000=s172|&1|':u
             + 'String Constant or Field':t64
  qbf-x[002] = 's|s000=s170n162n163|SUBSTRING(&1,INTEGER(&2),INTEGER(&3))|':u
             + 'Substring':t64
  qbf-x[003] = 's|s000=s164s165|&1 + &2|':u
             + 'Combine Strings':t64
  qbf-x[004] = 's|s000=s179s180|MINIMUM(&1,&2)|':u
             + 'Lesser of Two Strings':t64
  qbf-x[005] = 's|s000=s179s180|MAXIMUM(&1,&2)|':u
             + 'Greater of Two Strings':t64
  qbf-x[006] = 's|n000=s168|LENGTH(&1)|':u
             + 'Length of String':t64
  qbf-x[007] = 's|s000=|USERID("RESULTSDB")|':u
             + 'User ID':t64
  qbf-x[008] = 's|s000=|STRING(TIME,"HH:MM:SS")|':u
             + 'Current Time':t64
  qbf-x[009] = 'n|n000=n172|&1|':u
             + 'Numeric Constant or Field':t64
  qbf-x[010] = 'n|n000=n179n180|MINIMUM(&1,&2)|':u
             + 'Smaller of Two Numbers':t64
  qbf-x[011] = 'n|n000=n179n180|MAXIMUM(&1,&2)|':u
             + 'Greater of Two Numbers':t64
  qbf-x[012] = 'n|n000=n177n178|&1 MODULO &2|':u
             + 'Remainder':t64
  qbf-x[013] = 'n|n000=n173|ABSOLUTE(&1)|':u
             + 'Absolute Value':t64
  qbf-x[014] = 'n|n000=n174|ROUND(&1,0)|':u
             + 'Round':t64
  qbf-x[015] = 'n|n000=n175|TRUNCATE(&1,0)|':u
             + 'Truncate':t64
  qbf-x[016] = 'n|n000=n176|SQRT(&1)|':u
             + 'Square Root':t64.

ASSIGN
  qbf-x[017] = 'n|n000=n171|EXP(&1,1 / 3)|':u
             + 'Cube Root':t64
  qbf-x[018] = 'n|n000=n166|LOG(&1)|':u
             + 'Log Base e':t64
  qbf-x[019] = 'n|n000=n166n167|LOG(&1,&2)|':u
             + 'Log Base n':t64
  qbf-x[020] = 's|s000=n169|STRING(INTEGER(&1),"HH:MM:SS")|':u
             + 'Display as Time':t64 
  qbf-x[021] = 'd|d000=|TODAY|':u
             + 'Current Date':t64
  qbf-x[022] = 'd|d000=d181n182|&1 + &2|':u
             + 'Add Days to Date Value':t64
  qbf-x[023] = 'd|d000=d181n183|&1 - &2|':u
             + 'Subtract Days from Date Value':t64
  qbf-x[024] = 'd|n000=d184d185|&1 - &2|':u
             + 'Difference between Two Dates':t64
  qbf-x[025] = 'd|d000=d179d180|MINIMUM(&1,&2)|':u
             + 'Earlier of Two Dates':t64
  qbf-x[026] = 'd|d000=d179d180|MAXIMUM(&1,&2)|':u
             + 'Later of Two Dates':t64
  qbf-x[027] = 'd|n000=d186|DAY(&1)|':u
             + 'Day of Month':t64
  qbf-x[028] = 'd|n000=d187|MONTH(&1)|':u
             + 'Month of Year':t64
  qbf-x[029] = 's|s000=d188|ENTRY(MONTH(&1),qbf-month-names)|':u 
             + 'Name of Month':t64
  qbf-x[030] = 'd|n000=d189|YEAR(&1)|':u
             + 'Year Value':t64
  qbf-x[031] = 'd|n000=d190|WEEKDAY(&1)|':u
             + 'Day of Week':t64
  qbf-x[032] = 's|s000=d191|ENTRY(WEEKDAY(&1),qbf-day-names)|':u
             + 'Name of Weekday':t64. 

ASSIGN
  qbf-x[033] = 'm|n000=n192n193|&1 + &2|':u
             + 'Add':t64
  qbf-x[034] = 'm|n000=n192n194|&1 - &2|':u
             + 'Subtract':t64
  qbf-x[035] = 'm|n000=n195n196|&1 * &2|':u
             + 'Multiply':t64
  qbf-x[036] = 'm|n000=n197n198|&1 / &2|':u
             + 'Divide':t64
  qbf-x[037] = 'm|n000=n192n199|EXP(&1,&2)|':u
             + 'Raise to a Power':t64
  qbf-x[038] = 'l|l000=s160s161|&1 = &2|':u
             + 'Strings Equal':t64
  qbf-x[039] = 'l|l000=s160s161|&1 <> &2|':u
             + 'Strings Not Equal':t64
  qbf-x[040] = 'l|l000=s160s161|&1 < &2|':u
             + 'Strings Less Than':t64
  qbf-x[041] = 'l|l000=s160s161|&1 <= &2|':u
             + 'Strings Less or Equal':t64
  qbf-x[042] = 'l|l000=s160s161|&1 > &2|':u
             + 'Strings Greater Than':t64
  qbf-x[043] = 'l|l000=s160s161|&1 >= &2|':u
             + 'Strings Greater or Equal':t64
  qbf-x[044] = 'l|l000=s157s158|&1 BEGINS &2|':u
             + 'Begins':t64
  qbf-x[045] = 'l|l000=s157s156|&1 MATCHES &2|':u
             + 'Matches':t64
  qbf-x[046] = 's|s000=l159s159s159|IF &1 THEN (&2) ELSE (&3)|':u
    + 'If first expression is true return second else third string':t64 
  qbf-x[047] = 'l|l000=d160d161|&1 = &2|':u
             + 'Dates Equal':t64
  qbf-x[048] = 'l|l000=d160d161|&1 <> &2|':u
             + 'Dates Not Equal':t64.

ASSIGN
  qbf-x[049] = 'l|l000=d160d161|&1 < &2|':u
             + 'Dates Less Than':t64
  qbf-x[050] = 'l|l000=d160d161|&1 <= &2|':u
             + 'Dates Less or Equal':t64
  qbf-x[051] = 'l|l000=d160d161|&1 > &2|':u
             + 'Dates Greater Than':t64
  qbf-x[052] = 'l|l000=d160d161|&1 >= &2|':u
             + 'Dates Greater or Equal':t64
  qbf-x[053] = 'd|d000=l159d159d159|IF &1 THEN (&2) ELSE (&3)|':u
    + 'If first expression is true return second else third date':t64 
  qbf-x[054] = 'l|l000=n160n161|&1 = &2|':u
             + 'Numbers Equal':t64
  qbf-x[055] = 'l|l000=n160n161|&1 <> &2|':u
             + 'Numbers Not Equal':t64
  qbf-x[056] = 'l|l000=n160n161|&1 < &2|':u
             + 'Numbers Less Than':t64
  qbf-x[057] = 'l|l000=n160n161|&1 <= &2|':u
             + 'Numbers Less or Equal':t64
  qbf-x[058] = 'l|l000=n160n161|&1 > &2|':u
             + 'Numbers Greater Than':t64
  qbf-x[059] = 'l|l000=n160n161|&1 >= &2|':u
             + 'Numbers Greater or Equal':t64
  qbf-x[060] = 'n|n000=l159n159n159|IF &1 THEN (&2) ELSE (&3)|':u
    + 'If first expression is true return second else third number':t64 
  qbf-x[061] = 'l|l000=l153l165|(&1 AND &2)|':u
             + 'Logical AND':t64
  qbf-x[062] = 'l|l000=l154l165|(&1 OR &2)|':u
             + 'Logical OR':t64
  qbf-x[063] = 'l|l000=l155|NOT &1|':u
             + 'Negate logical expression (NOT)':t64
  qbf-x[064] = 'n|n000=n152n151|RANDOM(&1,&2)|':u
             + 'Generate a random number':t64.

ASSIGN
  qbf-x[064] = "". /* terminator */

ASSIGN
  qbf-x[151] = 'Now enter the upper bound for the number.':t160
  qbf-x[152] = 'A random integer will be returned.  Enter the lower bound for the number.':t160
  qbf-x[153] = 'Only if both of the expressions is TRUE will the result be TRUE.':t160
  qbf-x[154] = 'If either of the two expressions is TRUE, then the result is TRUE.':t160
  qbf-x[155] = 'Select the value to negate.':t160
  qbf-x[156] = 'Enter the MATCHES pattern.  Use "." to match one symbol, or "*" to match any number of characters.':t160
  qbf-x[157] = 'Enter the first string.':t160
  qbf-x[158] = 'The first string must start with all the characters of the second string for the expression to be true.':t160
  qbf-x[159] = 'IF the value of the first expression is true, THEN return the value of the second expression, ELSE return the value of the third.':t160
  qbf-x[160] = 'Enter the first value to compare':t160
  qbf-x[161] = 'Enter the second value to compare':t160
  qbf-x[162] = 'Enter the starting character position':t160
  qbf-x[163] = 'Enter the number of characters to extract':t160
  qbf-x[164] = 'Select the first value':t160
  qbf-x[165] = 'Select the next value':t160
  qbf-x[166] = 'Take the logarithm of what number?':t160
  qbf-x[167] = 'Enter the base for the logarithm':t160
  qbf-x[168] = 'The number returned corresponds to the length of the selected string.':t160
  qbf-x[169] = 'Select a field to be displayed as HH:MM:SS':t160
  qbf-x[170] = 'SUBSTRING allows you to extract a portion of a character string for display.  Select a field name.':t160
  qbf-x[171] = 'Select a field to be cube-rooted.':t160
  qbf-x[172] = 'Enter the field name to include as a column in your query, or select <<constant value>> to insert a constant value into the query.':t160
  qbf-x[173] = 'Select a field to be displayed as an absolute (unsigned) value.':t160
  qbf-x[174] = 'Select a field to be rounded to the nearest whole number.':t160
  qbf-x[175] = 'Select a field to be rounded down (fractional part removed).':t160
  qbf-x[176] = 'Select a field to be square-rooted.':t160
  qbf-x[177] = 'After dividing a number by a quotient, this is the remainder.  Of what value do you want the remainer?':t160
  qbf-x[178] = 'Divided by what?':t160
  qbf-x[179] = 'Select the first entry to compare':t160
  qbf-x[180] = 'Select the second entry to compare':t160
  qbf-x[181] = 'Select a date field.':t160
  qbf-x[182] = 'Select a field that contains the number of days to be added to this date.':t160
  qbf-x[183] = 'Select a field that contains the number of days to be subtracted from this date.':t160
  qbf-x[184] = 'Compare two date values and display the difference between the two, in days, as a column.  Choose the first field.':t160
  qbf-x[185] = 'Now choose the second date field.':t160
  qbf-x[186] = 'This returns the day of the month as a number from 1 to 31.':t160
  qbf-x[187] = 'This returns the month of the year as a number from 1 to 12.':t160
  qbf-x[188] = 'This returns the name of the month.':t160
  qbf-x[189] = 'This returns the year portion of the date as an integer.':t160
  qbf-x[190] = 'This returns a number for the weekday, with Sunday being 1.':t160
  qbf-x[191] = 'This returns the name of the day of the week.':t160
  qbf-x[192] = 'Enter first number':t160
  qbf-x[193] = 'Enter next number to add':t160
  qbf-x[194] = 'Enter next number to subtract':t160
  qbf-x[195] = 'Enter first multiplier':t160
  qbf-x[196] = 'Enter next multiplier':t160
  qbf-x[197] = 'Enter quotient':t160
  qbf-x[198] = 'Enter divisor':t160
  qbf-x[199] = 'Enter power':t160.

/* s-exp.i - end of file */

