/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-b-eng.p - English language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Πρόγραμμα,"Database" και Αρχείο,Χρόνος'
    qbf-lang[ 2] = 'Το αρχείο Ελέγχου (Checkpoint) καταστράφηκε. Διαγράψτε το αρχείο .qc '
                 + 'και κάντε την εγκατάσταση από την αρχή.'
    qbf-lang[ 3] = 'Επεξεργασία του'     /*format x(15)*/
    qbf-lang[ 4] = 'Compile'      /*format x(15)*/
    qbf-lang[ 5] = 'Re-Compiling'   /*format x(15)*/
    qbf-lang[ 6] = 'Επεξεργασία του αρχείου,Επεξεργασία της φόρμας,Επεξεργασία προγράμματος'
    qbf-lang[ 7] = 'Ολα τα επιλεγμένα αρχεία θα εγκατασταθούν. ['
                 + KBLABEL("RETURN") + '] για επιλογή/ακύρωση επιλογής.'
    qbf-lang[ 8] = 'Πατήστε [' + KBLABEL("GO") + '] αφού επιλέξετε ή ['
                 + KBLABEL("END-ERROR") + '] για τέλος.'
    qbf-lang[ 9] = 'Ανεύρεση αρχείων για δημιουργία αρχική λίστα Φορμών Προβολής...'
    qbf-lang[10] = 'Εχετε ορίσει όλες τις Φορμες Προβολής; '
    qbf-lang[11] = 'Ανεύρεση έμμεσων ενωτικών σχέσεων -OF.'
    qbf-lang[12] = 'Επεξεργασία της λίστας Ενωτικών Σχέσεων.'
    qbf-lang[13] = 'Δεν εντοπίστηκαν όλες οι Ενώσεις.'
    qbf-lang[14] = 'Διαγραφή των επιπλέον στοιχείων των Ενωτικών Σχέσεων.'
    qbf-lang[15] = 'Επιβεβαίωση εξόδου'
    qbf-lang[16] = 'Συνολικός χρονος,Μέσος χρόνος'
    qbf-lang[17] = 'Ανάγνωση του αρχείου Ελέγχου (checkpoint)...'
    qbf-lang[18] = 'Δημιουργία του αρχείου Ελέγχου (checkpoint)...'
    qbf-lang[19] = 'ήδη υπάρχει. Αντικατάσταση με το'
    qbf-lang[20] = 'Επανεγκατάσταση του αρχείου'
    qbf-lang[21] = 'Ανεύρεση της Φορμας "~{1~}" για μεταβολές.'
    qbf-lang[22] = 'Αδύνατη η εγκατάσταση της Φορμας χώρις RECID ή UNIQUE INDEX '
    qbf-lang[23] = 'Η Φόρμα δεν άλλαξε.'
    qbf-lang[24] = 'δεν χρειάζεται "recompiling".'
    qbf-lang[25] = 'Δεν υπάρχουν άλλα πεδία στη Φόρμα. Δεν δημιουργήθηκε Η Φόρμα.'
    qbf-lang[26] = 'Δεν υπάρχουν άλλα πεδία στη Φόρμα. Η υπάρχουσα Φόρμα διαγράφηκε.'
    qbf-lang[27] = 'Συμπίεση της λίστας αρχείων προβολής.'
    qbf-lang[28] = 'Συνολικός χρόνος'
    qbf-lang[29] = 'Τέλος!'
    qbf-lang[30] = 'Αποτυχία "Compile" του "~{1~}".'
    qbf-lang[31] = 'Δημιουργία του αρχείου Παραμέτρων (config)'
    qbf-lang[32] = 'Εντοπίστηκαν Λάθη κατά την φάση "εγκατάσταση" και/ή "compile".'
                 + '^^Πατήστε κάποιο πλήκτρο για να δείτε το ιστορικό αρχείο (query log file).'
                 + 'Η γραμμές που περιέχουν τα λάθη τονίζονται.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'onoma,*onoma*,eponymia,*eponymia*,Name'
    qbf-lang[ 2] = 'contact,*contact*,ypeythinos,yp*opsin,Address'
    qbf-lang[ 3] = '*odos,dieyth*,*dieythinsh,*dieythinsh*1,Address2'
    qbf-lang[ 4] = '*tax*thyrida*,*dieythinsh*2'
    qbf-lang[ 5] = '*dieythinsh*3,City'
    qbf-lang[ 6] = 'tax*kod*,*tax*kvd*,t*k*,St'
    qbf-lang[ 7] = 'polh,*polh*,Zip'
    qbf-lang[ 8] = 't*p,*tax*polh*,tk*polh,t*k*polh'
    qbf-lang[ 9] = 'nomos,*nomos*'
    qbf-lang[10] = '*xvra*,*xora*'

    qbf-lang[15] = 'Δείγμα Μορφής Εξαγωγής'.

/*--------------------------------------------------------------------------*/

RETURN.
