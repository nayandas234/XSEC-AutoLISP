;=========================================================
; XSEC PROJECT
; FILE : 07_WORKING.LSP
;=========================================================

(vl-load-com)

;----------------------------------------------------------
; Offset + RL -> Drawing Point
;----------------------------------------------------------

(defun XSEC:OffsetRLToPoint
(
base
offset
rl
)

  (list

    (+ (car base) offset)

    rl

    0.0

  )

)
;----------------------------------------------------------
; Working Points
;----------------------------------------------------------

(defun XSEC:WorkingPoints
(
base
section
/
pts
)

  (setq pts '())

  (foreach p section

    (setq pts

      (append

        pts

        (list

          (XSEC:OffsetRLToPoint

            base

            (car p)

            (cadr p)

          )

        )

      )

    )

  )

  pts

)
(defun c:WPTEST (/ sec base pts)

  (setq base '(0.0 0.0 0.0))

  (setq sec

    '(
      (-3.0 0.8)
      (-2.0 1.1)
      (-1.0 1.6)
      (0.0 1.9)
      (1.0 1.5)
      (2.0 1.1)
      (3.0 0.8)
    )

  )
  ;----------------------------------------------------------
; Draw Working Polyline
;----------------------------------------------------------

(defun XSEC:DrawWorkingPolyline (pts / e)

  (setq e
    (entmakex
      (append
        (list
          '(0 . "LWPOLYLINE")
          (cons 8 *XSEC-LAYER-WORKING*)
          (cons 90 (length pts))
          '(70 . 0)
        )

        (apply
          'append
          (mapcar
            '(lambda (p)
               (list
                 (cons 10 (list (car p) (cadr p)))
               )
             )
            pts
          )
        )
      )
    )
  )

  e

)

  (setq pts
      (XSEC:WorkingPoints base sec))

(XSEC:DrawWorkingPolyline pts)
  (princ)

)

(princ "\n07_WORKING Loaded...")
(princ)