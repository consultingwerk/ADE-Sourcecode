/* include - lval.i, returns the value of an attribute by name (Blank if not found) */
ENTRY(LOOKUP("{1}",{&lval_names}) + 1,"{2}" + CHR(1) + {&lval_values},CHR(1))
