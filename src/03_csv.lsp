;=========================================================
; XSEC PROJECT
; FILE : 03_CSV.LSP
; PART : A
;=========================================================

(vl-load-com)

;----------------------------------------------------------
; Trim String
;----------------------------------------------------------

(defun XSEC:Trim (s)

  (if s
    (vl-string-trim " \t\r\n\"" s)
    ""
  )

)

;----------------------------------------------------------
; Split CSV Line
;----------------------------------------------------------

(defun XSEC:SplitCSV (str / pos out)

  (setq out '())

  (while (setq pos (vl-string-search "," str))

    (setq out
      (cons
        (XSEC:Trim (substr str 1 pos))
        out
      )
    )

    (setq str
      (substr str (+ pos 2))
    )

  )

  (reverse
    (cons
      (XSEC:Trim str)
      out
    )
  )

)

;----------------------------------------------------------
; Open CSV Dialog
;----------------------------------------------------------

(defun XSEC:GetCSVFile (title)

  (getfiled
    title
    ""
    "csv"
    8
  )

)

;----------------------------------------------------------
; Read Working CSV
; Format:
; CHAINAGE,OFFSET,RL
;----------------------------------------------------------

(defun XSEC:ReadWorkingCSV
(
fname
/
fp
line
row
data
)

(setq data '())

(if
  (setq fp (open fname "r"))

  (progn

    ;; Skip Header
    (read-line fp)

    (while
      (setq line (read-line fp))

      (setq row
        (XSEC:SplitCSV line)
      )

      (if (= (length row) 3)

        (setq data

          (cons

            (list

              (atof (nth 0 row))   ; Chainage
              (atof (nth 1 row))   ; Offset
              (atof (nth 2 row))   ; RL

            )

            data

          )

        )

      )

    )

    (close fp)

  )

)

(reverse data)

)
;----------------------------------------------------------
; Read Proposed RL CSV
; Format:
; CHAINAGE,RL
;----------------------------------------------------------

(defun XSEC:ReadProposedCSV
(
fname
/
fp
line
row
data
)

  (setq data '())

  (if
    (setq fp (open fname "r"))

    (progn

      ;; Skip Header
      (read-line fp)

      (while
        (setq line (read-line fp))

        (setq row
          (XSEC:SplitCSV line)
        )

        (if (= (length row) 2)

          (setq data

            (cons

              (list

                (atof (nth 0 row)) ; Chainage
                (atof (nth 1 row)) ; RL

              )

              data

            )

          )

        )

      )

      (close fp)

    )

  )

  (reverse data)

)

;----------------------------------------------------------
; Get All Chainages
;----------------------------------------------------------

(defun XSEC:GetChainages
(
lst
/
out
)

  (setq out '())

  (foreach r lst

    (if
      (not (member (car r) out))

      (setq out

        (append

          out

          (list (car r))

        )

      )

    )

  )

  out

)

;----------------------------------------------------------
; Get Working Section
;----------------------------------------------------------

(defun XSEC:GetWorkingSection
(
ch
lst
/
out
)

  (setq out '())

  (foreach r lst

    (if

      (equal
        (car r)
        ch
        1e-8
      )

      (setq out

        (cons

          (list

            (cadr r)

            (caddr r)

          )

          out

        )

      )

    )

  )

  (reverse out)

)

;----------------------------------------------------------
; Get Proposed RL
;----------------------------------------------------------

(defun XSEC:GetProposedRL
(
ch
lst
/
rl
)

  (setq rl nil)

  (foreach r lst

    (if

      (equal
        (car r)
        ch
        1e-8
      )

      (setq rl

        (cadr r)

      )

    )

  )

  rl

)
;----------------------------------------------------------
; Check Duplicate Chainage
;----------------------------------------------------------

(defun XSEC:DuplicateChainages
(
lst
/
seen
dup
)

  (setq seen '())
  (setq dup '())

  (foreach r lst

    (if

      (member (car r) seen)

      (if

        (not (member (car r) dup))

        (setq dup

          (cons (car r) dup)

        )

      )

      (setq seen

        (cons (car r) seen)

      )

    )

  )

  (reverse dup)

)

;----------------------------------------------------------
; Check Missing Proposed RL
;----------------------------------------------------------

(defun XSEC:MissingProposedRL
(
working
proposed
/
miss
)

  (setq miss '())

  (foreach ch

    (XSEC:GetChainages working)

    (if

      (null

        (XSEC:GetProposedRL

          ch

          proposed

        )

      )

      (setq miss

        (cons ch miss)

      )

    )

  )

  (reverse miss)

)

;----------------------------------------------------------
; CSV Summary
;----------------------------------------------------------

(defun XSEC:CSVSummary ()

  (XSEC:Msg
    (strcat
      "Working Points : "
      (itoa (length *WorkingCSV*))
    )
  )

  (XSEC:Msg
    (strcat
      "Working Chainages : "
      (itoa
        (length
          (XSEC:GetChainages *WorkingCSV*)
        )
      )
    )
  )

  (XSEC:Msg
    (strcat
      "Proposed RL : "
      (itoa (length *ProposedCSV*))
    )
  )

)

;----------------------------------------------------------
; Load Both CSV Files
;----------------------------------------------------------

(defun XSEC:LoadCSV (/ wf pf)

  (setq wf (XSEC:GetCSVFile "Select Working Section CSV"))

  (if (null wf)

    (progn
      (XSEC:Msg "Working CSV not selected.")
      nil
    )

    (progn

      (setq pf (XSEC:GetCSVFile "Select Proposed RL CSV"))

      (if (null pf)

        (progn
          (XSEC:Msg "Proposed RL CSV not selected.")
          nil
        )

        (progn

          (setq *WorkingCSV*
                (XSEC:ReadWorkingCSV wf))

          (setq *ProposedCSV*
                (XSEC:ReadProposedCSV pf))

          (XSEC:CSVSummary)

          T

        )

      )

    )

  )

)

(princ
 "\n03_CSV Loaded..."
)
(princ)