(setq ui_err "\nRepeat entry!"
	yn_list (list "y" "yes" "n" "no")
)

(defun user_input ()
 
  (setq 
     ;  d   w   h   d1   b   D   k    f    R  dp 
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
    ui_base "\n ������ �����: "
    ui_view "\n ��� [Main (��������) / Side (�����)]: "
    ui_dia "\n ĳ����� �����: "
    ui_unrec "\n �������� �� �������������!"
    ui_len "\n ����� �����"
    ui_ang "\n ��� ��������, �������: "
    ui_dim "\n ���������� ������ (Yes/No): "
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
          ">: "))
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
    (cadr base_point)
    view
    other
    a_rot
    putdim)
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

(defun tune_env (/ ui_lb ui_lax ui_ltb ui_ldm ui_sup)
  (command ".erase" "all" "")
  (command "snap" "off")
  (command "grid" "on")
  (setvar "osmode" 0)
  (setvar "dimtoh" 1)
  (setvar "dimexo" 0)
  (setvar "aperture" 5)
  (setvar "ltscale" 2)
  (setq 
    ui_lb "\n ������ ��'� ���� �������� ����"
    ui_lax "\n ������ ��'� ���� ������� ����"
    ui_ltb "\n ������ ��'� ���� ������ ����"
    ui_ldm "\n ������ ��'� ���� �������� ����"
    ui_sup "\n ������ ��'� ���� ���������� ����"

  )
  (setq 
    layer_base
    (olayer "240" "continuous" "0.30" ui_lb "base")

    layer_axial
    (olayer "9" "center" "0.15" ui_lax "axial")
    
    layer_sup
    (olayer "240" "center" "0.15" ui_sup "supplement")

    layer_thin
    (olayer "240" "continuous" "0.15" ui_ltb "tbase")

    layer_dims
    (olayer "9" "continuous" "0.15" ui_ldm "dim")
  )
)

(defun tan (num)
 (/ (sin num)(cos num))
)

(defun plot_main (pd)
 	(setq pt1 (list (car pd) (cadr pd))
 		pd1 (list (car pd) 
 		  	(+ (/ (nth 1 other) 2.0) (cadr pd)))	
 		pd2 (list (car pd)
 	  		(+ (- (/ (nth 1 other) 2.0)) (cadr pd)))
 		pd3 (list (+ (- (- (nth 2 other)) 1) (car pd))
 		  	(+ (/ (nth 1 other) 2.0) (cadr pd))) 
 		pd4 (list (+ (- (- (nth 2 other)) 1) (car pd))
 		  	(+ (- (/ (nth 1 other) 2.0)) (cadr pd)))
 		pd5 (list (+ (+ (- (nth 2 other)) (nth 7 other)) (car pd)) 
 		  	(cadr pd))	
 		pd6 (list (+ (+ (- (nth 2 other)) (nth 7 other)) (car pd))
 		  	(+ (/ (nth 5 other) 2.0) (cadr pd)))
 		pd7 (list (+ (+ (- (nth 2 other)) (nth 7 other)) (car pd))
 		  	(+ (- (/ (nth 5 other) 2.0)) (cadr pd)))
 		pd8 (list (+ (- (nth 2 other)) (car pd))
 		  	(cadr pd))
 		pd9 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (/ (nth 7 req_par) 2.0)) (car pd))
 		  	(+ (/ (nth 5 other) 2.0) (cadr pd)))
 		pd10 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (/ (nth 7 req_par) 2.0)) (car pd))
 		  	(+ (- (/ (nth 5 other) 2.0)) (cadr pd)))
 		pd11 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (car pd))
 		  	(cadr pd))
 		pd12 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (car pd))
 		  	(+ (/ (nth 9 other) 2.0) (cadr pd)))
 		pd13 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (car pd))
 		  	(+ (- (/ (nth 9 other) 2.0)) (cadr pd)))
 		pd14 (list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (- (/ (nth 0 other) 2.0) (/ (nth 9 other) 2.0))) (car pd))
 		  	(+ (/ (nth 0 other) 2.0) (cadr pd)))
 		pd15 (list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (- (- (/ (nth 9 other) 2.0)) (- (/ (nth 0 other) 2.0)))) (car pd))
 		  	(+ (- (/ (nth 0 other) 2.0)) (cadr pd)))
 		pd16 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (car pd))
 		  	(+ (/ (nth 0 other) 2.0) (cadr pd)))
 		pd17(list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (car pd))
 		  	(+ (- (/ (nth 0 other) 2.0)) (cadr pd)))
 		pd18(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (car pd)) 
 		  	(+ (/ (nth 0 other) 2.0) (cadr pd)))
 		pd19(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (car pd))
 			  (+ (- (/ (nth 0 other) 2.0)) (cadr pd)))
 		pd22(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (car pd))
 			  (+ (/ (nth 3 other) 2.0) (cadr pd)))
 		pd23(list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (car pd))
 			  (+ (/ (nth 3 other) 2.0) (cadr pd)))
 		pd24(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (car pd)) 
 			  (+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
 		pd25 (list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (car pd))
 			  (+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
 		pd26(list  (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (car pd))
 		  	(+ (+ (/ (nth 3 other) 2.0) (nth 8 other)) (cadr pd)))
 		pd27(list  (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (nth 8 other)) (car pd))
   			(+ (/ (nth 3 other) 2.0) (cadr pd)))
 		pd28(list (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (nth 8 other)) (car pd))
 		  	(+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
 		pd29(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (car pd))
 			  (+ (- (- (/ (nth 3 other) 2.0)) (nth 8 other)) (cadr pd)))
 		pd30(list (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (/ (nth 8 other) 2.0)) (car pd))
 			  (+ (/ (nth 3 other) 2.0) (cadr pd)))
 		pd31(list (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (/ (nth 8 other) 2.0)) (car pd))
 		  	(+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
    pzs1(list (+ (- (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (/ (nth 8 other) 2.0)) 0.1) (car pd))
 	  		(+ (+ (/ (nth 3 other) 2.0) 0.1) (cadr pd)))
    pzs2(list (+ (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (/ (nth 8 other) 2.0)) 0.1) (car pd))
   			(+ (- (- (/ (nth 3 other) 2.0)) 0.1) (cadr pd)))
    pd32(list  (+ (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (nth 8 other)) (* (nth 4 other) 1.3)) (car pd))
 			  (+ (/ (nth 3 other) 2.0) (cadr pd)))  
    pd33(list (+ (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (nth 8 other)) (*(nth 4 other) 1.3)) (car pd))
 			  (+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
    pd34(list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (car pd)) 
        (+ (- (/ (nth 0 other) 2.0)) (cadr pd)))
    pd35(list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (car pd)) 
        (+ (/ (nth 0 other) 2.0) (cadr pd)))
    pd36(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (/ (nth 5 other) 2.0) (/ (nth 0 other) 2.0))) (car pd))
        (+ (/ (nth 5 other) 2.0) (cadr pd)))
    pd37(list (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (/ (nth 0 other) 2.0) (/ (nth 3 other) 2.0)) (car pd))
        (+ (/ (nth 3 other) 2.0) (cadr pd)))
    pd38(list (+ (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (/ (nth 0 other) 2.0) (/ (nth 3 other) 2.0)) (nth 8 other)) (car pd))
        (+ (/ (nth 3 other) 2.0) (cadr pd)))
    pd40(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (- (/ (nth 0 other) 2.0)) (- (/ (nth 5 other) 2.0)))) (car pd))
        (+ (- (/ (nth 5 other) 2.0)) (cadr pd)))
    pd41(list (+ (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (- (/ (nth 3 other) 2.0)) (- (/ (nth 0 other) 2.0)))) (car pd))
        (+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
    pd42(list (+ (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (- (/ (nth 0 other) 2.0)) (- (/ (nth 5 other) 2.0)))) (car pd))
        (cadr pd))
    pd43(list  (+ (+ (/ (nth 8 other) (tan (* 0.375 pi))) (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (/ (nth 0 other) 2.0) (/ (nth 3 other) 2.0))) (car pd))
        (+ (/ (nth 3 other) 2.0) (cadr pd)))
    pd44(list (+ (+ (+ (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (- (/ (nth 3 other) 2.0)) (- (/ (nth 0 other) 2.0)))) (nth 8 other)) (car pd))
        (+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
    pd45(list (+ (+ (/ (nth 8 other) (tan (* 0.375 pi))) (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (/ (nth 0 other) 2.0) (/ (nth 3 other) 2.0))) (car pd))
         (+ (- (/ (nth 3 other) 2.0)) (cadr pd)))
    pz1(list (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (nth 8 other)) (car pd))
       (+ (+ (/ (nth 3 other) 2.0) (nth 8 other)) (cadr pd)))
    pz2(polar pz1 (/ (* 7 pi) 4) (nth 8 other))
    pz3(list (+ (- (- (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 7 req_par)) (nth 4 other)) (nth 8 other)) (car pd))
       (+ (+ (/ (nth 3 other) 2.0) (* (nth 8 other) 4)) (cadr pd)))
    pz4(list (+ (+ (/ (nth 8 other) (tan (* 0.375 pi))) (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (/ (nth 0 other) 2.0) (/ (nth 3 other) 2.0))) (car pd))
        (+ (+ (/ (nth 3 other) 2.0) (nth 8 other) ) (cadr pd)))
    pz5(polar pz4 (/ (* 13 pi) 9) (nth 8 other))
    pz6(list (+ (+ (/ (nth 8 other) (tan (* 0.375 pi))) (+ (+ (- (nth 2 other)) (nth 7 other)) (nth 6 other)) (- (/ (nth 0 other) 2.0) (/ (nth 3 other) 2.0))) (car pd))
        (+ (+ (/ (nth 3 other) 2.0) (* (nth 8 other) 4) ) (cadr pd)))
    pzb1(list (+ (car pd37) (* (nth 8 other) 3))
        (+ (cadr pd37) (* (nth 8 other) 3)))
    pzb2(list (- (car pd37) (* (nth 8 other) 3))
    (- (cadr pd37) (* (nth 8 other) 3)))
    pz7(list (+ (car pd) (* (nth 6 other) 1.25))
       (cadr pd))
    pz8(list (car pd7)
       (- (cadr pd7) (* (nth 6 other) 0.3)))
		pz9(list (car pd7)
       (- (cadr pd7) (* (nth 6 other) 0.9)))
    pz10(list (+ (car pd11) (* (nth 6 other) 0.6))
        (cadr pd))
    pz11(list (+ (car pd19) 1)
        (- (cadr pd19) (* (nth 6 other) 0.6)))
    pz12(list (car pz9)
        (- (cadr pz9) (* (nth 6 other) 0.3)))
    pz13(list (- (car pd8) (* (nth 6 other) 0.5))
         (cadr pd8))
    pzd1(polar pd35 (/(* pi 3) 4) 0.5)
    pzd2(polar pd34 (/ (* pi 5) 4) 0.5)
    pz14(list (- (car pz13) (* (nth 6 other) 0.7))
        (cadr pz13))
    pzm1(list (- (car pz14) (* (nth 6 other) 0.5))
         (+ (cadr pz14) (* (nth 5 other) 0.9)))
    pzm2(list (+ (car pd11) (nth 6 other))
        (- (cadr pd11) (nth 5 other)))       
	)

 	(setq cside (ssadd))
  (command "zoom" "w" pzm1 pzm2)
 	(command "layer" "set" layer_base "")
 	(command "line" pd1 pd2 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd1 pd3 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd2 pd4 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd7 pd6 "")
  (setq cside (ssadd (entlast) cside))
 	(command "arc" pd6 pd8 pd7)
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd9 pd6 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd10 pd7 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd12 pd13 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd12 pd14 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd13 pd15 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd14 pd15 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd16 pd18 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd17 pd19 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd18 pd19 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd22 pd23 "")
  (setq cside (ssadd (entlast) cside))
 	(command "line" pd24 pd25 "")
  (setq cside (ssadd (entlast) cside))
 	(command "trim" "o" "q" "" pd3 pd4 pd5 pd8 pd16 pd17 "")
  (setq cside (ssadd (entlast) cside))
 	(command "filletrad" (nth 8 other)) 
 	(command "fillet" "trim" "no" pd26 pd27)
  (setq cside (ssadd (entlast) cside))
 	(command "fillet" "trim" "no" pd28 pd29)
  (setq cside (ssadd (entlast) cside))
 	(command "zoom" "w" pzs1 pzs2)
 	(command "trim" "o" "q" "" pd30 pd31 "")
  (setq cside (ssadd (entlast) cside))
 	(command "zoom" "p")
  (command "line" pd37 pd36 "")
  (setq cside (ssadd (entlast) cside))
  (command "line" pd41 pd40 "")
  (setq cside (ssadd (entlast) cside))
  (command "line" pd36 pd40 "")
  (setq cside (ssadd (entlast) cside))
  (command "filletrad" (nth 8 other)) 
 	(command "fillet" "trim" "T" pd35 pd38)
  (setq cside (ssadd (entlast) cside))
  (command "fillet" "trim" "T" pd44 pd34)
  (setq cside (ssadd (entlast) cside))
  (command "trim" "o" "q" "" pd9 pd10 pd42 "")
  (setq cside (ssadd (entlast) cside))
  (command "line" pd43 pd45 "") 
  (setq cside (ssadd (entlast) cside))
  (command "layer" "set" layer_thin "")
  (command "line" pd27 pd32 "")
  (setq cside (ssadd (entlast) cside))
  (command "line" pd28 pd33 "")
  (setq cside (ssadd (entlast) cside))
  (command "trim" "o" "q" "" pd32 pd33 "")
  (setq cside (ssadd (entlast) cside))
  (command "layer" "set" layer_sup "")
  (command "ltscale" "0.6")
  (command "line" pd34 pd35 "")
  (setq cside (ssadd (entlast) cside))
  (command "line" pd18 pd35 "")
  (setq cside (ssadd (entlast) cside))
  (command "line" pd19 pd34 "")
  (setq cside (ssadd (entlast) cside))
  
  (if (= (substr (nth 5 plot_data) 1 1) "y")
    (progn
      (command "layer" "set" layer_dims "")
      (command "dimtoh" "on")
      (command "dimscale" (* (nth 0 other) 0.04))
      (command "dimlinear" pd43 pd45 pz7)
      (setq cside (ssadd (entlast) cside))
      (command "zoom" "w" pd18 pd27)
      (command "dimradius" pz2 pz3)
      (setq cside (ssadd (entlast) cside))
      (command "zoom" "p")
      (command "zoom" "w" pzb1 pzb2)
      (command "dimradius" pz5 pz6)
      (setq cside (ssadd (entlast) cside))
      (command "zoom" "p")
      (command "dimlinear" pd7 pd34 pz8)
      (setq cside (ssadd (entlast) cside))
      (command "dimlinear" pd8 pd7 pz9)
      (setq cside (ssadd (entlast) cside))
      (command "dimlinear" pd15 pd14 pz10)
      (setq cside (ssadd (entlast) cside))
      (command "dimlinear" pd19 pd13 pz11)
      (setq cside (ssadd (entlast) cside))
      (command "dimlinear" pd7 pd13 pz12)
      (setq cside (ssadd (entlast) cside))
      (command "dimlinear" pd7 pd6 pz13)
      (setq cside (ssadd (entlast) cside))
      (command "dimangular" pzd1 pzd2 pz14)
      (setq cside (ssadd (entlast) cside))
    )
  )
  
  (if (/= (nth 4 pd) 0.0)
    (command "rotate" cside "" pt1 (nth 4 plot_data))
  )

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

























