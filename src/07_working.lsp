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

    (+ (cadr base)
       (- rl *XSEC-GRID-START-RL*))

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
;----------------------------------------------------------
; Draw Working Polyline
;----------------------------------------------------------

(defun XSEC:DrawWorkingPolyline (pts / e)

  (setq e

    (entmakex

      (append

        (list
          '(0 . "LWPOLYLINE")
          '(100 . "AcDbEntity")
          (cons 8 *XSEC-LAYER-WORKING*)
          '(100 . "AcDbPolyline")
          (cons 90 (length pts))
          '(70 . 1)
        )

        (mapcar
          '(lambda (p)

             (cons 10

                   (list

                     (car p)

                     (cadr p)

                   )

             )

           )

          pts

        )

      )

    )

  )

  e

)
;----------------------------------------------------------
; Draw Working Markers
;----------------------------------------------------------

(defun XSEC:DrawWorkingMarkers (pts / p)

  (foreach p pts

    (entmakex
      (list
        '(0 . "CIRCLE")
        (cons 8 *XSEC-LAYER-WORKING*)
        (cons 10 p)
        (cons 40 0.05)
      )
    )

  )

)

;----------------------------------------------------------
; Draw Working Section
;----------------------------------------------------------

(defun XSEC:DrawWorkingSection (base chainage / sec pts)

  (setq sec
        (XSEC:GetWorkingSection
          chainage
          *WorkingCSV*))

  (if sec

    (progn

      (setq pts
            (XSEC:WorkingPoints
              base
              sec))

      (XSEC:DrawWorkingPolyline pts)
      (XSEC:DrawWorkingMarkers pts)

    )

    (prompt
      (strcat
        "\nWorking section not found : "
        (rtos chainage 2 3)))

  )

)

(princ "\n07_WORKING Loaded...")
(princ)