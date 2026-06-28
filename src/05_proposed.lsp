;=========================================================
; XSEC PROJECT
; FILE : 05_PROPOSED.LSP
;=========================================================

(vl-load-com)

;----------------------------------------------------------
; ModelSpace
;----------------------------------------------------------

(defun XSEC:GetModelSpace (/ acad doc)

  (setq acad (vlax-get-acad-object))
  (setq doc  (vla-get-ActiveDocument acad))

  (vla-get-ModelSpace doc)

)

;----------------------------------------------------------
; Bottom Line
;----------------------------------------------------------

(defun XSEC:DrawBottom (base / p1 p2 e)

  (setq p1
    (list
      (- (car base) (/ *XSEC-PROP-WIDTH* 2.0))
      (cadr base)
      0.0
    )
  )

  (setq p2
    (list
      (+ (car base) (/ *XSEC-PROP-WIDTH* 2.0))
      (cadr base)
      0.0
    )
  )

(setq e
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-PROPOSED*)
      (cons 10 p1)
      (cons 11 p2)
    )
  )
)

e

)
;----------------------------------------------------------
; Left Wall
;----------------------------------------------------------

(defun XSEC:DrawLeftWall (base / p1 p2 e)

  (setq p1
  (list
    (- (car base)
       (/ *XSEC-PROP-WIDTH* 2.0))
    (cadr base)
    0.0
  )
)

  (setq p2
    (list
      (- (car base) (/ *XSEC-PROP-WIDTH* 2.0))
      (+ (cadr base) *XSEC-PROP-WALL-HEIGHT*)
      0.0
    )
  )

(setq e
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-PROPOSED*)
      (cons 10 p1)
      (cons 11 p2)
    )
  )
)

e
  
)

;----------------------------------------------------------
; Right Wall
;----------------------------------------------------------

(defun XSEC:DrawRightWall (base / p1 p2 e)

  (setq p1
  (list
    (+ (car base)
       (/ *XSEC-PROP-WIDTH* 2.0))
    (cadr base)
    0.0
  )
)

  (setq p2
    (list
      (+ (car base) (/ *XSEC-PROP-WIDTH* 2.0))
      (+ (cadr base) *XSEC-PROP-WALL-HEIGHT*)
      0.0
    )
  )

(setq e
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-PROPOSED*)
      (cons 10 p1)
      (cons 11 p2)
    )
  )
)

e

)

;----------------------------------------------------------
; Ellipse Crown
;----------------------------------------------------------

(defun XSEC:DrawCrown (base / ms cen maj ell)

  (setq ms (XSEC:GetModelSpace))

  (setq cen

    (vlax-3d-point

      (list

        (car base)

        (+ (cadr base) *XSEC-PROP-WALL-HEIGHT*)

        0.0

      )

    )

  )

  (setq maj

    (vlax-3d-point

      (list

        (/ *XSEC-PROP-WIDTH* 2.0)

        0.0

        0.0

      )

    )

  )

  (setq ell

  (vla-AddEllipse

    ms

    cen

    maj

    (/ *XSEC-PROP-CROWN-RISE*
       (/ *XSEC-PROP-WIDTH* 2.0))

  )

)

(vla-put-Layer ell *XSEC-LAYER-PROPOSED*)

(vla-put-StartParameter ell 0.0)

(vla-put-EndParameter ell pi)

(vlax-vla-object->ename ell)

)
;----------------------------------------------------------
; Draw Center Line
;----------------------------------------------------------

(defun XSEC:DrawCenterLine (base / p1 p2 e)

  (setq p1
    (list
      (car base)
      (- (cadr base) 1.0)
      0.0
    )
  )

  (setq p2
    (list
      (car base)
      (+ (cadr base) *XSEC-PROP-TOTAL-HEIGHT* 1.0)
      0.0
    )
  )

(setq e
  (entmakex
    (list
      '(0 . "LINE")
      (cons 8 *XSEC-LAYER-CENTER*)
      (cons 10 p1)
      (cons 11 p2)
    )
  )
)

e

)
;----------------------------------------------------------
; Draw Proposed
;----------------------------------------------------------

(defun XSEC:DrawProposed (base / ent)

  (setq ent '())

  (setq ent (cons (XSEC:DrawBottom base) ent))
  (setq ent (cons (XSEC:DrawLeftWall base) ent))
  (setq ent (cons (XSEC:DrawRightWall base) ent))
  (setq ent (cons (XSEC:DrawCrown base) ent))
  (setq ent (cons (XSEC:DrawCenterLine base) ent))

  (reverse ent)

)

(defun c:XTEST ()

  (XSEC:DrawProposed '(0.0 0.0 0.0))

  (princ)

)

(princ "\n05_PROPOSED Loaded...")
(princ)