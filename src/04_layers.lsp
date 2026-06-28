;=========================================================
; XSEC PROJECT
; FILE : 04_LAYERS.LSP
; PART : A
;=========================================================

(vl-load-com)

;----------------------------------------------------------
; Create Layer
;----------------------------------------------------------

(defun XSEC:CreateLayer (lay clr ltype / doc lays obj)

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq lays (vla-get-Layers doc))

  (if (tblsearch "LAYER" lay)

    (setq obj (vla-Item lays lay))

    (setq obj (vla-Add lays lay))

  )

  (vla-put-Color obj clr)

  (if (tblsearch "LTYPE" ltype)
    (vla-put-Linetype obj ltype)
  )

  obj

)

;----------------------------------------------------------
; Make Layer Current
;----------------------------------------------------------

(defun XSEC:SetLayer (lay)

  (if (tblsearch "LAYER" lay)
    (setvar "CLAYER" lay)
  )

)

;----------------------------------------------------------
; Create All Project Layers
;----------------------------------------------------------

(defun XSEC:CreateLayers ()

  (XSEC:CreateLayer *XSEC-LAYER-GRID*      *CLR-GRID*     "Continuous")
  (XSEC:CreateLayer *XSEC-LAYER-TEXT*      *CLR-TEXT*     "Continuous")
  (XSEC:CreateLayer *XSEC-LAYER-WORKING*   *CLR-WORKING*  "Continuous")
  (XSEC:CreateLayer *XSEC-LAYER-PROPOSED*  *CLR-PROPOSED* "Continuous")
  (XSEC:CreateLayer *XSEC-LAYER-CENTER*    *CLR-CENTER*   "CENTER")
  (XSEC:CreateLayer *XSEC-LAYER-TABLE*     *CLR-TABLE*    "Continuous")
  (XSEC:CreateLayer *XSEC-LAYER-BORDER*    *CLR-BORDER*   "Continuous")

  T

)

(princ "\n04_LAYERS Loaded...")
(princ)