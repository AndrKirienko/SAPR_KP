; ������ ��������� ���������� �����������
(setq ui_err "\n��������� ����!"
; ������ �������� �������� (Yes/No)
yn_list (list "y" "yes" "n" "no")
)
(defun user_input (/

d_other ; ������ d ����� � ������ �����������
L_all ; �������� ������� �����
L_unrec ; �������������� �������� ������� �����
d_Lb ; (������ (��_���� ����_���� ����_�����)...)
d_all ; �������� ������� �����
d_unrec ; �������������� �������� ������� �����
base_point ; ������ �����
view ; ��� �����
d ; ������ �����
views ; ������ �������� ������� ����
ui_base ; ������ ��������� ���������� �����������
ui_view
ui_dia
ui_unrec
ui_len
ui_ang
ui_dim
ui_rout
L_d ; ������ ������� L ��� ��������� d
L_ds ; ������� ������� ������ L_d
a_rot ; ��� ���������
putdim ; ����� ����������� ������
req_par ; ��������� ��������� (��� ��� ����)
aux_par ; �������� ��������� (��� ��������� ����)
Li ; �������� ����� ��� ���������� �����
lims ; ������ ������
; (������ b � ��������� ������� L)
other ; ������ ��������� �������� ����� �� d
)
; d S Pb Ps k dp R
(setq d_other (list
'( 6.0 10.0 1.00 nil 4.0 4.0 0.25)
'( 8.0 13.0 1.25 1.00 5.3 5.5 0.40)
'(10.0 16.0 1.50 1.25 6.4 7.0 0.40)
'(12.0 18.0 1.75 1.25 7.5 8.5 0.60)
'(14.0 21.0 2.00 1.50 8.8 10.0 0.60)
'(16.0 24.0 2.00 1.50 10.0 12.0 0.60)
'(18.0 27.0 2.50 1.50 12.0 13.0 0.60)
'(20.0 30.0 2.50 1.50 12.5 15.0 0.80)
'(22.0 34.0 2.50 1.50 14.0 17.0 0.80)
'(24.0 36.0 3.00 2.00 15.0 18.0 0.80)
'(27.0 41.0 3.00 2.00 17.0 21.0 1.00)
'(30.0 46.0 3.50 2.00 18.7 23.0 1.00)
'(36.0 55.0 4.00 3.00 22.5 28.0 1.00)
'(42.0 65.0 4.50 3.00 26.0 32.0 1.20)
'(48.0 75.0 5.00 3.00 30.0 38.0 1.60))
L_all (list
8.0 10.0 12.0 14.0 16.0 18.0 20.0 22.0
25.0 28.0 30.0 32.0 35.0 38.0 40.0 45.0
50.0 55.0 60.0 65.0 70.0 75.0 80.0 85.0
90.0 95.0 100.0 105.0 110.0 115.0 120.0 125.0
130.0 140.0 150.0 160.0 170.0 180.0 190.0 200.0
220.0 240.0 260.0 280.0 300.0)
L_unrec (list
18.0 22.0 28.0 32.0 38.0
85.0 95.0 105.0 115.0 125.0)
; ���� ������� ����� = 0.0
; �� ������� ����� = L, ��� ����
d_Lb (list
'( 6.0 ( 8.0 20.0 0.0) ( 22.0 90.0 18.0))
'( 8.0 ( 8.0 25.0 0.0) ( 28.0 100.0 22.0))
'(10.0 ( 10.0 30.0 0.0) ( 32.0 125.0 26.0)
(130.0 200.0 32.0))
'(12.0 ( 14.0 32.0 0.0) ( 35.0 125.0 30.0)
(130.0 200.0 36.0) (220.0 260.0 49.0))
'(14.0 ( 16.0 38.0 0.0) ( 40.0 125.0 34.0)
(130.0 200.0 40.0) (220.0 300.0 57.0))
'(16.0 ( 18.0 40.0 0.0) ( 45.0 125.0 38.0)
(130.0 200.0 44.0) (220.0 300.0 57.0))
'(18.0 ( 20.0 45.0 0.0) ( 50.0 125.0 42.0)
(130.0 200.0 48.0) (220.0 300.0 61.0))
'(20.0 ( 25.0 50.0 0.0) ( 55.0 125.0 46.0)
(130.0 200.0 52.0) (220.0 300.0 65.0))
'(22.0 ( 28.0 55.0 0.0) ( 60.0 125.0 50.0)
(130.0 200.0 56.0) (220.0 300.0 69.0))
'(24.0 ( 32.0 60.0 0.0) ( 65.0 125.0 54.0)
(130.0 200.0 60.0) (220.0 300.0 73.0))
'(27.0 ( 35.0 65.0 0.0) ( 70.0 125.0 60.0)
(130.0 200.0 66.0) (220.0 300.0 79.0))
'(30.0 ( 40.0 70.0 0.0) ( 75.0 125.0 66.0)
(130.0 200.0 72.0) (220.0 300.0 85.0))
'(36.0 ( 50.0 85.0 0.0) ( 90.0 125.0 78.0)
(130.0 200.0 84.0) (220.0 300.0 97.0))
'(42.0 ( 55.0 100.0 0.0) (105.0 125.0 90.0)
(130.0 200.0 96.0) (220.0 300.0 109.0))
'(48.0 ( 70.0 110.0 0.0) (115.0 125.0 102.0)
(130.0 200.0 108.0) (220.0 300.0 121.0))
)
d_all (list
6.0 8.0 10.0 12.0 14.0 16.0 18.0 20.0 22.0
24.0 27.0 30.0 36.0 42.0 48.0)
d_unrec (list 14.0 18.0 22.0 27.0)
base_point (list 0.0 0.0)
view "M"
d (caar d_Lb)
views (list "m" "main" "s" "side")
ui_base "\n������� �����: "
ui_view "\n��� [Main (�������) / Side (�����)]: "
ui_dia "\n������� ������: "
ui_unrec "\n�������� �� �������������!"
ui_len "\n����� �����"
ui_ang "\n���� ��������, �������: "
ui_dim "\n������������� (Yes/No): "
ui_rout "\n���� ������ [Normal (����������)/ Short
(��������)]: "
L_d nil
L_ds ""
a_rot 0.0
putdim "y"
req_par nil
aux_par nil
runouts (list "n" "normal" "s" "short")
runout "n"
)
;----------------------------------------------------
; ������ �����
(setq base_point (getpoint ui_base))
; ��� (� ����������� �� �������� �������)
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
; �������� ��������� (��� ��������� ����)
; ������� �����
(if (or (= view "m") (= view "main"))
(progn
(setq lims (cdr (assoc d d_Lb)))
; ��������� ������ �� ��������� �������
; ���������� ������� L ��� ��������� �������� d
(foreach Li L_all
(if (and (>= Li (caar lims))
(<= Li (cadr (last lims))))
(progn
(setq L_d (append L_d (list Li)))
(setq L_ds (strcat L_ds (rtos Li 2 2) ","))
)
)
)
; ������� ����� (������� ������ ���������� �������)
(setq L (getreal
(strcat ui_len
" <"

(substr L_ds 1 (- (strlen L_ds) 1))

">: ")))
(while (= (member L L_d) nil)
(prompt ui_err)
(setq L (getreal (strcat ui_len ": ")))
)
(if (/= (member L L_unrec) nil)
(prompt ui_unrec)
)
; ���������� b � ����, ���������� ������� d_Lb
(foreach Li lims
(if (and (>= L (car Li)) (<= L (cadr Li)))
(setq b (caddr Li))
)
)
; ������� ������� ��������� ���� (b=0)
(if (zerop b)
(setq b L)
)
; ����� �� ���������� �� �������� ���
(setq runout (strcase (getstring ui_rout) T))
(while (= (member runout runouts) nil)
(prompt ui_err)
(setq runout (strcase (getstring ui_rout) T))
)
)
)
; ������ ���������� ��������� ��������� ����
(setq other (cdr (assoc d d_other)))
; ��� ���������
(setq a_rot (getreal ui_ang))
(while (not (numberp a_rot))
(prompt ui_err)
(setq a_rot (getreal ui_ang))
)
; ����������� ������
(setq putdim (strcase (getstring ui_dim) T))
(while (= (member putdim yn_list) nil)
(prompt ui_err)
(setq putdim (strcase (getstring ui_dim) T))
)
; ��������� ������ ����� �� �������� ������� ����
; req_par
; base-x base-y view S a_rot putdim
; aux_par
; d L b Pb Ps k dp R runout
(setq req_par (list (car base_point)
(cadr base_point)

view
(car other)
a_rot
putdim))
(if (or (= view "m") (= view "main"))
(setq req_par (append req_par
(list d L b)
(cdr other)
(list runout))

)
)
; append ������� ������ �������� �����
; � ������� ���� ����� (������� ���������� �����)
(append req_par))
(defun olayer (lcol ltyp lwei ui_str def_lname)
(setq lname (getstring (strcat ui_str
" <"
def_lname
">: "))

)
(if (= lname "")
(setq lname def_lname)
)
(command "layer" "new" lname
"color" lcol lname
"ltype" ltyp lname
"lweight" lwei lname "")

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
(setq ui_lb "\n������� ��� ���� �������� �����"
ui_lax "\n������� ��� ���� ������ �����"
ui_ltb "\n������� ��� ���� ������ �����"
ui_ldm "\n������� ��� ���� ��������� �����")
(setq layer_base
(olayer "7" "continuous" "0.30" ui_lb "base")
layer_axial
(olayer "9" "center" "0.15" ui_lax "axial")
layer_thin
(olayer "7" "continuous" "0.15" ui_ltb "tbase")
layer_dims
(olayer "9" "continuous" "0.15" ui_ldm "dim"))
)
(defun plot_side (pd / s2 e2 d_big
pt1

pa1 pa2 pa3 pa4
pd1 pd2 pd3 pd4 pd5 pd5 pd6 pd7 pd8

pz1 pz2)
(setq pt1 (list (car pd) (cadr pd))
s2 (/ (nth 3 pd) 2.0)
e2 (/ (nth 3 pd) (sqrt 3))
pa1 (list (car pd) (- (cadr pd) e2 5.0))
pa2 (list (car pd) (+ (cadr pd) e2 5.0))
pa3 (list (+ (car pd) s2 5.0) (cadr pd))
pa4 (list (- (car pd) s2 5.0) (cadr pd))
pd1 (list (car pd) (- (cadr pd) e2 10.0))
pd2 (polar pt1 (/ (* pi 7.0) 6.0) e2)
pd3 (polar pt1 (/ (- pi) 6.0) e2)
pd4 (list (+ (car pd) s2 10.0) (cadr pd))
pd5 (list (car pd) (- (cadr pd) e2))
pd6 (list (car pd) (+ (cadr pd) e2))
d_big (* (nth 3 pd) 0.95)
pd7 (polar pt1 (/ (* pi 2.0) 3.0) (* d_big 0.5))
pd8 (polar pt1 (/ (* pi 2.0) 3.0) (* d_big 0.7))
pz1 (list (- (car pd) s2 10.0) (- (cadr pd) e2 15.0))
pz2 (list (+ (car pd) s2 10.0) (+ (cadr pd) e2 15.0))
)
(setq cside (ssadd))
(command "zoom" "window" pz1 pz2)
(command "layer" "set" layer_axial "")
(command "line" pa1 pa2 "")
(setq cside (ssadd (entlast) cside))
(command "line" pa3 pa4 "")
(setq cside (ssadd (entlast) cside))
(command "layer" "set" layer_base "")
(command "circle" pt1 (/ d_big 2.0))
(setq cside (ssadd (entlast) cside))
(command "polygon" 6 pt1 "C" s2)
(setq cside (ssadd (entlast) cside))
(command "rotate" (entlast) "" pt1 30)
(if (= (substr (nth 5 pd) 1 1) "y")
(progn
(command "layer" "set" layer_dims "")
(command "dimlinear" "end" pd2 "end" pd3 pd1)
(setq cside (ssadd (entlast) cside))
(command "dimlinear" "end" pd5 "end" pd6 pd4)
(setq cside (ssadd (entlast) cside))
(command "zoom" "Extents")
(command "dimdiameter" "nea" pd7 pd8)
(setq cside (ssadd (entlast) cside))
)
)
(if (/= (nth 4 pd) 0.0)
(command "rotate" cside "" pt1 (nth 4 pd)))
)
(defun plot_main (pd)
(print "������� �����������")
)
(defun GOST7798-70 ()
(tune_env)
; ��������� ������ ���������� �� ��� ��������� ������
(setvar "cmdecho" 0)
(setq plot_data (user_input))
(if (= (substr (nth 2 plot_data) 1 1) "s")
; ��� �����
(plot_side plot_data)
; �������� ���
(plot_main plot_data)
)
(setvar "cmdecho" 1)
(setvar "lwdisplay" 1)
)