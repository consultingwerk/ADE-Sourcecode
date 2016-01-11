/* fix020004toolbars.p
   toolbar data issues fix -
   noddy to be run with delta icfdb020004delta.df (after applying delta)
*/

SESSION:SET-WAIT-STATE("general").
RUN db/icf/dfd/fix020004toolbar01.p.
RUN db/icf/dfd/fix020004toolbar02.p.
RUN db/icf/dfd/fix020004toolbar03.p.
RUN db/icf/dfd/fix020004toolbar04.p.
SESSION:SET-WAIT-STATE("").
