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
; Draw All Working Sections
;----------------------------------------------------------

(defun XSEC:DrawAllSections
(
/
chs
ch
base
rl
spacing
)

  (setq spacing 12.0)

  (setq chs
        (XSEC:GetChainages *WorkingCSV*))

  (foreach ch chs

    ;; Proposed RL
    (setq rl
          (XSEC:GetProposedRL
            ch
            *ProposedCSV*))
    (XSEC:CalcGridStartRL rl)

    ;; Base Point
    (setq base

      (list

        (* spacing
           (- ch (car chs)))

        rl

        0.0

      )

    )

    ;; Draw Grid
    (XSEC:DrawVerticalGrid base)
    (XSEC:DrawHorizontalGrid base)

    ;; Draw Labels
    (XSEC:DrawRLLabels base)
    (XSEC:DrawOffsetLabels base)

    ;; Proposed
    (XSEC:DrawProposed base)

    ;; Working
    (XSEC:DrawWorkingSection
      base
      ch)

  )

)
(defun c:XDRAW ()

  (if (XSEC:LoadCSV)

    (XSEC:DrawAllSections)

  )

  (princ)

)

(princ "\n07_WORKING Loaded...")
(princ)