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
/* t-d-eng.p - English language definitions for Data Export module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* d-edit.p,a-edit.p */
IF qbf-s = 1 THEN
/*
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
*/
  ASSIGN
    qbf-lang[ 1] = 'ένα σύμβολο όπως'
    qbf-lang[ 2] = 'από τον παρακάτω πίνακα.'
    qbf-lang[ 3] = 'Πατήστε [' + KBLABEL("GET")
                 + '] για επιλογή/ακύρωση επιλογής του Αμεσου Ορισμού.'
    /* format x(70): */
    qbf-lang[ 4] = 'Κατά την εισαγωγή κωδικών, τα παρακάτω συνδιάζονται '
                 + 'ελεύθερα :'
    /* format x(60): */
    qbf-lang[ 5] = 'απλός χαρακτήρας μέσα σε μονά εισαγωγικά.'
    qbf-lang[ 6] = 'ερμηνεύεται ώς χαρακτήρας ελέγχου.'
    qbf-lang[ 7] = 'ένα ή παραπάνω δεκεξαδικά ψηφία συν το γράμμα "h".'
    qbf-lang[ 8] = 'ένα, δύο ή τρία ψηφία, ένας δεκαδικός αριθμός.'
    qbf-lang[ 9] = 'είναι άγνωστος κωδικός. Παρακαλώ διορθώστέ το.'
    qbf-lang[10] = 'Επεξεργασία των χαρακτήρων ελέγχου του εκτυπωτή...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Αρχ. :,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Ταξιν:'
    qbf-lang[ 3] = 'Στοιχεία Εξαγωγής'
    qbf-lang[ 4] = 'Σχεδίαση Εξαγωγής'
    qbf-lang[ 5] = 'Πεδία:,      :,      :,      :,      :'
    qbf-lang[ 7] = ' Τύπος Εξαγωγής:'
    qbf-lang[ 8] = 'Επικεφαλίδα:'
    qbf-lang[ 9] = '(πρώτη εγγραφή= ονομασίες πεδίων)'
    qbf-lang[10] = '  Αρχή εγγραφής:'
    qbf-lang[11] = ' Τέλος εγγραφής:'
    qbf-lang[12] = ' Οριοθέτης Πεδ.:'
    qbf-lang[13] = 'Διαχωριστής Πεδ:'
    qbf-lang[14] = 'Η Εξαγωγή Στοιχείων δεν υποστηρίζει τους κατακόρυφους '
                 + 'πίνακες. Στη συνέχεια, θα αφαιρεθούν από την εξαγωγή.'
                 + '^Θέλετε να συνεχίσετε; '
    qbf-lang[15] = 'Αδύνατη η εξαγωγή στοιχείων χωρίς τον ορισμό πεδίων.'
    qbf-lang[21] = 'Δεν έχετε ακυρώσει την τρέχουσα μορφή Εξαγωγής. '
                 + 'Θέλετε να συνεχίσετε; '
    qbf-lang[22] = 'Δημιουργία του προγράμματος Εξαγωγής...'
    qbf-lang[23] = '"Compile" του προγράμματος Εξαγωγής...'
    qbf-lang[24] = 'Εκτέλεση του προγράμματος που δημιουργήθηκε...'
    qbf-lang[25] = 'Αδύνατη η επικοινωνία με το αρχείο/μονάδα'
    qbf-lang[26] = 'Αριθμός Εξαγωμένων Εγγραφών - ~{1~} .'
    qbf-lang[31] = 'Επιβεβαίωση επαναθέτησης των ρυθμίσεων εξαγωγής'
    qbf-lang[32] = 'Επιβεβαίωση εξόδου από αυτή την εργασία'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,Εξαγωγή PROGRESS'
    qbf-lang[ 2] = 'ASCII   ,Γενική ASCII (Generic)'
    qbf-lang[ 3] = 'ASCII-H ,ASCII με επικεφ.ονομασίας πεδίου'
    qbf-lang[ 4] = 'FIXED   ,ASCII σταθερού μήκους (SDF)'
    qbf-lang[ 5] = 'CSV     ,Διαχωρισμένα με κόμματα (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word για Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Καθορισμένη από τον Χρήστη'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
