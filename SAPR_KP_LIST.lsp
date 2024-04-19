; setq - функц≥€ присвоюванн€

; р€дков≥ константи ≥нтерфейсу користувача
(setq ui_err "\nѕовтор≥ть введенн€!"
	; список можливих в≥дпов≥дей (Yes/No)
	yn_list (list "y" "yes" "n" "no")
)

;-------------------------------------------------------

;ќ√ќЋќЎ≈ЌЌя ¬Ћј—Ќ»’ ‘”Ќ ÷≤…

;defun - оголошенн€ власних функц≥й

(defun user_input (/

  d_other 	; звТ€зок d р≥зьби з ≥ншими параметрами
  L_all 	; значенн€ довжини болта
  L_unrec 	; нерекомендован≥ значенн€ довжини болта
  d_Lb 		; (д≥аметр (м≥н_довж макс_довж))
  d_all 	; значенн€ д≥аметра болта
 	  ;?d_unrec 	; нерекомендован≥ значенн€ д≥аметра болта
  base_point 	; базова точка
  view 		; вид детал≥
  d 		; д≥аметр болта
  views		; список можливих значень вид≥в
  ui_base	; р€дков≥ константи ≥нтерфейсу користувача
  ui_view
  ui_dia
  ui_unrec
  ui_len
  ui_ang
  		ui_dim	; ?
  		ui_rout	; ?
  L_d 		; список значень L дл€ введеного d
  L_ds 		; р€дкове поданн€ списку L_d
  a_rot		; кут обертанн€
  putdim	; режим простановки розм≥р≥в
  req_par 	; обовТ€зков≥ параметри (дл€ вс≥х вид≥в)
  aux_par 	; додатков≥ параметри (дл€ головного виду)
  Li 		; допом≥жна зм≥нна дл€ орган≥зац≥њ циклу
  lims 		; список списк≥в
		; (звТ€зок b з д≥апазоном значень L)
  other		; список параметр≥в залежних т≥льки в≥д d
)

;-------------------------------------------------------

;ќ√ќЋќЎ≈ЌЌя ¬Ћј—Ќ»’ «Ќј„≈Ќ№ ѕј–јћ≈“–≤¬

; d - д≥амерт р≥збленн€
;w - ширина шл≥цу
;h - глибина шл≥цу
;d1 - д≥амерт стрижн€
;b - довжина р≥збленн€
;D - дамерт головки
;k - висота головки
;f - висота сфери
;R - рад≥ус п≥д головкою
;dp - д≥амерт плоского кунц€ 



	;  d    w   h    d1  b   D   k    f    R  dp 
(setq d_other (list
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
	
	; €кщо довжина р≥зьби = 0.0
	; то довжина р≥зьби = L, без зб≥гу

	d_Lb (list
	'( 2.5 ( 6.0 18.0))
	'( 3.0 ( 6.0 60.0))
	'( 4.0 ( 8.0 60.0))
	'( 5.0 (12.0 80.0))
	'( 6.0 (12.0 80.0))
	'( 8.0 (22.0 80.0))
	'(10.0 (22.0 80.0))
	'(12.0 (28.0 80.0))
	)
	
	d_all (list
	2.5 3.0 4.0 5.0 6.0 8.0 10.0 12.0
	)

	base_point (list 0.0 0.0)

	view "M"

	; caar - голова списка
	d (caar d_Lb)
	views (list "m" "main" "s" "side")
	ui_base "\nЅазова€ точка: "
	ui_view "\n¬ид [Main (√лавный) / Side (—боку)]: "
	ui_dia "\nƒиаметр резьбы: "
	ui_unrec "\n«начение не рекомендуетс€!"
	ui_len "\nƒлина болта"
	ui_ang "\n”гол поворота, градусы: "
	ui_dim "\nќбразмеривать (Yes/No): "
	ui_rout "\n—бег резьбы [Normal (Ќормальный)/ Short ( ороткий)]: "
	L_d nil
	L_ds ""
	a_rot 0.0
	putdim "y"
	req_par nil
	aux_par nil
	runouts (list "n" "normal" "s" "short")
	runout "n"
)

;-------------------------------------------------------

;ќ“–»ћјЌЌя «Ќј„≈Ќ№ ¬≤ƒ  ќ–»—“”¬ј„ј

; базова точка
(setq base_point (getpoint ui_base))

; вид (strcase - приведенн€м рег≥стру)
(setq view (strcase (getstring ui_view) T))

(while (= (member view views) nil)
	(prompt ui_err)
	(setq view (strcase (getstring ui_view) T))
)

; д≥аметр р≥зьби
(setq d (getreal ui_dia))

(while (= (member d d_all) nil)
	(prompt ui_err)
	(setq d (getreal ui_dia))
)

(if (/= (member d d_unrec) nil)
	(prompt ui_unrec)
)

;-------------------------------------------------------	

;ЌјЋјЎ“”¬јЌЌя —≈–≈ƒќ¬»ўя ѕќЅ”ƒќ¬»  –≈—Ћ»Ќ» ј

(defun olayer (
  lcol 		; кол≥р шару
  ltyp 		; тип л≥н≥њ
  lwei 		; ширина л≥н≥њ
  ui_str	; значенн€ користувач€
  def_lname
  )

  (setq lname (getstring (strcat ui_str " <" def_lname ">: ")))

  (if (= lname "")
	(setq lname def_lname)
  )

  (command "layer" "new" lname
	   "color" lcol lname
	   "ltype" ltyp lname
	   "lweight" lwei lname ""
  )

  (eval lname)
)

(defun tune_env (/ ui_lb ui_lax ui_ltb ui_ldm)
  (command "snap" "off")
  (command "grid" "off")
  (setvar "osmode" 0)
  (setvar "dimtoh" 1)
  (setvar "dimexo" 0)
  (setvar "aperture" 5)
  (setvar "ltscale" 2)
  (setq ui_lb "\п¬вед≥ть ≥м'€ шару основних л≥н≥й"
	ui_lax "\п¬вед≥ть ≥м'€ шару осьових л≥н≥й"
	ui_ltb "\п¬вед≥ть ≥м'€ шару тонких л≥н≥й"
	ui_ldm "\п¬вед≥ть ≥м'€ шару розм≥рних л≥н≥й")
  (setq layer_base
	(olayer "7" "continuous" "0.30" ui_lb "base")

	layer_axial
	(olayer "9" "center" "0.15" ui_lax "axial")

	layer_thin
	(olayer "7" "continuous" "0.15" ui_ltb "tbase")

	layer_dims
	(olayer "9" "continuous" "0.15" ui_ldm "dim"))
)
























