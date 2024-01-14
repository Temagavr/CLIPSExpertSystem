
;; Правило determine-working-state
(defrule determine-working-state ""
(not (working-state ?))
(not (repair ?))
=>
(if (yes-or-no-p "Zagrujaetsa OS? (yes/no)?")
then
(if (yes-or-no-p "OS rabotaet correctno? (yes/no)?")
then
(assert (repair "Remont ne trebuetsa"))
(assert (working-state stable))
else
(assert (working-state not-stable))
)
else
(assert (working-state disenabled))
)
)

;;правило определяющее включен ли компьютер
(defrule determine-power-state ""
(working-state disenabled)
(not (power-state ?))
(not (repair ?))
=>
(if (yes-or-no-p "Podaetsa pitanie? (yes/no)?")
then
(assert (repair "Sleduet pereustanovit OS"))
(assert (power-state be))
else
(assert (repair "Podaite pitanie"))
(assert (power-state not))
)
)
