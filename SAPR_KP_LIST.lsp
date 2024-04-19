; setq - ������� ������������

; ������ ��������� ���������� �����������
(setq ui_err "\n�������� ��������!"
	; ������ �������� �������� (Yes/No)
	yn_list (list "y" "yes" "n" "no")
)

;-------------------------------------------------------

;���������� ������� ����ֲ�

;defun - ���������� ������� �������

(defun user_input (/

  d_other 	; ������ d ����� � ������ �����������
  L_all 	; �������� ������� �����
  L_unrec 	; �������������� �������� ������� �����
  d_Lb 		; (������ (��_���� ����_����))
  d_all 	; �������� ������� �����
 	  ;?d_unrec 	; �������������� �������� ������� �����
  base_point 	; ������ �����
  view 		; ��� �����
  d 		; ������ �����
  views		; ������ �������� ������� ����
  ui_base	; ������ ��������� ���������� �����������
  ui_view
  ui_dia
  ui_unrec
  ui_len
  ui_ang
  		ui_dim	; ?
  		ui_rout	; ?
  L_d 		; ������ ������� L ��� ��������� d
  L_ds 		; ������� ������� ������ L_d
  a_rot		; ��� ���������
  putdim	; ����� ����������� ������
  req_par 	; ��������� ��������� (��� ��� ����)
  aux_par 	; �������� ��������� (��� ��������� ����)
  Li 		; �������� ����� ��� ���������� �����
  lims 		; ������ ������
		; (������ b � ��������� ������� L)
  other		; ������ ��������� �������� ����� �� d
)

;-------------------------------------------------------

;���������� ������� ������� �������в�

; d - ������ ��������
;w - ������ ����
;h - ������� ����
;d1 - ������ �������
;b - ������� ��������
;D - ������ �������
;k - ������ �������
;f - ������ �����
;R - ����� �� ��������
;dp - ������ �������� ����� 



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
	
	; ���� ������� ����� = 0.0
	; �� ������� ����� = L, ��� ����

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

	; caar - ������ ������
	d (caar d_Lb)
	views (list "m" "main" "s" "side")
	ui_base "\n������� �����: "
	ui_view "\n��� [Main (�������) / Side (�����)]: "
	ui_dia "\n������� ������: "
	ui_unrec "\n�������� �� �������������!"
	ui_len "\n����� �����"
	ui_ang "\n���� ��������, �������: "
	ui_dim "\n������������� (Yes/No): "
	ui_rout "\n���� ������ [Normal (����������)/ Short (��������)]: "
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

;��������� ������� ²� �����������

; ������ �����
(setq base_point (getpoint ui_base))

; ��� (strcase - ����������� �������)
(setq view (strcase (getstring ui_view) T))

(while (= (member view views) nil)
	(prompt ui_err)
	(setq view (strcase (getstring ui_view) T))
)

; ������ �����
(setq d (getreal ui_dia))

(while (= (member d d_all) nil)
	(prompt ui_err)
	(setq d (getreal ui_dia))
)

(if (/= (member d d_unrec) nil)
	(prompt ui_unrec)
)

;-------------------------------------------------------	

;������������ ���������� �������� ����������

(defun olayer (
  lcol 		; ���� ����
  ltyp 		; ��� ��
  lwei 		; ������ ��
  ui_str	; �������� �����������
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
  (setq ui_lb "\������� ��'� ���� �������� ���"
	ui_lax "\������� ��'� ���� ������� ���"
	ui_ltb "\������� ��'� ���� ������ ���"
	ui_ldm "\������� ��'� ���� �������� ���")
  (setq layer_base
	(olayer "7" "continuous" "0.30" ui_lb "base")

	layer_axial
	(olayer "9" "center" "0.15" ui_lax "axial")

	layer_thin
	(olayer "7" "continuous" "0.15" ui_ltb "tbase")

	layer_dims
	(olayer "9" "continuous" "0.15" ui_ldm "dim"))
)
























