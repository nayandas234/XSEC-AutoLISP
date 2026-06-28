;=========================================================
; XSEC PROJECT
; FILE : 08_DRAW.LSP
;=========================================================

(vl-load-com)

;----------------------------------------------------------
; Calculate Base Point
;----------------------------------------------------------

(defun XSEC:GetBasePoint (index propRL / x y)

  ;; Horizontal spacing
  (setq x
        (* index
           (+ *XSEC-PROP-WIDTH*
              (* *XSEC-GRID-MARGIN* 4.0))))

  ;; Grid datum
  (XSEC:CalcGridStartRL propRL)

  ;; Proposed bottom
  (setq y
        (- propRL
           *XSEC-GRID-START-RL*))

  (list x y 0.0)

)
;----------------------------------------------------------
; Draw One Section
;----------------------------------------------------------

(defun XSEC:DrawSection (index ch / rl base)

  ;; Proposed RL
  (setq rl
        (XSEC:GetProposedRL
          ch
          *ProposedCSV*))

  (if rl

    (progn

      ;; Base Point
      (setq base
            (XSEC:GetBasePoint
              index
              rl))

      ;; Grid
      (XSEC:DrawVerticalGrid base)
      (XSEC:DrawHorizontalGrid base)

      ;; Labels
      (XSEC:DrawRLLabels base)
      (XSEC:DrawOffsetLabels base)

      ;; Proposed
      (XSEC:DrawProposed base)

      ;; Working
      (XSEC:DrawWorkingSection
        base
        ch)

    )

    (prompt
      (strcat
        "\nProposed RL not found for Chainage "
        (rtos ch 2 3)))

  )

)
;----------------------------------------------------------
; Draw All Sections
;----------------------------------------------------------

(defun XSEC:DrawAllSections (/ chainages ch index)

  (setq chainages
        (XSEC:GetChainages *WorkingCSV*))

  (setq index 0)

  (foreach ch chainages

    (XSEC:DrawSection
      index
      ch)

    (setq index (1+ index))

  )

)
;----------------------------------------------------------
; Main Command
;----------------------------------------------------------

(defun c:XDRAW ()

  (if (XSEC:LoadCSV)

    (progn

      (XSEC:DrawAllSections)

      (prompt "\nDone.")

    )

  )

  (princ)

)

(princ "\n08_DRAW Loaded...")
(princ)