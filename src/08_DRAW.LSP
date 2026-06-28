;=========================================================
; XSEC PROJECT
; FILE : 08_DRAW.LSP
;=========================================================

(vl-load-com)

;----------------------------------------------------------
; Grid Base
;----------------------------------------------------------

(defun XSEC:GetGridBase (index / x)

  (setq x
        (* index
           (+ *XSEC-PROP-WIDTH*
              (* *XSEC-GRID-MARGIN* 4.0))))

  (list x 0.0 0.0)

)

;----------------------------------------------------------
; Tunnel Base
;----------------------------------------------------------

(defun XSEC:GetTunnelBase (index / gridBase)

  (setq gridBase
        (XSEC:GetGridBase index))

  gridBase

)

(defun XSEC:DrawSection
(
index
ch
/
rl
gridBase
tunnelBase
)

  (setq rl (XSEC:GetProposedRL ch *ProposedCSV*))

(if rl
  (progn

    (XSEC:CalcGridStartRL rl)

    (setq gridBase
          (XSEC:GetGridBase index))

    (setq tunnelBase
          (XSEC:GetTunnelBase index rl))

    (XSEC:DrawVerticalGrid gridBase)
    (XSEC:DrawHorizontalGrid gridBase)

    (XSEC:DrawRLLabels gridBase)
    (XSEC:DrawOffsetLabels gridBase)

    (XSEC:DrawProposed tunnelBase)
    (XSEC:DrawWorkingSection tunnelBase ch)
  )
)

)
;----------------------------------------------------------
; Draw All Sections
;----------------------------------------------------------

(defun XSEC:DrawAllSections (/ chs ch idx)

  (setq chs (XSEC:GetChainages *WorkingCSV*))

  (setq idx 0)

  (foreach ch chs

    (XSEC:DrawSection idx ch)

    (setq idx (1+ idx))

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