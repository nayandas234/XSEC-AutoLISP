;=========================================================
; XSEC PROJECT
; FILE : 01_GLOBALS.LSP
; VERSION : 1.0
;=========================================================

(vl-load-com)

(setq *XSEC-VERSION* "1.0")

;;--------------------------------------------------------
;; Proposed Tunnel Geometry (Fixed)
;;--------------------------------------------------------

(setq *XSEC-PROP-WIDTH*        5.000)
(setq *XSEC-PROP-WALL-HEIGHT*  4.000)
(setq *XSEC-PROP-CROWN-RISE*   1.500)
(setq *XSEC-PROP-TOTAL-HEIGHT* 5.500)

(setq *XSEC-PROP-HALF-WIDTH*
      (/ *XSEC-PROP-WIDTH* 2.0))

;;--------------------------------------------------------
;; Grid
;;--------------------------------------------------------

(setq *XSEC-GRID-SPACING* 1.000)
(setq *XSEC-TEXT-HEIGHT* 0.20)
(setq *XSEC-DIM-SCALE* 1.0)

;;--------------------------------------------------------
;; Layers
;;--------------------------------------------------------

(setq *XSEC-LAYER-GRID*      "XSEC_GRID")
(setq *XSEC-LAYER-TEXT*      "XSEC_TEXT")
(setq *XSEC-LAYER-WORKING*   "XSEC_WORKING")
(setq *XSEC-LAYER-PROPOSED*  "XSEC_PROPOSED")
(setq *XSEC-LAYER-CENTER*    "XSEC_CENTER")
(setq *XSEC-LAYER-TABLE*     "XSEC_TABLE")
(setq *XSEC-LAYER-BORDER*    "XSEC_BORDER")

;;--------------------------------------------------------
;; Colors
;;--------------------------------------------------------

(setq *CLR-GRID*      8)
(setq *CLR-TEXT*      7)
(setq *CLR-WORKING*   3)
(setq *CLR-PROPOSED*  6)
(setq *CLR-CENTER*    1)
(setq *CLR-TABLE*     2)
(setq *CLR-BORDER*    7)

;;--------------------------------------------------------
;; Runtime Variables
;;--------------------------------------------------------

(setq *WorkingCSV* nil)
(setq *ProposedCSV* nil)

(setq *CurrentChainage* nil)
(setq *CurrentProposedRL* nil)

(setq *WorkingPoints* nil)

(setq *WorkingArea* 0.0)
(setq *WorkingPerimeter* 0.0)

(setq *InsertPoint* nil)

;;--------------------------------------------------------
;; Error Handler
;;--------------------------------------------------------

(defun XSEC:Error (msg)

  (if
    (and
      msg
      (/= msg "Function cancelled")
    )

    (prompt
      (strcat
        "\n[XSEC ERROR] "
        msg
      )
    )

  )

  (setvar "CMDECHO" 1)

  (princ)

)

;;--------------------------------------------------------
;; Start Undo
;;--------------------------------------------------------

(defun XSEC:UndoBegin ()

  (command "._UNDO" "_BEGIN")

)

;;--------------------------------------------------------
;; End Undo
;;--------------------------------------------------------

(defun XSEC:UndoEnd ()

  (command "._UNDO" "_END")

)

;;--------------------------------------------------------
;; Message
;;--------------------------------------------------------

(defun XSEC:Msg (txt)

  (prompt

    (strcat

      "\n[XSEC] "

      txt

    )

  )

)

;;--------------------------------------------------------
;; Real → String
;;--------------------------------------------------------

(defun XSEC:R (v)

  (rtos v 2 3)

)

;;--------------------------------------------------------

(princ
 "\nXSEC GLOBALS LOADED..."
)

(princ)
