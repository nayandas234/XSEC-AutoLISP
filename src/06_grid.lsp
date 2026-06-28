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
(defun c:GLIMIT (/ p)

  (setq p (getpoint "\nPick Base : "))

  (print

    (XSEC:GetGridLimits p)

  )

  (princ)

)