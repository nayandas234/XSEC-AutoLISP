(vl-load-com)

(defun XSEC:DrawBottom (base / p1 p2)

  (setq p1
    (list
      (- (car base) 2.5)
      (cadr base)
      0.0
    )
  )

  (setq p2
    (list
      (+ (car base) 2.5)
      (cadr base)
      0.0
    )
  )

  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-PROPOSED*)
      (cons 10 p1)
      (cons 11 p2)
    )
  )

)

(defun c:XTEST ()

  (XSEC:DrawBottom '(0.0 0.0 0.0))

  (princ)

)