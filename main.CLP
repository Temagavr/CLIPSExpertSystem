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
then yes
else no))

;; Начало ЭС по ИСБ

;; Правило consequences-of-threat-breach-confidentiality
(defrule consequences-of-threat-breach-confidentiality ""
(not (ct-breach-confidentiality ?))
(not (result ?))
=>
(assert (ct-breach-confidentiality (yes-or-no-p "Consequences of the threat - Breach of confidentiality (yes/no)?")))
)

;; Правило source-of-threat-hpei
(defrule source-of-threat-hpei ""
(ct-breach-confidentiality yes)
(not (st-hpei ?))
(not (result ?))
=>
(assert (st-hpei (yes-or-no-p "Source of threat - High potential external intruder (yes/no)?")))
)

;; Правило source-of-threat-api
(defrule source-of-threat-api ""
(ct-breach-confidentiality yes)
(not (st-api ?))
(not (result ?))
=>
(assert (st-api (yes-or-no-p "Source of threat - Average potential insider (yes/no)?")))
)

;; Правило object-of-influence-software-with-ml
(defrule object-of-influence-software-with-ml ""
(ct-breach-confidentiality yes)
(or (st-api yes) (st-hpei yes))
(not (oi-software-with-ml ?))
(not (result ?))
=>
(assert (oi-software-with-ml (yes-or-no-p "Object of influence - Software that use machine learning (yes/no)?")))
)

;; Правило object-of-influence-ml-model
(defrule object-of-influence-ml-model ""
(ct-breach-confidentiality yes)
(or (st-api yes) (st-hpei yes))
(not (oi-ml-model ?))
(not (result ?))
=>
(assert (oi-ml-model (yes-or-no-p "Object of influence - Machine learning model (yes/no)?")))
)

;; Нашли угрозу
(defrule ubi-found ""
(ct-breach-confidentiality yes)
(or (st-api yes) (st-hpei yes))
(not (result ?))
=>
(assert (result "This is UBI.218 Threat"))
(printout t "This is UBI.218 Threat")
)
