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

(defun XSEC:DrawBottom (base / p1 p2)

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

  (entmakex

    (list

      '(0 . "LINE")

      (cons 8 *XSEC-LAYER-PROPOSED*)

      (cons 10 p1)

      (cons 11 p2)

    )

  )

)
;----------------------------------------------------------
; Left Wall
;----------------------------------------------------------

(defun XSEC:DrawLeftWall (base / p1 p2)

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

  (entmakex

    (list

      '(0 . "LINE")

      (cons 8 *XSEC-LAYER-PROPOSED*)

      (cons 10 p1)

      (cons 11 p2)

    )

  )

)

;----------------------------------------------------------
; Right Wall
;----------------------------------------------------------

(defun XSEC:DrawRightWall (base / p1 p2)

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

  (entmakex

    (list

      '(0 . "LINE")

      (cons 8 *XSEC-LAYER-PROPOSED*)

      (cons 10 p1)

      (cons 11 p2)

    )

  )

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

ell

)
;----------------------------------------------------------
; Draw Proposed
;----------------------------------------------------------

(defun XSEC:DrawProposed (base)

  (XSEC:DrawBottom base)

  (XSEC:DrawLeftWall base)

  (XSEC:DrawRightWall base)

  (XSEC:DrawCrown base)

)

(defun c:XTEST ()

  (XSEC:DrawProposed '(0.0 0.0 0.0))

  (princ)

)

(princ "\n05_PROPOSED Loaded...")
(princ)