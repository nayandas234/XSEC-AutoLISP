;=========================================================
; XSEC PROJECT
; FILE : 06_GRID.LSP
;=========================================================

(vl-load-com)

;----------------------------------------------------------
; Grid Defaults
;----------------------------------------------------------

(setq *XSEC-GRID-OFFSET* 1.0)      ; Vertical grid spacing (Offset)
(setq *XSEC-GRID-RL*     1.0)      ; Horizontal grid spacing (RL)

(setq *XSEC-GRID-TEXT*   0.20)

(setq *XSEC-GRID-MARGIN* 1.00)
(defun XSEC:GetGridLimits (base / xmin xmax ymin ymax)

  (setq xmin
        (- (car base)
           (/ *XSEC-PROP-WIDTH* 2.0)
           *XSEC-GRID-MARGIN*))

  (setq xmax
        (+ (car base)
           (/ *XSEC-PROP-WIDTH* 2.0)
           *XSEC-GRID-MARGIN*))

  (setq ymin
        (- (cadr base)
           *XSEC-GRID-MARGIN*))

  (setq ymax
        (+ (cadr base)
           *XSEC-PROP-TOTAL-HEIGHT*
           *XSEC-GRID-MARGIN*))

  (list xmin ymin xmax ymax)

)
;----------------------------------------------------------
; Vertical Grid
;----------------------------------------------------------

(defun XSEC:DrawVerticalGrid (base / lim xmin ymin xmax ymax x e lst)

  (setq lim (XSEC:GetGridLimits base))

  (setq xmin (nth 0 lim))
  (setq ymin (nth 1 lim))
  (setq xmax (nth 2 lim))
  (setq ymax (nth 3 lim))

  (setq x xmin)
  (setq lst '())

  (while (<= x xmax)

    (setq e
      (entmakex
        (list
          '(0 . "LINE")
          (cons 8 *XSEC-LAYER-GRID*)
          (cons 10 (list x ymin 0.0))
          (cons 11 (list x ymax 0.0))
        )
      )
    )

    (setq lst (cons e lst))

    (setq x (+ x *XSEC-GRID-OFFSET*))

  )

  (reverse lst)

)
;----------------------------------------------------------
; Horizontal Grid
;----------------------------------------------------------

(defun XSEC:DrawHorizontalGrid (base / lim xmin ymin xmax ymax y e lst)

  (setq lim (XSEC:GetGridLimits base))

  (setq xmin (nth 0 lim))
  (setq ymin (nth 1 lim))
  (setq xmax (nth 2 lim))
  (setq ymax (nth 3 lim))

  (setq y ymin)
  (setq lst '())

  (while (<= y ymax)

    (setq e
      (entmakex
        (list
          '(0 . "LINE")
          (cons 8 *XSEC-LAYER-GRID*)
          (cons 10 (list xmin y 0.0))
          (cons 11 (list xmax y 0.0))
        )
      )
    )

    (setq lst (cons e lst))

    (setq y (+ y *XSEC-GRID-RL*))

  )

  (reverse lst)

)
;----------------------------------------------------------
; Vertical Grid Labels (Offset)
;----------------------------------------------------------

(defun XSEC:DrawOffsetLabels (base / lim xmin ymin ymax x txt h)

  (setq lim (XSEC:GetGridLimits base))

  (setq xmin (nth 0 lim))
  (setq ymin (nth 1 lim))
  (setq ymax (nth 3 lim))

  (setq h *XSEC-GRID-TEXT*)

  (setq x xmin)

  (while (<= x (nth 2 lim))

    (setq txt
      (rtos
        (- x (car base))
        2
        1
      )
    )

    (entmakex
      (list
        '(0 . "TEXT")
        (cons 8 *XSEC-LAYER-TEXT*)
        (cons 10 (list x (- ymin 0.30) 0.0))
        (cons 40 h)
        (cons 1 txt)
        (cons 7 "Standard")
        (cons 72 1)
        (cons 73 2)
        (cons 11 (list x (- ymin 0.30) 0.0))
      )
    )

    (setq x (+ x *XSEC-GRID-OFFSET*))

  )

)
(defun c:GTEST (/ p)

  (setq p (getpoint "\nPick Base : "))

  (XSEC:DrawVerticalGrid p)
  (XSEC:DrawHorizontalGrid p)
  (XSEC:DrawOffsetLabels p)

  (princ)

)