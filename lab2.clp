
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-has-codes ""
   (not (has-codes ?))
   (not (threat ?))
   =>
   (assert (has-codes (yes-or-no-p "Does your system contain access codes (yes/no)? "))))
   
(defrule determine-hard-wired ""
   (has-codes yes)
   (not (hard-wired ?))
   (not (threat ?))
   =>
   (assert (hard-wired (yes-or-no-p "Are these codes 'hard-wired' (yes/no)? "))))

(defrule determine-malfunction ""
   (and (has-codes yes)
        (hard-wired yes)
        (not (threat ?))   
   )
   =>
   (assert (malfunction (yes-or-no-p "Has there been a malfunction in the system\device (yes/no)? "))))
   
(defrule determine-repair ""
   (and (has-codes yes)
        (hard-wired yes)
        (malfunction yes)
   )
   (not (threat ?))
   =>
   (assert (repair (yes-or-no-p "Was system/device repaired (yes/no)? "))))
   
(defrule determine-leak ""
   (and (has-codes yes)
        (hard-wired yes)
   )
   (not (threat ?))
   =>
   (assert (leak (yes-or-no-p "Has there been a leak containing your 'master codes' (yes/no)? "))))

;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule has-threat ""
   (has-codes yes)
   (hard-wired yes)
   (or
       (leak yes)
       (and (malfunction yes)
            (repair yes)
       )
   )
   (not (threat ?))
   =>
   (assert (threat "UBI.207: Threat of unauthorized access to equipment configuration parameters through the use of “master codes” (engineering passwords)")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "The UBI.207 Expert System")
  (printout t crlf crlf))

(defrule startup ""
  (declare (salience 5)) 
  =>
  (assert (has-codes yes))
  (assert (hard-wired yes))
  (assert (leak no))
  (assert (malfunction yes))
  (assert (repair yes)))