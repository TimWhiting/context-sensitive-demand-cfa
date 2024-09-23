#lang racket/base
(require racket/match)

(define ~cite
  (case-lambda
    [(tag) (list "~" "\\cite{" tag "}")]
    [(desc tag) (list "~" "\\cite[" desc "]{" tag "}")]))

(define (citet . tags)
  (match tags
   [(list "horwitz1995demand") (list "Horwitz et al.~\\cite{horwitz1995demand}")]
   [(list "darais2017diss") (list "Darais~\\cite{darais2017diss}")]
   [(list "johnson:earl:dvanhorn:PushdownGarbage") (list "Johnson et al.~\\cite{johnson:earl:dvanhorn:PushdownGarbage}")]
   [(list "schoepe2023lifting") (list "Schoepe et al.~\\cite{schoepe2023lifting}")]
   [(list "midtgaard2008calculational") (list "Midtgaard and Jensen~\\cite{midtgaard2008calculational}")]
   [(list "biswas1997demand") (list "Biswas~\\cite{biswas1997demand}")]
   [(list "nicolay_effect-driven_2019") (list "Nicolay et al.~\\cite{nicolay_effect-driven_2019}")]
   [(list "dvanhorn:heintze-mcallester-pldi97") (list "Heintze and McAllester~\\cite{dvanhorn:heintze-mcallester-pldi97}")]
   [(list "heintze2001demand") (list "Heintze and Tardieu~\\cite{heintze2001demand}")]
   [(list "saha2005incremental") (list "Saha and Ramakrishnan~\\cite{saha2005incremental}")]
   [(list "sui2016supa") (list "Sui and Xue~\\cite{sui2016supa}")]
   [(list "dvanhorn:Might2010Resolving") (list "Might et al.~\\cite{dvanhorn:Might2010Resolving}")]
   [(list "spath2016boomerang") (list "Sp{\\\"{a}}th et al.~\\cite{spath2016boomerang} ")]
   [(list "lu2013incremental") (list "Lu et al.~\\cite{lu2013incremental} ")]
   [(list "su2014parallel") (list "Su et al.~\\cite{su2014parallel} ")]
   [(list "shang2012demand") (list "Shang et al.~\\cite{shang2012demand} ")]
   ['("spath2016boomerang,lu2013incremental,su2014parallel,shang2012demand") 
    (apply append (map citet (list "lu2013incremental" "shang2012demand" "spath2016boomerang" "su2014parallel")))
    ]
  ))

(provide (all-defined-out))