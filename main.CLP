(deffunction ask-question (?question $?allowed-values)
(printout t ?question)
(bind ?answer (read))
(if (lexemep ?answer)
then (bind ?answer (lowcase ?answer)))
(while (not (member ?answer ?allowed-values)) do
(printout t ?question)
(bind ?answer (read))
(if (lexemep ?answer)
then (bind ?answer (lowcase ?answer))))
?answer)

(deffunction yes-or-no-p (?question)
(bind ?response (ask-question ?question yes no y n))
(if (or (eq ?response yes) (eq ?response y))
then TRUE
else FALSE))


;; Начало ЭС по ИСБ
;; Правило source-of-threat-hpei
(defrule source-of-threat-hpei ""
(not (st-hpei ?))
(not (result ?))
=>
(if (yes-or-no-p "Source of threat - High potential external intruder (yes/no)?")
then
(assert (st-hpei yes))
else
(assert (st-hpei no))
)
)

;; Правило source-of-threat-api
(defrule source-of-threat-api ""
(not (st-api ?))
(not (result ?))
=>
(if (yes-or-no-p "Source of threat - Average potential insider (yes/no)?")
then
(assert (st-api yes))
else
(assert (st-api no))
)
)

;; Правило object-of-influence-software-with-ml
(defrule object-of-influence-software-with-ml ""
(not (oi-software-with-ml ?))
(not (result ?))
=>
(if (yes-or-no-p "Object of influence - Software that use machine learning (yes/no)?")
then
(assert (oi-software-with-ml yes))
else
(assert (oi-software-with-ml no))
)
)

;; Правило object-of-influence-ml-model
(defrule object-of-influence-ml-model ""
(not (oi-ml-model ?))
(not (result ?))
=>
(if (yes-or-no-p "Object of influence - Machine learning model (yes/no)?")
then
(assert (oi-ml-model yes))
else
(assert (oi-ml-model no))
)
)

;; Правило consequences-of-threat-breach-confidentiality
(defrule consequences-of-threat-breach-confidentiality ""
(not (ct-breach-confidentiality ?))
(not (result ?))
=>
(if (yes-or-no-p "Consequences of the threat - Breach of confidentiality (yes/no)?")
then
(assert (ct-breach-confidentiality yes))
else
(assert (ct-breach-confidentiality no))
)
)

;; Нашли угрозу
(defrule ubi-found ""
(st-hpei yes)
(st-api yes)
(oi-software-with-ml yes)
(oi-ml-model yes)
(ct-breach-confidentiality yes)
(not (result ?))
=>
(assert (result "This is UBI.218 Threat"))
(printout t "This is UBI.218 Threat")
)

;; Не нашли угрозу
(defrule ubi-not-found ""
(not (result ?))
=>
(assert (result "Undefinded Threat"))
(printout t "Undefinded Threat")
)