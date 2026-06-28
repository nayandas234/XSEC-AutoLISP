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
(defun XSEC:DrawTestEllipse (base / doc ms cen maj ratio)

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq ms  (vla-get-ModelSpace doc))

  ;; Center of ellipse
  ;; Top of wall = Y + 4
  ;; Crown rise = 1.5
  ;; Ellipse center = Y + 4

  (setq cen (vlax-3d-point
              (list
                (car base)
                (+ (cadr base) 4.0)
                0.0)))

  ;; Major Axis = 2.5
  (setq maj (vlax-3d-point '(2.5 0.0 0.0)))

  ;; Minor / Major = 1.5 / 2.5 = 0.6
  (setq ratio 0.6)

  (vla-AddEllipse
      ms
      cen
      maj
      ratio
  )

)

(defun c:XELLTEST (/ doc ms e cen maj)

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq ms  (vla-get-ModelSpace doc))

  (setq cen (vlax-3d-point '(0.0 4.0 0.0)))
  (setq maj (vlax-3d-point '(2.5 0.0 0.0)))

  (setq e (vla-AddEllipse ms cen maj 0.6))

  ;; Try converting to upper arc
  (vla-put-StartParameter e 0.0)
  (vla-put-EndParameter e pi)

  (princ)
)