/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-c-eng.p - English language definitions for Scrolling Lists */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*
As of [Thu Apr 25 15:13:33 EDT 1991], this
is a list of the scrolling list programs:
  u-browse.i     c-print.p
  b-pick.p       i-pick.p
  c-entry.p      i-zap.p
  c-field.p      s-field.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-field.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-field.p */
ASSIGN
  qbf-lang[ 1] = 'Επιλέξτε το αρχείο για ένωση ή πατήστε ['
               + KBLABEL("END-ERROR") + '] για τέλος.'
  qbf-lang[ 2] = 'Πατήστε [' + KBLABEL("GO") + '] αφού επιλέξετε,['
               + KBLABEL("INSERT-MODE") + '] για εναλλαγή,['
               + KBLABEL("END-ERROR") + '] για τέλος.'
  qbf-lang[ 3] = 'Πατήστε [' + KBLABEL("END-ERROR")
               + '] αφού επιλέξετε τα αρχεία.'
  qbf-lang[ 4] = 'Πατήστε [' + KBLABEL("GO") + '] αφού επιλέξετε, ['
               + KBLABEL("INSERT-MODE")
               + '] εναλλαγή περιγρ./αρχ./πρόγρ.'
  qbf-lang[ 5] = 'Ετικέττα/Ονομασία'
  qbf-lang[ 6] = 'Περιγραφή/Ονομασία-'
  qbf-lang[ 7] = 'Αρχείο---,Πρόγραμμα,Περιγραφή'
  qbf-lang[ 8] = 'Ανεύρεση των πεδίων...'
  qbf-lang[ 9] = 'Επιλογή Πεδίων'
  qbf-lang[10] = 'Επιλογή Αρχείου'
  qbf-lang[11] = 'Επιλογή Αρχείου με σχέση'
  qbf-lang[12] = 'Επιλογή Φόρμας Προβολής'
  qbf-lang[13] = 'Επιλογή Μονάδας Εξόδου'
  qbf-lang[14] = 'Ενωση' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '          Αρχείο' /* max length 16 */
  qbf-lang[18] = '           Πεδίο' /* max length 16 */
  qbf-lang[19] = '  Μέγιστο πλήθος' /* max length 16 */
  qbf-lang[20] = 'Η τιμή'
  qbf-lang[21] = 'υπερβαίνει το πλήθος στοιχείων του πίνακα - 1 εως'
  qbf-lang[22] = 'Να προστεθεί στο τέλος του υπάρχοντα αρχείου; '
  qbf-lang[23] = 'Αδύνατη η επιλογή με το συγκεκριμένο προορισμό εξόδου'
  qbf-lang[24] = 'Δώστε την ονομασία του αρχείου εξόδου'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'Αφήστέ το κενό για κατακόρυφο πίνακα, ή δώστε μία'
  qbf-lang[28] = 'λίστα συγκεκριμένων στοιχείων του πίνακα (μεταξύ'
  qbf-lang[29] = 'κομμάτων) για ξεχωριστές στήλες στην εκτύπωση.'
  qbf-lang[30] = 'Δώστε μία λίστα συγκεκριμένων στοιχείων του πίνακα' 
  qbf-lang[31] = '(μεταξύ κομμάτων) για πεδία σε ξεχωριστές στήλες.'
  qbf-lang[32] = 'Δώστε τον δείκτη του στοιχείου του πίνακα.'.

RETURN.
