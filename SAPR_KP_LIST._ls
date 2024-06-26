(setq ui_err "\nRepeat entry!"
	yn_list (list "y" "yes" "n" "no")
)

(defun user_input ()
 
  (setq 
     ;  d    w   h    d1  b   D   k    f    R  dp 
    d_other (list
    '(2.5 0.60 1.20 1.6  3  4.7 1.50 0.60 0.2 1.5)
    '(  3 0.80 1.45 2.0  4  5.6 1.65 0.75 0.2 2.0)
    '(  4 1.00 1.90 2.8  5  7.4 2.20 1.00 0.2 2.5)
    '(  5 1.20 2.30 3.5  6  9.2 2.50 1.25 0.4 3.5)
    '(  6 1.60 2.80 4.0  8 11.0 3.00 1.50 0.4 4.0)
    '(  8 2.00 3.70 5.5 10 14.5 4.00 2.00 0.5 5.5)
    '( 10 2.50 4.50 7.0 12 18.0 5.00 2.50 0.5 7.0)
    '( 12 3.00 5.40 9.0 16 21.5 6.00 3.00 0.6 8.5)
    )

    L_all (list
    6.0  8.0 10.0 12.0 14.0 16.0 18.0 20.0 22.0
    25.0 28.0 32.0 36.0 40.0 45.0 50.0 55.0 60.0
    70.0 80.0
    )
    
    L_unrec (list
    14.0 18.0 22.0 28.0 36.0 45.0 55.0 70.0
    )

    d_Lb (list
    '(2.5 (6.0 18.0))
    '(3.0 (6.0 60.0))
    '(4.0 (8.0 60.0))
    '(5.0 (12.0 80.0))
    '(6.0 (12.0 80.0))
    '(8.0 (22.0 80.0))
    '(10.0 (22.0 80.0))
    '(12.0 (28.0 80.0))
    )
    
    d_all (list
    2.5 3.0 4.0 5.0 6.0 8.0 10.0 12.0
    )

    base_point (list 0.0 0.0)

    view "M"
          
    d (caar d_Lb)
    views (list "m" "main" "s" "side")
    ui_base "\n Base Point: "
    ui_view "\n View [Main / Side]: "
    ui_dia "\n Thread diameter: "
    ui_unrec "\n The value is not recommended!"
    ui_len "\n Length of bolt"
    ui_ang "\n Slewing angle, degrees: "
    ui_dim "\n Measure (Yes/No): "
    L_d nil
    L_ds ""
    a_rot 0.0
    putdim "y"
    req_par nil
    aux_par nil
    runouts (list "n" "normal" "s" "short")
    runout "n"
  )
           
  (setq base_point (getpoint ui_base))

  (setq view (strcase (getstring ui_view) T))

  (while (= (member view views) nil)
    (prompt ui_err)
    (setq view (strcase (getstring ui_view) T))
  )
          
  (setq d (getreal ui_dia))

  (while (= (member d d_all) nil)
    (prompt ui_err)
    (setq d (getreal ui_dia))
  )

  (if (/= (member d d_unrec) nil)
    (prompt ui_unrec)
  )

  (if (or (= view "m") (= view "main"))
    (progn 
      (setq lims (cdr (assoc d d_Lb)))

      (foreach Li L_all
        (if (and (>= Li (caar lims)) (<= Li (cadr (last lims))))
          (progn
            (setq L_d (append L_d (list Li)))
            (setq L_ds (strcat L_ds (rtos Li 2 2) ","))
          )
        )
      )

      (setq L (getreal
        (strcat ui_len
          " <"
          (substr L_ds 1 (- (strlen L_ds) 1))
          ">: ")))
      )
    )
  )
  
  (setq other (assoc d d_other))
  (setq a_rot (getreal ui_ang))
  (while (not (numberp a_rot))
    (prompt ui_err)
    (setq a_rot (getreal ui_ang))
  )
  
  (setq putdim (strcase (getstring ui_dim) T))
  (while (= (member putdim yn_list) nil)
    (prompt ui_err)
    (setq putdim (strcase (getstring ui_dim) T))
  )

  (setq
    req_par (list (car base_point)
    (cadr base_point))
    view
    other
    a_rot
    putdim
  )

  (if (or (= view "m") (= view "main"))
    (setq req_par (append req_par
          (list d L b)
          (cdr other))
    )
  )

  (append req_par)
)

(defun olayer (
  lcol
  ltyp
  lwei
  ui_str
  def_lname
  )

  (setq lname (getstring (strcat ui_str " <" def_lname ">: ")))

  (if (= lname "")
	  (setq lname def_lname)
  )

  (command
    "layer" "new" lname
	  "color" lcol lname
	  "ltype" ltyp lname
	  "lweight" lwei lname ""
  )

  (eval lname)
)

(defun tune_env (/ ui_lb ui_lax ui_ltb ui_ldm)
  (command ".erase" "all" "")
  (command "snap" "off")
  (command "grid" "on")
  (setvar "osmode" 0)
  (setvar "dimtoh" 1)
  (setvar "dimexo" 0)
  (setvar "aperture" 5)
  (setvar "ltscale" 2)
  (setq 
    ui_lb "\n Enter the name of the main lines layer"
	  ui_lax "\n Enter the name of the axis line layer"
	  ui_ltb "\n Enter the name of the fine line layer"
	  ui_ldm "\n Enter the name of the dimensional lines layer"
  )
  (setq 
    layer_base
    (olayer "240" "continuous" "0.30" ui_lb "base")

    layer_axial
    (olayer "9" "center" "0.15" ui_lax "axial")

    layer_thin
    (olayer "7" "continuous" "0.15" ui_ltb "tbase")

    layer_dims
    (olayer "9" "continuous" "0.15" ui_ldm "dim")
  )
)

(defun plot_main (pd)
 	(setq pt1 (list (car pd) (cadr pd))
 		pd1 (list (car pd) 
 			(+ (/ (nth 1 other) 2.0) (cadr pd)))	
 		pd2 (list (car pd)
 			(+ (- (/ (nth 1 other) 2.0)) (cadr pd)))
; 		pd3 (list (+ (- (- (nth 2 other)) 1(car pd))
; 			(+ (/ (nth 1 other2.0) (cadr pd))) 
; 		pd4 (list (+ (- (- (nth 2 other)) 1(car pd))
; 			(+ (- (/ (nth 1 other) 2.0)) (cadr pd)))
; 		pd5 (list (+ (+ (- (nth 2 other)(nth 7 other)) (car pd)) 
; 			(cadr pd))	
; 		pd6 (list (+ (+ (- (nth 2 other)) (nth 7 other)(car pd)
; 			(+ (/ (nth 5 other) 2.0(cadr pd)))
; 		pd7 (list (+ (+ (- (nth 2 other)) (nth 7 other)(car pd))
; 			(+ (- (/ (nth 5 other) 2.0)) (cadr pd)))
; 		pd8 (list (+ (- (nth 2 other)) (car pd))
; 			(cadr pd))
; 		pd9 (list (+ (+ (+ (- (nth 2 other)(nth 7 other)) (/ (nth 7 req_par 2.0)(car pd))
; 			(+ (/ (nth 5 other2.0) (cadr pd)))
; 		pd10 (list (+ (+ (+ (- (nth 2 other)(nth 7 other)) (/ (nth 7 req_par 2.0)(car pd)
; 			(+ (- (/ (nth 5 other2.0)(cadr pd)))
; 		pd11 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (car pd))
; 			(cadr pd))
; 		pd12 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (car pd))
; 			(+ (/ (nth 9 other) 2.0(cadr pd)))
; 		pd13 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (car pd))
; 			(+ (- (/ (nth 9 other2.0)(cadr pd)))
; 		pd14 (list (+ (- (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(- (/ (nth 0 other2.0) (/ (nth 9 other2.0))) (car pd))
; 			(+ (/ (nth 0 other) 2.0(cadr pd)))
		
; 		pd15 (list (+ (- (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(- (- (/ (nth 9 other) 2.0)) (- (/ (nth 0 other) 2.0))(car pd))
; 			(+ (- (/ (nth 0 other) 2.0)) (cadr pd)))
; 		pd16 (list (+ (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(car pd))
; 			(+ (/ (nth 0 other2.0) (cadr pd)))
; 		pd17 (list (+ (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(car pd)
; 			(+ (- (/ (nth 0 other2.0)(cadr pd)))
; 		pd18 (list (+ (- (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(nth 4 other)) (car pd)) 
; 			(+ (/ (nth 0 other2.0) (cadr pd)))
; 		pd19 (list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (nth 4 other)(car pd)
; 			(+ (- (/ (nth 0 other2.0)(cadr pd)))

; 		pd22 (list (+ (- (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(nth 4 other)) (car pd))
; 			(+ (/ (nth 3 other) 2.0(cadr pd)))
; 		pd23 (list (+ (+ (nth 6 other0) (car pd))
; 			(+ (/ (nth 3 other) 2.0(cadr pd)))
; 		pd24 (list (+ (- (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(nth 4 other)) (car pd)) 
; 			(+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
; 		pd25 (list (+ (+ (nth 6 other) 0)(car pd))
; 			(+ (- (/ (nth 3 other) 2.0)) (cadr pd)))

; 		pd26(list  (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (nth 4 other)(car pd))
; 			(+ (+ (/ (nth 3 other) 2.0(nth 8 other)) (cadr pd)))
; 		pd27(list  (+ (- (- (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(nth 4 other)) (nth 8 other)(car pd))
; 			(+ (/ (nth 3 other2.0) (cadr pd)))
; 		pd28(list (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (nth 4 other)(nth 8 other)) (car pd))
; 			(+ (- (/ (nth 3 other2.0)(cadr pd)))
; 		pd29(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (nth 4 other)(car pd))
; 			(+ (- (- (/ (nth 3 other2.0)(nth 8 other)) (cadr pd)))
; 		pd30(list (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (nth 4 other)(/ (nth 8 other) 2.0)) (car pd))
; 			(+ (/ (nth 3 other) 2.0(cadr pd)))
; 		pd31(list (+ (- (- (+ (+ (- (nth 2 other)(nth 7 other)) (nth 7 req_par)(nth 4 other)) (/ (nth 8 other2.0)(car pd))
; 			(+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
; 		pd32(list (+ (+ (- (nth 2 other)(nth 7 other)) (car pd))
; 			(+ (- (/ (nth 0 other2.0)(cadr pd)))
;     ;pzs1(list (+ (- (- (- (+ (+ (- (nth 2 other)) (nth 7 other)(nth 7 req_par)) (nth 4 other)(/ (nth 8 other) 2.0) 2.0)) (car pd))
;      ; )
		
	)

 	(setq cside (ssadd))
 	(command "layer" "set" layer_base "")
 	(command "line" pd1 pd2 "")
; 	(command "line" pd1 pd3 "")
; 	(command "line" pd2 pd4 "")
; 	(command "line" pd7 pd6 "")
; 	(command "arc" pd6 pd8 pd7)
; 	(command "line" pd9 pd6 "")
; 	(command "line" pd10 pd7 "")
; 	(command "line" pd12 pd13 "")
; 	(command "line" pd12 pd14 "")
; 	(command "line" pd13 pd15 "")
; 	(command "line" pd14 pd15 "")
; 	(command "line" pd16 pd18 "")
; 	(command "line" pd17 pd19 "")
; 	(command "line" pd18 pd19 "")
; 	(command "line" pd22 pd23 "")
; 	(command "line" pd24 pd25 "")
; 	(command "trim" "o" "q" "" pd3 pd4 pd5 pd8 pd16 pd17 "")
; 	(command "filletrad" (nth 8 other)) 
; 	(command "fillet" "trim" "no" pd26 pd27)
; 	(command "fillet" "trim" "no" pd28 pd29)
; 	(command "trim" "o" "q" "" pd3 pd4 pd5 pd8 pd16 pd17 "")
; 	(command "zoom" "w" (list 3.0 1.2) (list 3.4 -1.2))
; 	(command "trim" "o" "q" "" pd30 pd31 "")
; 	(command "zoom" "p")

)

(defun GOST ()
  (tune_env)
  (setq plot_data (user_input))
  (if (= (substr (nth 2 plot_data) 1 1) "s")
    (plot_side plot_data)
    (plot_main plot_data)
  )
    (setvar "cmdecho" 1)
    (setvar "lwdisplay" 1)
)

























