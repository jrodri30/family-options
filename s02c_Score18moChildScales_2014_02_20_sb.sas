/**************************************************************//*

Program:
Title: Score child scales
Programmer: Scott Brown
Date Created: 02/12/2014
Last Update: 02/12/2014

Input files: 1) fam18m.s02_18mo_vand_140211
Output files: 1) fam18m.s02_18mo_vand_140211_scr

Purpose:
-Score the scales included in the 18 month dataset -- SDQ and CHAOS
-Some initial prep for converting dataset into a focal-child level dataset

*//**************************************************************/

*set file directory name;
LIBNAME fam18m "E:\Family Options\Data\02_18MonthData";
%LET expdir="E:\Family Options\Data\02_18MonthData";

OPTIONS FMTSEARCH=(fam18m) NOFMTERR;



*add formats for scored variables;
PROC FORMAT;
VALUE sdq_catf
	0 = 'Normal'
	1 = 'Borderline'
	2 = 'Abnormal';
RUN;



%MACRO FO18score;
DATA fam18m.s02_18mo_vand_140211_scr;
	SET fam18m.s02_18mo_vand_140211;

*convert focal child ages from character to numeric
  and name in way can use in loops;
fc_age_1=fca_age*1;
fc_age_2=fcb_age*1;
fc_age_3=fcc_age*1;

*Begin focal child loop (3 focal child slots);
%DO zz=1 %TO 3;


/****** SDQ Scoring ******/
*Score each subscale and total score (with categorical score too)
regular is Not true=0, somewhat true=1, certainly true=2
reverse code (rc) is NT=2, ST=1, CT=2;

*F21 - child age 3, F21_1_A_1--F21_1_Y_1 / 2 / 3;
*F22 - child age 4-10, F22_1_A_1--F22_1_Y_1 / 2 / 3;
*F23 - child age 11-17, F23_1_A_1--F22_1_y_1 / 2/ 3;

	*Emotional Symptoms;
	IF F21_1_C_&zz.=1 THEN score_F21_1_C_&zz.=0; ELSE IF F21_1_C_&zz.=2 THEN score_F21_1_C_&zz.=1; ELSE IF F21_1_C_&zz.=3 THEN score_F21_1_C_&zz.=2;
	IF F21_1_H_&zz.=1 THEN score_F21_1_H_&zz.=0; ELSE IF F21_1_H_&zz.=2 THEN score_F21_1_H_&zz.=1; ELSE IF F21_1_H_&zz.=3 THEN score_F21_1_H_&zz.=2;
	IF F21_2_M_&zz.=1 THEN score_F21_2_M_&zz.=0; ELSE IF F21_2_M_&zz.=2 THEN score_F21_2_M_&zz.=1; ELSE IF F21_2_M_&zz.=3 THEN score_F21_2_M_&zz.=2;
	IF F21_2_P_&zz.=1 THEN score_F21_2_P_&zz.=0; ELSE IF F21_2_P_&zz.=2 THEN score_F21_2_P_&zz.=1; ELSE IF F21_2_P_&zz.=3 THEN score_F21_2_P_&zz.=2;
	IF F21_2_X_&zz.=1 THEN score_F21_2_X_&zz.=0; ELSE IF F21_2_X_&zz.=2 THEN score_F21_2_X_&zz.=1; ELSE IF F21_2_X_&zz.=3 THEN score_F21_2_X_&zz.=2;

	IF F22_1_C_&zz.=1 THEN score_F22_1_C_&zz.=0; ELSE IF F22_1_C_&zz.=2 THEN score_F22_1_C_&zz.=1; ELSE IF F22_1_C_&zz.=3 THEN score_F22_1_C_&zz.=2;
	IF F22_1_H_&zz.=1 THEN score_F22_1_H_&zz.=0; ELSE IF F22_1_H_&zz.=2 THEN score_F22_1_H_&zz.=1; ELSE IF F22_1_H_&zz.=3 THEN score_F22_1_H_&zz.=2;
	IF F22_2_M_&zz.=1 THEN score_F22_2_M_&zz.=0; ELSE IF F22_2_M_&zz.=2 THEN score_F22_2_M_&zz.=1; ELSE IF F22_2_M_&zz.=3 THEN score_F22_2_M_&zz.=2;
	IF F22_2_P_&zz.=1 THEN score_F22_2_P_&zz.=0; ELSE IF F22_2_P_&zz.=2 THEN score_F22_2_P_&zz.=1; ELSE IF F22_2_P_&zz.=3 THEN score_F22_2_P_&zz.=2;
	IF F22_2_X_&zz.=1 THEN score_F22_2_X_&zz.=0; ELSE IF F22_2_X_&zz.=2 THEN score_F22_2_X_&zz.=1; ELSE IF F22_2_X_&zz.=3 THEN score_F22_2_X_&zz.=2;

	IF F23_1_C_&zz.=1 THEN score_F23_1_C_&zz.=0; ELSE IF F23_1_C_&zz.=2 THEN score_F23_1_C_&zz.=1; ELSE IF F23_1_C_&zz.=3 THEN score_F23_1_C_&zz.=2;
	IF F23_1_H_&zz.=1 THEN score_F23_1_H_&zz.=0; ELSE IF F23_1_H_&zz.=2 THEN score_F23_1_H_&zz.=1; ELSE IF F23_1_H_&zz.=3 THEN score_F23_1_H_&zz.=2;
	IF F23_2_M_&zz.=1 THEN score_F23_2_M_&zz.=0; ELSE IF F23_2_M_&zz.=2 THEN score_F23_2_M_&zz.=1; ELSE IF F23_2_M_&zz.=3 THEN score_F23_2_M_&zz.=2;
	IF F23_2_P_&zz.=1 THEN score_F23_2_P_&zz.=0; ELSE IF F23_2_P_&zz.=2 THEN score_F23_2_P_&zz.=1; ELSE IF F23_2_P_&zz.=3 THEN score_F23_2_P_&zz.=2;
	IF F23_2_X_&zz.=1 THEN score_F23_2_X_&zz.=0; ELSE IF F23_2_X_&zz.=2 THEN score_F23_2_X_&zz.=1; ELSE IF F23_2_X_&zz.=3 THEN score_F23_2_X_&zz.=2;

	*Conduct problems;
	IF F21_1_E_&zz.=1 THEN score_F21_1_E_&zz.=0; ELSE IF F21_1_E_&zz.=2 THEN score_F21_1_E_&zz.=1; ELSE IF F21_1_E_&zz.=3 THEN score_F21_1_E_&zz.=2;
	*rc; IF F21_1_G_&zz.=3 THEN score_F21_1_G_&zz.=0; ELSE IF F21_1_G_&zz.=2 THEN score_F21_1_G_&zz.=1; ELSE IF F21_1_G_&zz.=1 THEN score_F21_1_G_&zz.=0;
	IF F21_1_L_&zz.=1 THEN score_F21_1_L_&zz.=0; ELSE IF F21_1_L_&zz.=2 THEN score_F21_1_L_&zz.=1; ELSE IF F21_1_L_&zz.=3 THEN score_F21_1_L_&zz.=2;
	IF F21_2_R_&zz.=1 THEN score_F21_2_R_&zz.=0; ELSE IF F21_2_R_&zz.=2 THEN score_F21_2_R_&zz.=1; ELSE IF F21_2_R_&zz.=3 THEN score_F21_2_R_&zz.=2;
	IF F21_2_V_&zz.=1 THEN score_F21_2_V_&zz.=0; ELSE IF F21_2_V_&zz.=2 THEN score_F21_2_V_&zz.=1; ELSE IF F21_2_V_&zz.=3 THEN score_F21_2_V_&zz.=2;

	IF F22_1_E_&zz.=1 THEN score_F22_1_E_&zz.=0; ELSE IF F22_1_E_&zz.=2 THEN score_F22_1_E_&zz.=1; ELSE IF F22_1_E_&zz.=3 THEN score_F22_1_E_&zz.=2;
	*rc; IF F22_1_G_&zz.=3 THEN score_F22_1_G_&zz.=0; ELSE IF F22_1_G_&zz.=2 THEN score_F22_1_G_&zz.=1; ELSE IF F22_1_G_&zz.=1 THEN score_F22_1_G_&zz.=0;
	IF F22_1_L_&zz.=1 THEN score_F22_1_L_&zz.=0; ELSE IF F22_1_L_&zz.=2 THEN score_F22_1_L_&zz.=1; ELSE IF F22_1_L_&zz.=3 THEN score_F22_1_L_&zz.=2;
	IF F22_2_R_&zz.=1 THEN score_F22_2_R_&zz.=0; ELSE IF F22_2_R_&zz.=2 THEN score_F22_2_R_&zz.=1; ELSE IF F22_2_R_&zz.=3 THEN score_F22_2_R_&zz.=2;
	IF F22_2_V_&zz.=1 THEN score_F22_2_V_&zz.=0; ELSE IF F22_2_V_&zz.=2 THEN score_F22_2_V_&zz.=1; ELSE IF F22_2_V_&zz.=3 THEN score_F22_2_V_&zz.=2;

	IF F23_1_E_&zz.=1 THEN score_F23_1_E_&zz.=0; ELSE IF F23_1_E_&zz.=2 THEN score_F23_1_E_&zz.=1; ELSE IF F23_1_E_&zz.=3 THEN score_F23_1_E_&zz.=2;
	*rc; IF F23_1_G_&zz.=3 THEN score_F23_1_G_&zz.=0; ELSE IF F23_1_G_&zz.=2 THEN score_F23_1_G_&zz.=1; ELSE IF F23_1_G_&zz.=1 THEN score_F23_1_G_&zz.=0;
	IF F23_1_L_&zz.=1 THEN score_F23_1_L_&zz.=0; ELSE IF F23_1_L_&zz.=2 THEN score_F23_1_L_&zz.=1; ELSE IF F23_1_L_&zz.=3 THEN score_F23_1_L_&zz.=2;
	IF F23_2_R_&zz.=1 THEN score_F23_2_R_&zz.=0; ELSE IF F23_2_R_&zz.=2 THEN score_F23_2_R_&zz.=1; ELSE IF F23_2_R_&zz.=3 THEN score_F23_2_R_&zz.=2;
	IF F23_2_V_&zz.=1 THEN score_F23_2_V_&zz.=0; ELSE IF F23_2_V_&zz.=2 THEN score_F23_2_V_&zz.=1; ELSE IF F23_2_V_&zz.=3 THEN score_F23_2_V_&zz.=2;

	*Hyperactivity;
	IF F21_1_B_&zz.=1 THEN score_F21_1_B_&zz.=0; ELSE IF F21_1_B_&zz.=2 THEN score_F21_1_B_&zz.=1; ELSE IF F21_1_B_&zz.=3 THEN score_F21_1_B_&zz.=2;	
	IF F21_1_J_&zz.=1 THEN score_F21_1_J_&zz.=0; ELSE IF F21_1_J_&zz.=2 THEN score_F21_1_J_&zz.=1; ELSE IF F21_1_J_&zz.=3 THEN score_F21_1_J_&zz.=2;
	IF F21_2_O_&zz.=1 THEN score_F21_2_O_&zz.=0; ELSE IF F21_2_O_&zz.=2 THEN score_F21_2_O_&zz.=1; ELSE IF F21_2_O_&zz.=3 THEN score_F21_2_O_&zz.=2;
	*rc; IF F21_2_U_&zz.=3 THEN score_F21_2_U_&zz.=0; ELSE IF F21_2_U_&zz.=2 THEN score_F21_2_U_&zz.=1; ELSE IF F21_2_U_&zz.=1 THEN score_F21_2_U_&zz.=0;
	*rc; IF F21_2_Y_&zz.=3 THEN score_F21_2_Y_&zz.=0; ELSE IF F21_2_Y_&zz.=2 THEN score_F21_2_Y_&zz.=1; ELSE IF F21_2_Y_&zz.=1 THEN score_F21_2_Y_&zz.=0;

	IF F22_1_B_&zz.=1 THEN score_F22_1_B_&zz.=0; ELSE IF F22_1_B_&zz.=2 THEN score_F22_1_B_&zz.=1; ELSE IF F22_1_B_&zz.=3 THEN score_F22_1_B_&zz.=2;	
	IF F22_1_J_&zz.=1 THEN score_F22_1_J_&zz.=0; ELSE IF F22_1_J_&zz.=2 THEN score_F22_1_J_&zz.=1; ELSE IF F22_1_J_&zz.=3 THEN score_F22_1_J_&zz.=2;
	IF F22_2_O_&zz.=1 THEN score_F22_2_O_&zz.=0; ELSE IF F22_2_O_&zz.=2 THEN score_F22_2_O_&zz.=1; ELSE IF F22_2_O_&zz.=3 THEN score_F22_2_O_&zz.=2;
	*rc; IF F22_2_U_&zz.=3 THEN score_F22_2_U_&zz.=0; ELSE IF F22_2_U_&zz.=2 THEN score_F22_2_U_&zz.=1; ELSE IF F22_2_U_&zz.=1 THEN score_F22_2_U_&zz.=0;
	*rc; IF F22_2_Y_&zz.=3 THEN score_F22_2_Y_&zz.=0; ELSE IF F22_2_Y_&zz.=2 THEN score_F22_2_Y_&zz.=1; ELSE IF F22_2_Y_&zz.=1 THEN score_F22_2_Y_&zz.=0;

	IF F23_1_B_&zz.=1 THEN score_F23_1_B_&zz.=0; ELSE IF F23_1_B_&zz.=2 THEN score_F23_1_B_&zz.=1; ELSE IF F23_1_B_&zz.=3 THEN score_F23_1_B_&zz.=2;	
	IF F23_1_J_&zz.=1 THEN score_F23_1_J_&zz.=0; ELSE IF F23_1_J_&zz.=2 THEN score_F23_1_J_&zz.=1; ELSE IF F23_1_J_&zz.=3 THEN score_F23_1_J_&zz.=2;
	IF F23_2_O_&zz.=1 THEN score_F23_2_O_&zz.=0; ELSE IF F23_2_O_&zz.=2 THEN score_F23_2_O_&zz.=1; ELSE IF F23_2_O_&zz.=3 THEN score_F23_2_O_&zz.=2;
	*rc; IF F23_2_U_&zz.=3 THEN score_F23_2_U_&zz.=0; ELSE IF F23_2_U_&zz.=2 THEN score_F23_2_U_&zz.=1; ELSE IF F23_2_U_&zz.=1 THEN score_F23_2_U_&zz.=0;
	*rc; IF F23_2_Y_&zz.=3 THEN score_F23_2_Y_&zz.=0; ELSE IF F23_2_Y_&zz.=2 THEN score_F23_2_Y_&zz.=1; ELSE IF F23_2_Y_&zz.=1 THEN score_F23_2_Y_&zz.=0;


	*Peer problems;
	IF F21_1_F_&zz.=1 THEN score_F21_1_F_&zz.=0; ELSE IF F21_1_F_&zz.=2 THEN score_F21_1_F_&zz.=1; ELSE IF F21_1_F_&zz.=3 THEN score_F21_1_F_&zz.=2;
	*rc; IF F21_1_K_&zz.=3 THEN score_F21_1_K_&zz.=0; ELSE IF F21_1_K_&zz.=2 THEN score_F21_1_K_&zz.=1; ELSE IF F21_1_K_&zz.=1 THEN score_F21_1_K_&zz.=0;
	*rc; IF F21_2_N_&zz.=3 THEN score_F21_2_N_&zz.=0; ELSE IF F21_2_N_&zz.=2 THEN score_F21_2_N_&zz.=1; ELSE IF F21_2_N_&zz.=1 THEN score_F21_2_N_&zz.=0;
	IF F21_2_S_&zz.=1 THEN score_F21_2_S_&zz.=0; ELSE IF F21_2_S_&zz.=2 THEN score_F21_2_S_&zz.=1; ELSE IF F21_2_S_&zz.=3 THEN score_F21_2_S_&zz.=2;
	IF F21_2_W_&zz.=1 THEN score_F21_2_W_&zz.=0; ELSE IF F21_2_W_&zz.=2 THEN score_F21_2_W_&zz.=1; ELSE IF F21_2_W_&zz.=3 THEN score_F21_2_W_&zz.=2;
		
	IF F22_1_F_&zz.=1 THEN score_F22_1_F_&zz.=0; ELSE IF F22_1_F_&zz.=2 THEN score_F22_1_F_&zz.=1; ELSE IF F22_1_F_&zz.=3 THEN score_F22_1_F_&zz.=2;
	*rc; IF F22_1_K_&zz.=3 THEN score_F22_1_K_&zz.=0; ELSE IF F22_1_K_&zz.=2 THEN score_F22_1_K_&zz.=1; ELSE IF F22_1_K_&zz.=1 THEN score_F22_1_K_&zz.=0;
	*rc; IF F22_2_N_&zz.=3 THEN score_F22_2_N_&zz.=0; ELSE IF F22_2_N_&zz.=2 THEN score_F22_2_N_&zz.=1; ELSE IF F22_2_N_&zz.=1 THEN score_F22_2_N_&zz.=0;
	IF F22_2_S_&zz.=1 THEN score_F22_2_S_&zz.=0; ELSE IF F22_2_S_&zz.=2 THEN score_F22_2_S_&zz.=1; ELSE IF F22_2_S_&zz.=3 THEN score_F22_2_S_&zz.=2;
	IF F22_2_W_&zz.=1 THEN score_F22_2_W_&zz.=0; ELSE IF F22_2_W_&zz.=2 THEN score_F22_2_W_&zz.=1; ELSE IF F22_2_W_&zz.=3 THEN score_F22_2_W_&zz.=2;

	IF F23_1_F_&zz.=1 THEN score_F23_1_F_&zz.=0; ELSE IF F23_1_F_&zz.=2 THEN score_F23_1_F_&zz.=1; ELSE IF F23_1_F_&zz.=3 THEN score_F23_1_F_&zz.=2;
	*rc; IF F23_1_K_&zz.=3 THEN score_F23_1_K_&zz.=0; ELSE IF F23_1_K_&zz.=2 THEN score_F23_1_K_&zz.=1; ELSE IF F23_1_K_&zz.=1 THEN score_F23_1_K_&zz.=0;
	*rc; IF F23_2_N_&zz.=3 THEN score_F23_2_N_&zz.=0; ELSE IF F23_2_N_&zz.=2 THEN score_F23_2_N_&zz.=1; ELSE IF F23_2_N_&zz.=1 THEN score_F23_2_N_&zz.=0;
	IF F23_2_S_&zz.=1 THEN score_F23_2_S_&zz.=0; ELSE IF F23_2_S_&zz.=2 THEN score_F23_2_S_&zz.=1; ELSE IF F23_2_S_&zz.=3 THEN score_F23_2_S_&zz.=2;
	IF F23_2_W_&zz.=1 THEN score_F23_2_W_&zz.=0; ELSE IF F23_2_W_&zz.=2 THEN score_F23_2_W_&zz.=1; ELSE IF F23_2_W_&zz.=3 THEN score_F23_2_W_&zz.=2;
	
	*Prosocial;
	IF F21_1_A_&zz.=1 THEN score_F21_1_A_&zz.=0; ELSE IF F21_1_A_&zz.=2 THEN score_F21_1_A_&zz.=1; ELSE IF F21_1_A_&zz.=3 THEN score_F21_1_A_&zz.=2;
	IF F21_1_D_&zz.=1 THEN score_F21_1_D_&zz.=0; ELSE IF F21_1_D_&zz.=2 THEN score_F21_1_D_&zz.=1; ELSE IF F21_1_D_&zz.=3 THEN score_F21_1_D_&zz.=2;
	IF F21_1_I_&zz.=1 THEN score_F21_1_I_&zz.=0; ELSE IF F21_1_I_&zz.=2 THEN score_F21_1_I_&zz.=1; ELSE IF F21_1_I_&zz.=3 THEN score_F21_1_I_&zz.=2;
	IF F21_2_Q_&zz.=1 THEN score_F21_2_Q_&zz.=0; ELSE IF F21_2_Q_&zz.=2 THEN score_F21_2_Q_&zz.=1; ELSE IF F21_2_Q_&zz.=3 THEN score_F21_2_Q_&zz.=2;
	IF F21_2_T_&zz.=1 THEN score_F21_2_T_&zz.=0; ELSE IF F21_2_T_&zz.=2 THEN score_F21_2_T_&zz.=1; ELSE IF F21_2_T_&zz.=3 THEN score_F21_2_T_&zz.=2;

	IF F22_1_A_&zz.=1 THEN score_F22_1_A_&zz.=0; ELSE IF F22_1_A_&zz.=2 THEN score_F22_1_A_&zz.=1; ELSE IF F22_1_A_&zz.=3 THEN score_F22_1_A_&zz.=2;
	IF F22_1_D_&zz.=1 THEN score_F22_1_D_&zz.=0; ELSE IF F22_1_D_&zz.=2 THEN score_F22_1_D_&zz.=1; ELSE IF F22_1_D_&zz.=3 THEN score_F22_1_D_&zz.=2;
	IF F22_1_I_&zz.=1 THEN score_F22_1_I_&zz.=0; ELSE IF F22_1_I_&zz.=2 THEN score_F22_1_I_&zz.=1; ELSE IF F22_1_I_&zz.=3 THEN score_F22_1_I_&zz.=2;
	IF F22_2_Q_&zz.=1 THEN score_F22_2_Q_&zz.=0; ELSE IF F22_2_Q_&zz.=2 THEN score_F22_2_Q_&zz.=1; ELSE IF F22_2_Q_&zz.=3 THEN score_F22_2_Q_&zz.=2;
	IF F22_2_T_&zz.=1 THEN score_F22_2_T_&zz.=0; ELSE IF F22_2_T_&zz.=2 THEN score_F22_2_T_&zz.=1; ELSE IF F22_2_T_&zz.=3 THEN score_F22_2_T_&zz.=2;

	IF F23_1_A_&zz.=1 THEN score_F23_1_A_&zz.=0; ELSE IF F23_1_A_&zz.=2 THEN score_F23_1_A_&zz.=1; ELSE IF F23_1_A_&zz.=3 THEN score_F23_1_A_&zz.=2;
	IF F23_1_D_&zz.=1 THEN score_F23_1_D_&zz.=0; ELSE IF F23_1_D_&zz.=2 THEN score_F23_1_D_&zz.=1; ELSE IF F23_1_D_&zz.=3 THEN score_F23_1_D_&zz.=2;
	IF F23_1_I_&zz.=1 THEN score_F23_1_I_&zz.=0; ELSE IF F23_1_I_&zz.=2 THEN score_F23_1_I_&zz.=1; ELSE IF F23_1_I_&zz.=3 THEN score_F23_1_I_&zz.=2;
	IF F23_2_Q_&zz.=1 THEN score_F23_2_Q_&zz.=0; ELSE IF F23_2_Q_&zz.=2 THEN score_F23_2_Q_&zz.=1; ELSE IF F23_2_Q_&zz.=3 THEN score_F23_2_Q_&zz.=2;
	IF F23_2_T_&zz.=1 THEN score_F23_2_T_&zz.=0; ELSE IF F23_2_T_&zz.=2 THEN score_F23_2_T_&zz.=1; ELSE IF F23_2_T_&zz.=3 THEN score_F23_2_T_&zz.=2;

	
	*Total scoring for sub-scales and overall scale -- conditional on age
		NOTE: use + instead of sum so that if there is a missing item, subscale total will be missing;
		*age 3 (36mo - 47mo), use F21;
	IF fc_age_&zz. in(36:47) THEN DO;
		sdq_emo_&zz.=score_F21_1_C_&zz.+score_F21_1_H_&zz.+score_F21_2_M_&zz.+score_F21_2_P_&zz.+score_F21_2_X_&zz.;
		sdq_conduct_&zz.=score_F21_1_E_&zz.+score_F21_1_G_&zz.+score_F21_1_L_&zz.+score_F21_2_R_&zz.+score_F21_2_V_&zz.;
		sdq_hyper_&zz.=score_F21_1_B_&zz.+score_F21_1_J_&zz.+score_F21_2_O_&zz.+score_F21_2_U_&zz.+score_F21_2_Y_&zz.;
		sdq_peer_&zz.=score_F21_1_F_&zz.+score_F21_1_K_&zz.+score_F21_2_N_&zz.+score_F21_2_S_&zz.+score_F21_2_W_&zz.;;
		sdq_prosoc_&zz.=score_F21_1_A_&zz.+score_F21_1_D_&zz.+score_F21_1_I_&zz.+score_F21_2_Q_&zz.+score_F21_2_T_&zz.;;
		END;

		*age 4-10 (48mo-131mo), use F22;
	ELSE IF fc_age_&zz. in(48:131) THEN DO;
		sdq_emo_&zz.=score_F22_1_C_&zz.+score_F22_1_H_&zz.+score_F22_2_M_&zz.+score_F22_2_P_&zz.+score_F22_2_X_&zz.;
		sdq_conduct_&zz.=score_F22_1_E_&zz.+score_F22_1_G_&zz.+score_F22_1_L_&zz.+score_F22_2_R_&zz.+score_F22_2_V_&zz.;
		sdq_hyper_&zz.=score_F22_1_B_&zz.+score_F22_1_J_&zz.+score_F22_2_O_&zz.+score_F22_2_U_&zz.+score_F22_2_Y_&zz.;
		sdq_peer_&zz.=score_F22_1_F_&zz.+score_F22_1_K_&zz.+score_F22_2_N_&zz.+score_F22_2_S_&zz.+score_F22_2_W_&zz.;;
		sdq_prosoc_&zz.=score_F22_1_A_&zz.+score_F22_1_D_&zz.+score_F22_1_I_&zz.+score_F22_2_Q_&zz.+score_F22_2_T_&zz.;;
		END;

		*age 11-17 (132mo-215mo), use F22;
	ELSE IF fc_age_&zz. in(132:215) THEN DO;
		sdq_emo_&zz.=score_F23_1_C_&zz.+score_F23_1_H_&zz.+score_F23_2_M_&zz.+score_F23_2_P_&zz.+score_F23_2_X_&zz.;
		sdq_conduct_&zz.=score_F23_1_E_&zz.+score_F23_1_G_&zz.+score_F23_1_L_&zz.+score_F23_2_R_&zz.+score_F23_2_V_&zz.;
		sdq_hyper_&zz.=score_F23_1_B_&zz.+score_F23_1_J_&zz.+score_F23_2_O_&zz.+score_F23_2_U_&zz.+score_F23_2_Y_&zz.;
		sdq_peer_&zz.=score_F23_1_F_&zz.+score_F23_1_K_&zz.+score_F23_2_N_&zz.+score_F23_2_S_&zz.+score_F23_2_W_&zz.;;
		sdq_prosoc_&zz.=score_F23_1_A_&zz.+score_F23_1_D_&zz.+score_F23_1_I_&zz.+score_F23_2_Q_&zz.+score_F23_2_T_&zz.;;
		END;

	*Individual item scores -- for psychometric scaling checking, only score if all not missing;
		IF NOT (score_F21_1_A_&zz.=. AND score_F22_1_A_&zz.=. AND score_F23_1_A_&zz.=.) THEN score_sdq_A_&zz.=sum(score_F21_1_A_&zz., score_F22_1_A_&zz., score_F23_1_A_&zz.);
		IF NOT (score_F21_1_B_&zz.=. AND score_F22_1_B_&zz.=. AND score_F23_1_B_&zz.=.) THEN score_sdq_B_&zz.=sum(score_F21_1_B_&zz., score_F22_1_B_&zz., score_F23_1_B_&zz.);
		IF NOT (score_F21_1_C_&zz.=. AND score_F22_1_C_&zz.=. AND score_F23_1_C_&zz.=.) THEN score_sdq_C_&zz.=sum(score_F21_1_C_&zz., score_F22_1_C_&zz., score_F23_1_C_&zz.);
		IF NOT (score_F21_1_D_&zz.=. AND score_F22_1_D_&zz.=. AND score_F23_1_D_&zz.=.) THEN score_sdq_D_&zz.=sum(score_F21_1_D_&zz., score_F22_1_D_&zz., score_F23_1_D_&zz.);
		IF NOT (score_F21_1_E_&zz.=. AND score_F22_1_E_&zz.=. AND score_F23_1_E_&zz.=.) THEN score_sdq_E_&zz.=sum(score_F21_1_E_&zz., score_F22_1_E_&zz., score_F23_1_E_&zz.);
		IF NOT (score_F21_1_F_&zz.=. AND score_F22_1_F_&zz.=. AND score_F23_1_F_&zz.=.) THEN score_sdq_F_&zz.=sum(score_F21_1_F_&zz., score_F22_1_F_&zz., score_F23_1_F_&zz.);
		IF NOT (score_F21_1_G_&zz.=. AND score_F22_1_G_&zz.=. AND score_F23_1_G_&zz.=.) THEN score_sdq_G_&zz.=sum(score_F21_1_G_&zz., score_F22_1_G_&zz., score_F23_1_G_&zz.);
		IF NOT (score_F21_1_H_&zz.=. AND score_F22_1_H_&zz.=. AND score_F23_1_H_&zz.=.) THEN score_sdq_H_&zz.=sum(score_F21_1_H_&zz., score_F22_1_H_&zz., score_F23_1_H_&zz.);
		IF NOT (score_F21_1_I_&zz.=. AND score_F22_1_I_&zz.=. AND score_F23_1_I_&zz.=.) THEN score_sdq_I_&zz.=sum(score_F21_1_I_&zz., score_F22_1_I_&zz., score_F23_1_I_&zz.);
		IF NOT (score_F21_1_J_&zz.=. AND score_F22_1_J_&zz.=. AND score_F23_1_J_&zz.=.) THEN score_sdq_J_&zz.=sum(score_F21_1_J_&zz., score_F22_1_J_&zz., score_F23_1_J_&zz.);
		IF NOT (score_F21_1_K_&zz.=. AND score_F22_1_K_&zz.=. AND score_F23_1_K_&zz.=.) THEN score_sdq_K_&zz.=sum(score_F21_1_K_&zz., score_F22_1_K_&zz., score_F23_1_K_&zz.);
		IF NOT (score_F21_1_L_&zz.=. AND score_F22_1_L_&zz.=. AND score_F23_1_L_&zz.=.) THEN score_sdq_L_&zz.=sum(score_F21_1_L_&zz., score_F22_1_L_&zz., score_F23_1_L_&zz.);
		IF NOT (score_F21_2_M_&zz.=. AND score_F22_2_M_&zz.=. AND score_F23_2_M_&zz.=.) THEN score_sdq_M_&zz.=sum(score_F21_2_M_&zz., score_F22_2_M_&zz., score_F23_2_M_&zz.);
		IF NOT (score_F21_2_N_&zz.=. AND score_F22_2_N_&zz.=. AND score_F23_2_N_&zz.=.) THEN score_sdq_N_&zz.=sum(score_F21_2_N_&zz., score_F22_2_N_&zz., score_F23_2_N_&zz.);
		IF NOT (score_F21_2_O_&zz.=. AND score_F22_2_O_&zz.=. AND score_F23_2_O_&zz.=.) THEN score_sdq_O_&zz.=sum(score_F21_2_O_&zz., score_F22_2_O_&zz., score_F23_2_O_&zz.);
		IF NOT (score_F21_2_P_&zz.=. AND score_F22_2_P_&zz.=. AND score_F23_2_P_&zz.=.) THEN score_sdq_P_&zz.=sum(score_F21_2_P_&zz., score_F22_2_P_&zz., score_F23_2_P_&zz.);
		IF NOT (score_F21_2_Q_&zz.=. AND score_F22_2_Q_&zz.=. AND score_F23_2_Q_&zz.=.) THEN score_sdq_Q_&zz.=sum(score_F21_2_Q_&zz., score_F22_2_Q_&zz., score_F23_2_Q_&zz.);
		IF NOT (score_F21_2_R_&zz.=. AND score_F22_2_R_&zz.=. AND score_F23_2_R_&zz.=.) THEN score_sdq_R_&zz.=sum(score_F21_2_R_&zz., score_F22_2_R_&zz., score_F23_2_R_&zz.);
		IF NOT (score_F21_2_S_&zz.=. AND score_F22_2_S_&zz.=. AND score_F23_2_S_&zz.=.) THEN score_sdq_S_&zz.=sum(score_F21_2_S_&zz., score_F22_2_S_&zz., score_F23_2_S_&zz.);
		IF NOT (score_F21_2_T_&zz.=. AND score_F22_2_T_&zz.=. AND score_F23_2_T_&zz.=.) THEN score_sdq_T_&zz.=sum(score_F21_2_T_&zz., score_F22_2_T_&zz., score_F23_2_T_&zz.);
		IF NOT (score_F21_2_U_&zz.=. AND score_F22_2_U_&zz.=. AND score_F23_2_U_&zz.=.) THEN score_sdq_U_&zz.=sum(score_F21_2_U_&zz., score_F22_2_U_&zz., score_F23_2_U_&zz.);
		IF NOT (score_F21_2_V_&zz.=. AND score_F22_2_V_&zz.=. AND score_F23_2_V_&zz.=.) THEN score_sdq_V_&zz.=sum(score_F21_2_V_&zz., score_F22_2_V_&zz., score_F23_2_V_&zz.);
		IF NOT (score_F21_2_W_&zz.=. AND score_F22_2_W_&zz.=. AND score_F23_2_W_&zz.=.) THEN score_sdq_W_&zz.=sum(score_F21_2_W_&zz., score_F22_2_W_&zz., score_F23_2_W_&zz.);
		IF NOT (score_F21_2_X_&zz.=. AND score_F22_2_X_&zz.=. AND score_F23_2_X_&zz.=.) THEN score_sdq_X_&zz.=sum(score_F21_2_X_&zz., score_F22_2_X_&zz., score_F23_2_X_&zz.);
		IF NOT (score_F21_2_Y_&zz.=. AND score_F22_2_Y_&zz.=. AND score_F23_2_Y_&zz.=.) THEN score_sdq_Y_&zz.=sum(score_F21_2_Y_&zz., score_F22_2_Y_&zz., score_F23_2_Y_&zz.);
	

	*Total scale scores and categorical scores by subsection;

	*Note -- total score does not include pro-social sub-scale (separate)
		Also, used + so that if a subscale score is missing, total score is missing;
	sdq_total_&zz.=sdq_emo_&zz. + sdq_conduct_&zz. + sdq_hyper_&zz. + sdq_peer_&zz.;

	SELECT (sdq_emo_&zz.);
		WHEN (0,1,2,3) sdq_emo_cat_&zz.=0;
		WHEN (4) sdq_emo_cat_&zz.=1;
		WHEN (5,6,7,8,9,10) sdq_emo_cat_&zz.=2;
		OTHERWISE;
	END;
		
	SELECT (sdq_conduct_&zz.);
		WHEN (0,1,2) sdq_conduct_cat_&zz.=0;
		WHEN (3) sdq_conduct_cat_&zz.=1;
		WHEN (4,5,6,7,8,9,10) sdq_conduct_cat_&zz.=2;
		OTHERWISE;
	END;
		
	SELECT (sdq_hyper_&zz.);
		WHEN (0,1,2,3,4,5) sdq_hyper_cat_&zz.=0;
		WHEN (6) sdq_hyper_cat_&zz.=1;
		WHEN (7,8,9,10) sdq_hyper_cat_&zz.=2;
		OTHERWISE;
	END;
	
	SELECT (sdq_peer_&zz.);
		WHEN (0,1,2) sdq_peer_cat_&zz.=0;
		WHEN (3) sdq_peer_cat_&zz.=1;
		WHEN (4,5,6,7,8,9,10) sdq_peer_cat_&zz.=2;
		OTHERWISE;
	END;
	
	SELECT (sdq_prosoc_&zz.);
		WHEN (6,7,8,9,10) sdq_prosoc_cat_&zz.=0;
		WHEN (5) sdq_prosoc_cat_&zz.=1;
		WHEN (0,1,2,3,4) sdq_prosoc_cat_&zz.=2;
		OTHERWISE;
	END;

	SELECT;
		WHEN (sdq_total_&zz. in (0:13)) sdq_total_cat_&zz.=0;
		WHEN (sdq_total_&zz. in (14:16)) sdq_total_cat_&zz.=1;
		WHEN (sdq_total_&zz. in (17:40)) sdq_total_cat_&zz.=2;
		OTHERWISE;
	END;
*End of SDQ scale scoring;







*Add formats and labels for FC variables;
LABEL
sdq_emo_&zz. = "Strengths and Difficulties: Emotional Symptoms, FC&zz." 
sdq_conduct_&zz. = "Strengths and Difficulties: Conduct Problems, FC&zz."
sdq_hyper_&zz. = "Strengths and Difficulties: Hyperactivity, FC&zz."
sdq_peer_&zz. = "Strengths and Difficulties: Peer Problems, FC&zz."
sdq_prosoc_&zz. = "Strengths and Difficulties: Prosocial, FC&zz."
sdq_total_&zz. = "Strengths and Difficulties: Total Score, FC&zz."

sdq_emo_cat_&zz. = "Strengths and Difficulties: Emotional Symptoms (categorical), FC&zz." 
sdq_conduct_cat_&zz. = "Strengths and Difficulties: Conduct Problems (categorical), FC&zz."
sdq_hyper_cat_&zz. = "Strengths and Difficulties: Hyperactivity (categorical), FC&zz."
sdq_peer_cat_&zz. = "Strengths and Difficulties: Peer Problems (categorical), FC&zz."
sdq_prosoc_cat_&zz. = "Strengths and Difficulties: Prosocial (categorical), FC&zz."
sdq_total_cat_&zz. = "Strengths and Difficulties: Total Score (categorical), FC&zz."
;

FORMAT
sdq_emo_cat_&zz. sdq_conduct_cat_&zz. sdq_hyper_cat_&zz. sdq_peer_cat_&zz. sdq_prosoc_cat_&zz. sdq_total_cat_&zz. sdq_catf.
;

*end focal child loop (loop three times for FC_A to FC_C);
%END;




/**********   CHAOS Scale   ***********/
*Question F48 -- F48_A--F48_N
	-Asked once per family, 1=True, 2=False
	-Scoring based on Matheny et al 1995 journal article
	-Two subscales -- physical and social microenvironment
	-Score by summing -- higher score is more chaotic, rc=reverse coded
	-Note!! we have one fewer item than their scale, dropped item 15
		'First thing in the day, we have a regular routine at home'
		;

*rc; IF F48_A=1 THEN score_F48_A=0; ELSE IF F48_A=2 THEN score_F48_A=1;
*rc;IF F48_B=1 THEN score_F48_B=0; ELSE IF F48_B=2 THEN score_F48_B=1;
IF F48_C=1 THEN score_F48_C=1; ELSE IF F48_C=2 THEN score_F48_C=0;
*rc;IF F48_D=1 THEN score_F48_D=0; ELSE IF F48_D=2 THEN score_F48_D=1;
IF F48_E=1 THEN score_F48_E=1; ELSE IF F48_E=2 THEN score_F48_E=0;
IF F48_F=1 THEN score_F48_F=1; ELSE IF F48_F=2 THEN score_F48_F=0;
*rc;IF F48_G=1 THEN score_F48_G=0; ELSE IF F48_G=2 THEN score_F48_G=1;
IF F48_H=1 THEN score_F48_H=1; ELSE IF F48_H=2 THEN score_F48_H=0;
IF F48_I=1 THEN score_F48_I=1; ELSE IF F48_I=2 THEN score_F48_I=0;
IF F48_J=1 THEN score_F48_J=1; ELSE IF F48_J=2 THEN score_F48_J=0;
IF F48_K=1 THEN score_F48_K=1; ELSE IF F48_K=2 THEN score_F48_K=0;
*rc;IF F48_L=1 THEN score_F48_L=0; ELSE IF F48_L=2 THEN score_F48_L=1;
IF F48_M=1 THEN score_F48_M=1; ELSE IF F48_M=2 THEN score_F48_M=0;
*rc;IF F48_N=1 THEN score_F48_N=0; ELSE IF F48_N=2 THEN score_F48_N=1;

*Total CHAOS score (used + so any missing mean missing score for scale);
chaos_total= score_F48_A + score_F48_B + score_F48_C + score_F48_D + score_F48_E 
			+score_F48_F + score_F48_G + score_F48_H + score_F48_I + score_F48_J 
			+score_F48_K + score_F48_L + score_F48_M + score_F48_N ;
LABEL
score_F48_A="Scale score for F48.A - There is very little commotion where we live. (rc)"
score_F48_B="Scale score for F48.B - We can usually find things when we need them. (rc)"
score_F48_C="Scale score for F48.C - We almost always seem to be rushed."
score_F48_D="Scale score for F48.D - We are usually able to 'stay on top of things.' (rc)"
score_F48_E="Scale score for F48.E - No matter how hard we try, we always seem to be running late"
score_F48_F="Scale score for F48.F - Itís a real 'zoo' in where we live"
score_F48_G="Scale score for F48.G - At home we can talk to each other without being interrupted. (rc)"
score_F48_H="Scale score for F48.H - There is often a fuss going on where we live."
score_F48_I="Scale score for F48.I - No matter what our family/household plans, it usually doesnít seem to work out."
score_F48_J="Scale score for F48.J - You canít hear yourself think where we live."
score_F48_K="Scale score for F48.K - I often get drawn into other peopleís arguments where I live."
score_F48_L="Scale score for F48.L - Where we live is a good place to relax. (rc)"
score_F48_M="Scale score for F48.M - The telephone takes up a lot of our time where we live."
score_F48_N="Scale score for F48.N - The atmosphere where we live is calm. (rc)"
chaos_total="CHAOS total scale score";
*End of CHAOS scale;

*Drop unneeded intermediate scoring variables;
DROP
score_F21:
score_F22:
score_F23:;

RUN;
%MEND;

%FO18score;



*Exploratory -- missing data + child screeners;
PROC PRINT DATA=fam18m.s02_18mo_vand_140211_scr ; 
	WHERE id_fam_vand=1021;
	VAR id_fam_vand mode iscomplete hhsize fm1wave--fm20person sitename
		samp_num1-samp_num11 relationship1-relationship11 gender1-gender11
		child_with1-child_with11 newborn1-newborn11 numchild 
		fc_count fc_status1-fc_status10 fca_age fc_age_1 fcb_age fc_age_2 fcc_age fc_age_3 
		sc1--sc7_D_10

		fc_age_m_1 fc_age_y_1 f12A1_1 f12B_1 f12c_1 f14_1 f15_1 f16_1 f17_1 f18_1
		fc_age_m_2 fc_age_y_2 f12A1_2 f12B_2 f12c_2 f14_2 f15_2 f16_2 f17_2 f18_2
		fc_age_m_3 fc_age_y_3 f12A1_3 f12B_3 f12c_3 f14_3 f15_3 f16_3 f17_3 f18_3;
RUN;

PROC FREQ DATA=fam18m.s02_18mo_vand_140211_scr;
	TABLES sc3_1-sc3_10 sc5_1-sc5_10;
RUN;
PROC FREQ DATA=fam18m.s02_18mo_vand_140211_scr;
	TABLES sc6_1-sc6_10 sc7a_1-sc7a_10 sc7b_1-sc7b_10 sc7c_1-sc7c_10 sc7d_1-sc7d_10;
RUN;



DATA screener_temp;
	SET fam18m.s02_18mo_vand_140211_scr;

	ARRAY FC_STATUSq (10) FC_STATUS1-FC_STATUS10;
	ARRAY newbornq (10) NEWBORN1-NEWBORN10;
	ARRAY FC_SelectStatusq (10) FC_SelectStatus1-FC_SelectStatus10;
	ARRAY SC3q (10) SC3_1-SC3_10;
	ARRAY SC5q (10) SC5_1-SC5_10;
	ARRAY  A18MOAGEq (10) A18MOAGE_1-A18MOAGE_10;
	ARRAY  B18MOAGEq (10) B18MOAGE_1-B18MOAGE_10;

DO i=1 TO 10;

	IF FC_STATUSq[i]='A' THEN FC_SelectStatusq[i]=1;

	ELSE IF FC_STATUSq[i]='B' THEN DO;
		IF SC5q[i] in(1,2) THEN FC_SelectStatusq[i]=2;
		ELSE IF SC5q[i] in(3,4) THEN FC_SelectStatusq[i]=3;
		ELSE IF SC5q[i] in(7,8) THEN FC_SelectStatusq[i]=4;
		END;
	ELSE IF FC_STATUSq[i]='C' THEN DO;
		IF SC5q[i] in(1,2) THEN FC_SelectStatusq[i]=5;
		ELSE IF SC5q[i] in(3,4) THEN FC_SelectStatusq[i]=6;
		ELSE IF SC5q[i] in(7,8) THEN FC_SelectStatusq[i]=7;
		END;

	ELSE IF FC_STATUSq[i]='D' THEN DO;
		IF A18MOAGEq[i]=0 or B18MOAGEq[i]=0 THEN FC_SelectStatusq[i]=21; /*Child too young*/
		/*ELSE IF A18MOAGEq[i] in(0,1) and B18MOAGEq[i]=. THEN FC_SelectStatusq[i]=x too young for A criteria and not considered for B slot*/
		ELSE IF A18MOAGEq[i]=4 or B18MOAGEq[i]=4 THEN FC_SelectStatusq[i]=22; /*Child too old*/
		ELSE IF SC3q[i]=5 OR SC5q[i]=5 THEN FC_SelectStatusq[i]=23; /*child deceased*/
		ELSE IF SC5q[i] in(3,4) THEN FC_SelectStatusq[i]=24;/*failed screener, with hh less than half time*/
		ELSE IF SC5q[i] in(7,8) THEN FC_SelectStatusq[i]=25; /*failed screener, DK/REF on with hh*/
		ELSE IF SC1=2 AND NEWBORNq[i] in(1,2) THEN FC_SelectStatusq[i]=26; /*unused newborn slot (no new births)*/
		ELSE IF SC5q[i]=. AND NEWBORNq[i]~=. THEN FC_SelectStatusq[i]=27; /*All focal children already selected, not screened*/
		ELSE IF SC5q[i]=. AND NEWBORNq[i]=. THEN FC_SelectStatusq[i]=.; /*Blank slot, could not be screened*/
		ELSE FC_SelectStatusq[i]=99; /*Other rejection code -- use to identify any other codes*/
		END;
	END;
RUN;


%MACRO screenerqs;
%DO j=1 % TO 10;
DATA screener_temp&j. (RENAME= 
   (FC_SelectStatus&j. = FC_SelectStatus 
	SAMP_NUM&j. = SAMP_NUM 
	RELATIONSHIP&j. = RELATIONSHIP 
	GENDER&j. = GENDER 
	CHILD_WITH&j. = CHILD_WITH 
	NEWBORN&j. = NEWBORN 
	FC_STATUS&j. = FC_STATUS 
	AAIM_&j. = AAIM 
	A18MOAGE_&j. = A18MOAGE 
	SC3_&j. = SC3 
	BAIM_&j. = BAIM 
	B18MOAGE_&j. = B18MOAGE 
	SC5_&j. = SC5 
	SC6_&j. = SC6 
	SC7_A_&j. = SC7_A 
	SC7_B_&j. = SC7_B 
	SC7_C_&j. = SC7_C 
	SC7_D_&j. = SC7_D ));

	SET screener_temp (KEEP=
	id_fam_vand 
	FC_SelectStatus&j.
	SAMP_NUM&j. RELATIONSHIP&j. GENDER&j. CHILD_WITH&j. NEWBORN&j. FC_STATUS&j. 
	NUMCHILD FC_COUNT SC1 SC1A 
	AAIM_&j. A18MOAGE_&j. SC3_&j. BAIM_&j. B18MOAGE_&j. SC5_&j. SC6_&j. SC7_A_&j. SC7_B_&j. SC7_C_&j. SC7_D_&j.);

	IF AAIM_&j.~=. THEN AIM=AAIM_&j.; ELSE IF BAIM_&j.~=. THEN AIM=BAIM_&j.;
	IF A18MOAGE_&j.~=. THEN CAT18MOAGE=A18MOAGE_&j.; ELSE IF B18MOAGE_&j.~=. THEN CAT18MOAGE=B18MOAGE_&j.;
	IF SC3_&j.~=. THEN LiveInHH=SC3_&j.; ELSE IF SC5_&j.~=. THEN LiveInHH=SC5_&j.;

RUN;
%END;
%MEND;

%screenerqs;


DATA fam18m.screener_all;
	SET screener_temp1-screener_temp10; 
	WHERE NEWBORN~=.;
RUN;


PROC FREQ DATA=fam18m.screener_all;
	TABLES 	FC_SelectStatus
	SAMP_NUM RELATIONSHIP GENDER CHILD_WITH NEWBORN FC_STATUS 
	NUMCHILD FC_COUNT SC1 SC1A SC3 SC5 LiveInHH SC6 SC7_A SC7_B SC7_C SC7_D
	A18MOAGE B18MOAGE CAT18MOAGE;
RUN;



