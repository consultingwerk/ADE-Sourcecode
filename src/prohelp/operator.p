/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
form
  " +    Unary Positive     Preserves the sign of a numeric expression."
  "                         Usage:  + expression"
  "                                                                         "
  " +    Addition           Adds two numeric expressions."
  "                         Usage:  expression1 + expression2"
  "                                                                         "
  " +    Concatenation      Produces a character value by concatenating two"
  "                         character strings or expressions."
  "                         Usage:  expression1 + expression2"
  "                                                                         "
  " +    Date Addition      Adds a number of days to a date, producing a "
  "                         date result."
  "                         Usage:  date + days"
  "                                                                         "
  " -    Unary Negative     Reverses the sign of a numeric expression."
  "                         Usage:  - expression"
  "                                                                         "
  " -    Subtraction        Subtracts one numeric expression from another."
  "                         Usage:  expression1 - expression2"
  with column 3 frame window1 title " P R O G R E S S   O P E R A T O R S "
       no-attr-space.

  view frame window1.


  form
  " -    Date Subtraction   Subtracts a number of days from a date,"
  "                         producing a date result;; or subtracts one date"
  "                         from another,  producing an integer result"
  "                         representing the number of days between two dates."
  "                         Usage:  date - days   or   date - date"
  "                                                                         "
  " *    Multiplication     Multiplies two numeric expressions."
  "                         Usage:  expression1 * expression2"
  "                                                                         "
  " /    Division           Divides one numeric expression by another,"
  "                         producing a decimal result."
  "                         Usage:  expression1 / expression2"
  "                                                                         "
  " =    Comparison         Compares two expressions and returns a TRUE"
  "                         value if they are equal."
  "                         Usage:  expression1 = expression2"
  "                                                                         "
  " EQ   Comparison         Same as ""=""."
  "                         Usage:  expression1 EQ expression2"
  with column 3 frame window2 title " P R O G R E S S   O P E R A T O R S "
       no-attr-space.

  view frame window2.


  form
  " <    Comparison         Returns a TRUE value if the first of two"
  "                         expressions is less than the second expression."
  "                         Usage:  expression1 < expression2"
  "                                                                         "
  " LT   Comparison         Same as ""<""."
  "                         Usage:  expression1 LT expression2"
  "                                                                         "
  " <=   Comparison         Returns a TRUE value if the first of two"
  "                         expressions is less than or equal to the second"
  "                         expression.                                     "
  "                         Usage:  expression1 <= expression2"
  "                                                                         "
  " LE   Comparison         Same as ""<=""."
  "                         Usage:  expression1 LE expression2"
  "                                                                         "
  " >    Comparison         Returns a TRUE value if the first of two"
  "                         expressions is greater than the second expression."
  "                         Usage:  expression1 > expression2"
  "                                                                         "
  with column 3 frame window3 title " P R O G R E S S   O P E R A T O R S "
     no-attr-space.

  view frame window3.


  form
  " GT   Comparison         Same as "">""."
  "                         Usage:  expression1 GT expression2"
  "                                                                         "
  " >=   Comparison         Returns a TRUE value if the first of two"
  "                         expressions is greater than or equal to the second"
  "                         expression.                                     "
  "                         Usage:  expression1 >= expression2"
  "                                                                         "
  " GE   Comparison         Same as "">=""."
  "                         Usage:  expression1 GE expression2"
  "                                                                         "
  " <>   Comparison         Compares two expressions and returns a TRUE value"
  "                         if they are not equal."
  "                         Usage:  expression1 <> expression2"
  "                                                                         "
  " NE   Comparison         Same as ""<>""."
  "                         Usage:  expression1 NE expression2"
  "                                                                         "
  with column 3 frame window4 title " P R O G R E S S   O P E R A T O R S "
     no-attr-space.

  view frame window4.


  form
  " AND  Boolean            Produces a TRUE value if each of two logical"
  "                         expressions is true."
  "                         Usage:  expression1 AND expression2"
  "                                                                         "
  " NOT  Boolean            Reverses the TRUE or FALSE value of an expression."
  "                         Usage:  NOT expression"
  "                                                                         "
  " OR   Boolean            Produces a TRUE value if either of two logical"
  "                         expressions is true."
  "                         Usage:  expression1 OR expression2"
  "                                                                         "
  "                                                                         "
  "                                                                         "
  "                                                                         "
  "                                                                         "
  "                                                                         "
  "                                                                         "
  "                                                                         "
  "                                                                         "
  with column 3 frame window5 title " P R O G R E S S   O P E R A T O R S "
     no-attr-space.

  view frame window5.
