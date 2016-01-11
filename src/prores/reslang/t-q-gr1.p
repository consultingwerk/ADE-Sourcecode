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
/* t-q-eng.p - English language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Δεν βρέθηκε εγγραφή μ''αυτά τα κριτήρια αναζήτησης.'
    qbf-lang[ 2] = 'Σύνολο Εγγραφών,Ενωση,Υποσύνολο Εγγραφών'
    qbf-lang[ 3] = 'Εμφανίζονται όλα,Στην αρχή,Στο τέλος'
    qbf-lang[ 4] = 'Δεν έχετε ορίσει κλειδί γι''αυτό το αρχείο.'
    qbf-lang[ 5] = 'Επιβεβαίωση διαγραφής της εγγραφής'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Διακοπή μέτρησης.'
    qbf-lang[ 8] = 'Ο αριθμός διαθέσιμων έγγραφών είναι '
    qbf-lang[ 9] = 'Μέτρηση εγγραφών...   Πατήστε [' + KBLABEL("END-ERROR")
                 + '] για διακοπή.'
    qbf-lang[10] = 'Ισούται με,είναι Μικρότερο από,είναι Μικρότερο από ή ίσο με,'
                 + 'είναι Μεγαλύτερο από,είναι Μεγαλύτερο από ή ίσο με,'
                 + 'δεν Ισούται με,Αντιστοιχεί με,Αρχίζει από'
    qbf-lang[11] = 'Δεν υπάρχουν διαθέσιμες εγγραφές.'
    qbf-lang[13] = 'Εχετε φτάσει ήδη στην πρώτη εγγραφή του αρχείου.'
    qbf-lang[14] = 'Εχετε φτάσει ήδη στην τελευταία εγγραφή του αρχείου.'
    qbf-lang[15] = 'Δεν έχετε ορίσει Φόρμα Προβολής.'
    qbf-lang[16] = 'Προβολές'
    qbf-lang[17] = 'Επιλέξτε την ονομασία της Φόρμας Προβολής.'
    qbf-lang[18] = 'Πατήστε [' + KBLABEL("GO")
                 + '] ή [' + KBLABEL("RETURN")
                 + '] για επιλογή φόρμας, ή [' + KBLABEL("END-ERROR")
                 + '] για τέλος.'
    qbf-lang[19] = 'Φόρτωση της Φόρμας Προβολής...'
    qbf-lang[20] = 'Η Φόρμα Προβολής (μορφή "compiled") λείπει γι''αυτό το πρόγραμμα. '
                 + 'Μπορεί να οφείλεται στα εξής :^1) λάθος PROPATH,^2) λείπει '
                 + 'το αρχείο Προβολής .r , ή^3) το αρχείο  είναι "uncompiled" δηλαδή .p.^(Δείτε το '
                 + 'αρχείο <dbname>.ql για μηνύματα λάθους του "compiler").^^Μπορείτε '
                 + 'να συνεχίσετε, αλλά μπορεί να προκαλέσει μήνυμα λάθους σαν συνέπεια. '
                 + 'Θέλετε να συνεχίσετε; '
    qbf-lang[21] = 'Υπάρχει ένα φίλτρο "WHERE" στην τρέχουσα Φόρμα Προβολής '
                 + 'που ζητά τιμές στην ώρα εκτέλεσης (RUN-TIME). Κατά την '
                 + 'συγκεκριμένη εργασία όμως, δεν υποστηρίζεται. Θέλετε να '
                 + 'συνεχίσετε αγνοώντας το φίλτρο WHERE; '
    qbf-lang[22] = 'Πατήστε [' + KBLABEL("GET")
                 + '] για να ορίσετε διαφορετικά πεδία ανεύρεσης.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Επόμ.,Εμφανίζει την επόμενη εγγραφή.'
    qbf-lang[ 2] = 'Προηγ.,Εμφανίζει την προηγούμενη εγγραφή.'
    qbf-lang[ 3] = 'Πρώτη,Εμφανίζει την Πρώτη εγγραφή.'
    qbf-lang[ 4] = 'Τελευτ.,Εμφανίζει την τελευταία εγγραφή.'
    qbf-lang[ 5] = 'Νέα,Προσθήκη νέας εγγραφής.'
    qbf-lang[ 6] = 'Μεταβ.,Μεταβολή της τρέχουσας εγγραφής.'
    qbf-lang[ 7] = 'Αντιγρ.,Αντιγραφή της τρέχουσας εγγραφής σε νέα εγγραφή.'
    qbf-lang[ 8] = 'Διαγραφή,Διαγραφή της τρέχουσας εγγραφής.'
    qbf-lang[ 9] = 'Επιλογή,Επιλογή άλλης Φόρμας Προβολής.'
    qbf-lang[10] = 'Ανεύρ.,Εικόνα των εγγραφών με τα κριτήρια που ορίσετε'
    qbf-lang[11] = 'Ενωση,Ενώση με εγγραφές από άλλο αρχείο που έχουν σχέση.'
    qbf-lang[12] = 'Αναζήτ.,Αναζήτηση με κριτήρια επιλογής.'
    qbf-lang[13] = 'Οπου,Επιλογή εγγραφών και ορισμός συνθηκών με το φίλτρο WHERE.'
    qbf-lang[14] = 'Μέτρηση,Αριθμός εγγραφών στο τρέχον σύνολο ή υποσύνολο.'
    qbf-lang[15] = 'Ταξινόμ.,Επίλογη διαφορετικού κλειδιού.'
    qbf-lang[16] = 'Εργασ.,Επιλογή άλλης εργασίας.'
    qbf-lang[17] = 'Πληροφ.,Πληροφορίες για τα τρέχοντα κριτήρια επιλογής.'
    qbf-lang[18] = 'Χρήστ.,Κλήση προγράμματος του χρήστη.'
    qbf-lang[19] = 'Τέλος,Τέλος.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
