(vl-load-com)

(defun XSEC:DrawBottom (base / p1 p2 lw rw)

  ;; Bottom
  (setq p1 (list (- (car base) 2.5) (cadr base) 0.0))
  (setq p2 (list (+ (car base) 2.5) (cadr base) 0.0))

  ;; Wall Tops
  (setq lw (list (- (car base) 2.5) (+ (cadr base) 4.0) 0.0))
  (setq rw (list (+ (car base) 2.5) (+ (cadr base) 4.0) 0.0))

  ;; Bottom Line
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-PROPOSED*)
      (cons 10 p1)
      (cons 11 p2)
    )
  )

  ;; Left Wall
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-PROPOSED*)
      (cons 10 p1)
      (cons 11 lw)
    )
  )

  ;; Right Wall
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-PROPOSED*)
      (cons 10 p2)
      (cons 11 rw)
    )
  )

)

(defun c:XTEST ()

  (XSEC:DrawBottom '(0.0 0.0 0.0))

  (princ)

)