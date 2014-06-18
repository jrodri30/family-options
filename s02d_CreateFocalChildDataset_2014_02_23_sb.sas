/**************************************************************//*

Program:
Title: Create focal child-level 18 month dataset
Programmer: Scott Brown
Date Created: 02/23/2014
Last Update: 04/16/2014

Input files: fam18m.s02_18mo_vand_140211_scored
Output files: 1)s02_18mo_vand_140211_child.sas7bdat 
			  2)s02_18mo_vand_140211_child.sav (SPSS dataset for Beth)

Purpose:
-Transform dataset from 1 row per family to 1 row per focal child

Sequence:
1) Identify meta-household roster information for each focal child
2) a. Create separate datasets for Section F corresponding to the sections for each focal child
		-Preserve family id so can link back up
        -create unique focal child ID
   b. Rename variables in each dataset to correspond to one standardized set (e.g. F48_1, F48_2, F48_3 -> F48)
   c. Stack the datasets
   d. Remove any empty slots

3) Drop those variable from the current family-level dataset
   Merge family-level dataset variables back in with the child-level dataset

4) Score other scales in 18 month dataset:
	Family routines, Challenging Parenting environment, Parenting Stressors, 
	HOME scale (observational and parent report data)

NOTE: Don't currently know how to extract focal child info from section D.



*//**************************************************************/

*set file directory name;
LIBNAME fam18m "E:\Family Options\Data\02_18MonthData";
%LET expdir="E:\Family Options\Data\02_18MonthData";

OPTIONS FMTSEARCH=(fam18m) NOFMTERR;

DATA focal_child1 (KEEP= id_fam_vand id_famfc1_vand
FCA_AGE
FC_A_ID
FC1_RELATIONSHIP
FC1_GENDER
FC1_CHILD_WITH
FC1_NEWBORN
FC1_IDn

FC1_SAMP_NUM 
FC1_RELATIONSHIP 
FC1_GENDER 
FC1_CHILD_WITH 
FC1_NEWBORN 
FC1_STATUS

FC1_AAIM 
FC1_A18MOAGE 
FC1_SC2
FC1_SC2REFDK_C7 
FC1_SC2REFDK_C8 
FC1_SC3 
FC1_BAIM 
FC1_B18MOAGE 
FC1_SC4 
FC1_SC4REFDK_C7 
FC1_SC4REFDK_C8 
FC1_SC5 
FC1_SC6 
FC1_SC7A 
FC1_SC7B 
FC1_SC7C 
FC1_SC7D 

FC1_AIM 
FC1_18MOAGE 
FC1_DOBStatus 
FC1_DOBStatusREFDK_C7 
FC1_DOBStatusREFDK_C8 
FC1_LiveInHH 
FC1_SelectStatus 

fc_age_1
FC_AGE_M_1
FC_AGE_Y_1
F6_1
F7M_1
F7Y_1
F8_1
F9_1
F10_1
F10A1_1
F11_1_1
F11_95_OTHER_1_1
F11B_1_1
F11C_1_1_1
F11C_2_1_1
F11C_3_1_1
F12A1_1
F12B_1
F12C_1
F13A1_1
F14_1
F15_1
F16_1
F17_1
F18_1
F18A_1
F18B_1
F18B_95_OTHER_1
F19_1
/*F20A1_1
F20A2_1
F20A_1*/
F21_1_A_1
F21_1_B_1
F21_1_C_1
F21_1_D_1
F21_1_E_1
F21_1_F_1
F21_1_G_1
F21_1_H_1
F21_1_I_1
F21_1_J_1
F21_1_K_1
F21_1_L_1
F21_2_M_1
F21_2_N_1
F21_2_O_1
F21_2_P_1
F21_2_Q_1
F21_2_R_1
F21_2_S_1
F21_2_T_1
F21_2_U_1
F21_2_V_1
F21_2_W_1
F21_2_X_1
F21_2_Y_1
F22_1_A_1
F22_1_B_1
F22_1_C_1
F22_1_D_1
F22_1_E_1
F22_1_F_1
F22_1_G_1
F22_1_H_1
F22_1_I_1
F22_1_J_1
F22_1_K_1
F22_1_L_1
F22_2_M_1
F22_2_N_1
F22_2_O_1
F22_2_P_1
F22_2_Q_1
F22_2_R_1
F22_2_S_1
F22_2_T_1
F22_2_U_1
F22_2_V_1
F22_2_W_1
F22_2_X_1
F22_2_Y_1
F23_1_A_1
F23_1_B_1
F23_1_C_1
F23_1_D_1
F23_1_E_1
F23_1_F_1
F23_1_G_1
F23_1_H_1
F23_1_I_1
F23_1_J_1
F23_1_K_1
F23_1_L_1
F23_2_M_1
F23_2_N_1
F23_2_O_1
F23_2_P_1
F23_2_Q_1
F23_2_R_1
F23_2_S_1
F23_2_T_1
F23_2_U_1
F23_2_V_1
F23_2_W_1
F23_2_X_1
F23_2_Y_1
F24_1
F25_1
F26_1_A_1
F26_1_B_1
F26_1_C_1
F26_1_D_1
F26_1_E_1
F26_2_F_1
F26_2_G_1
F26_2_H_1
F26_2_I_1
F26_2_J_1
F26_2_K_1
F27_1_1
F27_2_1
F27_3_1
F27_4_1
F28_1
F29_A_1
F29_B_1
F29_C_1
F29_D_1
F30_1
F31_1
F32_1
F32A_1
F36_1
F36A_1
F38_A_1
F38_B_1
F38_C_1
F38_D_1
F38_E_1
F38_F_1
F38_G_1
F38_H_1
F38_I_1
F38_J_1
F39_A_1
F39_B_1
F39_C_1
F39_D_1
F39_E_1
F39_F_1
F39_G_1
F39_H_1
F39_I_1
F39_J_1
F39_K_1
F40_1
F40A_1
F41_1
F42_1
F42A_1
F42B_1
F43_1
F43A_1
F44_1
F44B_1
F44C_1
F45_1
F45A_1
F45B_1
F45C_1
F46_1
F46A_1

sdq_total_1
sdq_emo_1
sdq_conduct_1
sdq_hyper_1
sdq_peer_1
sdq_total_cat_1
sdq_emo_cat_1
sdq_conduct_cat_1
sdq_hyper_cat_1
sdq_peer_cat_1
score_sdq_A_1
score_sdq_B_1
score_sdq_C_1
score_sdq_D_1
score_sdq_E_1
score_sdq_F_1
score_sdq_G_1
score_sdq_H_1
score_sdq_I_1
score_sdq_J_1
score_sdq_K_1
score_sdq_L_1
score_sdq_M_1
score_sdq_N_1
score_sdq_O_1
score_sdq_P_1
score_sdq_Q_1
score_sdq_R_1
score_sdq_S_1
score_sdq_T_1
score_sdq_U_1
score_sdq_V_1
score_sdq_W_1
score_sdq_X_1
score_sdq_Y_1
) 
focal_child2 (KEEP=
id_fam_vand id_famfc2_vand
FCB_AGE
FC_B_ID
FC2_RELATIONSHIP
FC2_GENDER
FC2_CHILD_WITH
FC2_NEWBORN
FC2_IDn

FC2_SAMP_NUM 
FC2_RELATIONSHIP 
FC2_GENDER 
FC2_CHILD_WITH 
FC2_NEWBORN 
FC2_STATUS

FC2_AAIM 
FC2_A18MOAGE 
FC2_SC2
FC2_SC2REFDK_C7 
FC2_SC2REFDK_C8 
FC2_SC3 
FC2_BAIM 
FC2_B18MOAGE 
FC2_SC4 
FC2_SC4REFDK_C7 
FC2_SC4REFDK_C8 
FC2_SC5 
FC2_SC6 
FC2_SC7A 
FC2_SC7B 
FC2_SC7C 
FC2_SC7D 

FC2_AIM 
FC2_18MOAGE 
FC2_DOBStatus 
FC2_DOBStatusREFDK_C7 
FC2_DOBStatusREFDK_C8 
FC2_LiveInHH 
FC2_SelectStatus 

fc_age_2 
FC_AGE_M_2 
FC_AGE_Y_2 
F6_2 
F7M_2 
F7Y_2 
F8_2 
F9_2 
F10_2 
F10A1_2 
F11_1_2 
F11_95_OTHER_1_2 
F11B_1_2 
F11C_1_1_2 
F11C_2_1_2 
F11C_3_1_2 
F12A1_2 
F12B_2 
F12C_2 
F13A1_2 
F14_2 
F15_2 
F16_2 
F17_2 
F18_2 
F18A_2 
F18B_2 
F18B_95_OTHER_2 
F19_2 
F20A1_2
F20A2_2
F20A_2
F21_1_A_2 
F21_1_B_2 
F21_1_C_2 
F21_1_D_2 
F21_1_E_2 
F21_1_F_2 
F21_1_G_2 
F21_1_H_2 
F21_1_I_2 
F21_1_J_2 
F21_1_K_2 
F21_1_L_2 
F21_2_M_2 
F21_2_N_2 
F21_2_O_2 
F21_2_P_2 
F21_2_Q_2 
F21_2_R_2 
F21_2_S_2 
F21_2_T_2 
F21_2_U_2 
F21_2_V_2 
F21_2_W_2 
F21_2_X_2 
F21_2_Y_2 
F22_1_A_2 
F22_1_B_2 
F22_1_C_2 
F22_1_D_2 
F22_1_E_2 
F22_1_F_2 
F22_1_G_2 
F22_1_H_2 
F22_1_I_2 
F22_1_J_2 
F22_1_K_2 
F22_1_L_2 
F22_2_M_2 
F22_2_N_2 
F22_2_O_2 
F22_2_P_2 
F22_2_Q_2 
F22_2_R_2 
F22_2_S_2 
F22_2_T_2 
F22_2_U_2 
F22_2_V_2 
F22_2_W_2 
F22_2_X_2 
F22_2_Y_2 
F23_1_A_2 
F23_1_B_2 
F23_1_C_2 
F23_1_D_2 
F23_1_E_2 
F23_1_F_2 
F23_1_G_2 
F23_1_H_2 
F23_1_I_2 
F23_1_J_2 
F23_1_K_2 
F23_1_L_2 
F23_2_M_2 
F23_2_N_2 
F23_2_O_2 
F23_2_P_2 
F23_2_Q_2 
F23_2_R_2 
F23_2_S_2 
F23_2_T_2 
F23_2_U_2 
F23_2_V_2 
F23_2_W_2 
F23_2_X_2 
F23_2_Y_2 
F24_2 
F25_2 
F26_1_A_2 
F26_1_B_2 
F26_1_C_2 
F26_1_D_2 
F26_1_E_2 
F26_2_F_2 
F26_2_G_2 
F26_2_H_2 
F26_2_I_2 
F26_2_J_2 
F26_2_K_2 
F27_1_2 
F27_2_2 
F27_3_2 
F27_4_2 
F28_2 
F29_A_2 
F29_B_2 
F29_C_2 
F29_D_2 
F30_2 
F31_2 
F32_2 
F32A_2 
F36_2 
F36A_2 
F38_A_2 
F38_B_2 
F38_C_2 
F38_D_2 
F38_E_2 
F38_F_2 
F38_G_2 
F38_H_2 
F38_I_2 
F38_J_2 
F39_A_2 
F39_B_2 
F39_C_2 
F39_D_2 
F39_E_2 
F39_F_2 
F39_G_2 
F39_H_2 
F39_I_2 
F39_J_2 
F39_K_2 
F40_2 
F40A_2 
F41_2 
F42_2 
F42A_2 
F42B_2 
F43_2 
F43A_2 
F44_2 
F44B_2 
F44C_2 
F45_2 
F45A_2 
F45B_2 
F45C_2 
F46_2 
F46A_2 

sdq_total_2
sdq_emo_2
sdq_conduct_2
sdq_hyper_2
sdq_peer_2
sdq_total_cat_2
sdq_emo_cat_2
sdq_conduct_cat_2
sdq_hyper_cat_2
sdq_peer_cat_2
score_sdq_A_2
score_sdq_B_2
score_sdq_C_2
score_sdq_D_2
score_sdq_E_2
score_sdq_F_2
score_sdq_G_2
score_sdq_H_2
score_sdq_I_2
score_sdq_J_2
score_sdq_K_2
score_sdq_L_2
score_sdq_M_2
score_sdq_N_2
score_sdq_O_2
score_sdq_P_2
score_sdq_Q_2
score_sdq_R_2
score_sdq_S_2
score_sdq_T_2
score_sdq_U_2
score_sdq_V_2
score_sdq_W_2
score_sdq_X_2
score_sdq_Y_2
)

focal_child3 (KEEP=
id_fam_vand id_famfc3_vand
FCC_AGE
FC_C_ID
FC3_RELATIONSHIP
FC3_GENDER
FC3_CHILD_WITH
FC3_NEWBORN
FC3_IDn

FC3_SAMP_NUM 
FC3_RELATIONSHIP 
FC3_GENDER 
FC3_CHILD_WITH 
FC3_NEWBORN 
FC3_STATUS

FC3_AAIM 
FC3_A18MOAGE 
FC3_SC2
FC3_SC2REFDK_C7 
FC3_SC2REFDK_C8 
FC3_SC3 
FC3_BAIM 
FC3_B18MOAGE 
FC3_SC4 
FC3_SC4REFDK_C7 
FC3_SC4REFDK_C8 
FC3_SC5 
FC3_SC6 
FC3_SC7A 
FC3_SC7B 
FC3_SC7C 
FC3_SC7D 

FC3_AIM 
FC3_18MOAGE 
FC3_DOBStatus 
FC3_DOBStatusREFDK_C7 
FC3_DOBStatusREFDK_C8 
FC3_LiveInHH 
FC3_SelectStatus 

fc_age_3 
FC_AGE_M_3 
FC_AGE_Y_3 
F6_3 
F7M_3 
F7Y_3 
F8_3 
F9_3 
F10_3 
F10A1_3 
F11_1_3 
F11_95_OTHER_1_3 
F11B_1_3 
F11C_1_1_3 
F11C_2_1_3 
F11C_3_1_3 
F12A1_3 
F12B_3 
F12C_3 
F13A1_3 
F14_3 
F15_3 
F16_3 
F17_3 
F18_3 
F18A_3 
F18B_3 
F18B_95_OTHER_3 
F19_3 
F20A1_3
F20A2_3
F20A_3
F21_1_A_3 
F21_1_B_3 
F21_1_C_3 
F21_1_D_3 
F21_1_E_3 
F21_1_F_3 
F21_1_G_3 
F21_1_H_3 
F21_1_I_3 
F21_1_J_3 
F21_1_K_3 
F21_1_L_3 
F21_2_M_3 
F21_2_N_3 
F21_2_O_3 
F21_2_P_3 
F21_2_Q_3 
F21_2_R_3 
F21_2_S_3 
F21_2_T_3 
F21_2_U_3 
F21_2_V_3 
F21_2_W_3 
F21_2_X_3 
F21_2_Y_3 
F22_1_A_3 
F22_1_B_3 
F22_1_C_3 
F22_1_D_3 
F22_1_E_3 
F22_1_F_3 
F22_1_G_3 
F22_1_H_3 
F22_1_I_3 
F22_1_J_3 
F22_1_K_3 
F22_1_L_3 
F22_2_M_3 
F22_2_N_3 
F22_2_O_3 
F22_2_P_3 
F22_2_Q_3 
F22_2_R_3 
F22_2_S_3 
F22_2_T_3 
F22_2_U_3 
F22_2_V_3 
F22_2_W_3 
F22_2_X_3 
F22_2_Y_3 
F23_1_A_3 
F23_1_B_3 
F23_1_C_3 
F23_1_D_3 
F23_1_E_3 
F23_1_F_3 
F23_1_G_3 
F23_1_H_3 
F23_1_I_3 
F23_1_J_3 
F23_1_K_3 
F23_1_L_3 
F23_2_M_3 
F23_2_N_3 
F23_2_O_3 
F23_2_P_3 
F23_2_Q_3 
F23_2_R_3 
F23_2_S_3 
F23_2_T_3 
F23_2_U_3 
F23_2_V_3 
F23_2_W_3 
F23_2_X_3 
F23_2_Y_3 
F24_3 
F25_3 
F26_1_A_3 
F26_1_B_3 
F26_1_C_3 
F26_1_D_3 
F26_1_E_3 
F26_2_F_3 
F26_2_G_3 
F26_2_H_3 
F26_2_I_3 
F26_2_J_3 
F26_2_K_3 
F27_1_3 
F27_2_3 
F27_3_3 
F27_4_3 
F28_3 
F29_A_3 
F29_B_3 
F29_C_3 
F29_D_3 
F30_3 
F31_3 
F32_3 
F32A_3 
F36_3 
F36A_3 
F38_A_3 
F38_B_3 
F38_C_3 
F38_D_3 
F38_E_3 
F38_F_3 
F38_G_3 
F38_H_3 
F38_I_3 
F38_J_3 
F39_A_3 
F39_B_3 
F39_C_3 
F39_D_3 
F39_E_3 
F39_F_3 
F39_G_3 
F39_H_3 
F39_I_3 
F39_J_3 
F39_K_3 
F40_3 
F40A_3 
F41_3 
F42_3 
F42A_3 
F42B_3 
F43_3 
F43A_3 
F44_3 
F44B_3 
F44C_3 
F45_3 
F45A_3 
F45B_3 
F45C_3 
F46_3 
F46A_3 

sdq_total_3
sdq_emo_3
sdq_conduct_3
sdq_hyper_3
sdq_peer_3
sdq_total_cat_3
sdq_emo_cat_3
sdq_conduct_cat_3
sdq_hyper_cat_3
sdq_peer_cat_3
score_sdq_A_3
score_sdq_B_3
score_sdq_C_3
score_sdq_D_3
score_sdq_E_3
score_sdq_F_3
score_sdq_G_3
score_sdq_H_3
score_sdq_I_3
score_sdq_J_3
score_sdq_K_3
score_sdq_L_3
score_sdq_M_3
score_sdq_N_3
score_sdq_O_3
score_sdq_P_3
score_sdq_Q_3
score_sdq_R_3
score_sdq_S_3
score_sdq_T_3
score_sdq_U_3
score_sdq_V_3
score_sdq_W_3
score_sdq_X_3
score_sdq_Y_3
);

	SET fam18m.s02_18mo_vand_140211_scr;

	*convert FC sampling id variable from character to numeric;
	FC1_IDn=FC_A_ID*1; id_famfc1_vand=(id_fam_vand*10)+1;
	FC2_IDn=FC_B_ID*1; id_famfc2_vand=(id_fam_vand*10)+2;
	FC3_IDn=FC_C_ID*1; id_famfc3_vand=(id_fam_vand*10)+3;

	*Connect child sampling roster meta data to the focal children selected for:
		relationship, gender, with family, newborn status
		NOTE--slot number 11 never used, so dropping down to 10;
	ARRAY samp_numq (10) $ SAMP_NUM1-SAMP_NUM10;
	ARRAY relationshipq (10) $ RELATIONSHIP1-RELATIONSHIP10;
	ARRAY genderq (10) GENDER1-GENDER10;
	ARRAY cwq (10) CHILD_WITH1-CHILD_WITH10;
	ARRAY newbornq (10) NEWBORN1-NEWBORN10;
	ARRAY fc_statusq (10) $ FC_STATUS1-FC_STATUS10;

	/*Screener questions (SC series)*/
	ARRAY  AAIMq (10) AAIM_1-AAIM_10;
	ARRAY  A18MOAGEq (10) A18MOAGE_1-A18MOAGE_10;
	ARRAY  SC2q (10) SC2_1-SC2_10;
	ARRAY  SC2AREFDK_C7q (10) SC2AREFDK_1C7 SC2AREFDK_2C7 SC2AREFDK_3C7 SC2AREFDK_4C7 SC2AREFDK_5C7 
							  SC2AREFDK_6C7 SC2AREFDK_7C7 SC2AREFDK_8C7 SC2AREFDK_9C7 SC2AREFDK_10C7;
	ARRAY  SC2AREFDK_C8q (10) SC2AREFDK_1C8 SC2AREFDK_2C8 SC2AREFDK_3C8 SC2AREFDK_4C8 SC2AREFDK_5C8 
							  SC2AREFDK_6C8 SC2AREFDK_7C8 SC2AREFDK_8C8 SC2AREFDK_9C8 SC2AREFDK_10C8;
	ARRAY  SC3q (10) SC3_1-SC3_10;

	ARRAY  BAIMq (10) BAIM_1-BAIM_10;
	ARRAY  B18MOAGEq (10) B18MOAGE_1-B18MOAGE_10;
	ARRAY  SC4q (10) SC4_1-SC4_10;
	ARRAY  SC4AREFDK_C7q (10) SC4AREFDK_1C7 SC4AREFDK_2C7 SC4AREFDK_3C7 SC4AREFDK_4C7 SC4AREFDK_5C7 
							  SC4AREFDK_6C7 SC4AREFDK_7C7 SC4AREFDK_8C7 SC4AREFDK_9C7 SC4AREFDK_10C7;
	ARRAY  SC4AREFDK_C8q (10) SC4AREFDK_1C8 SC4AREFDK_2C8 SC4AREFDK_3C8 SC4AREFDK_4C8 SC4AREFDK_5C8 
							  SC4AREFDK_6C8 SC4AREFDK_7C8 SC4AREFDK_8C8 SC4AREFDK_9C8 SC4AREFDK_10C8;
	ARRAY  SC5q (10) SC5_1-SC5_10;

	ARRAY  SC6q (10) SC6_1-SC6_10;
	ARRAY  SC7Aq (10) SC7_A_1-SC7_A_10;
	ARRAY  SC7Bq (10) SC7_B_1-SC7_B_10;
	ARRAY  SC7Cq (10) SC7_C_1-SC7_C_10;
	ARRAY  SC7Dq (10) SC7_D_1-SC7_D_10;

	/*looping based on identifcation of focal child sampling number in FC1_ID, FC2_ID, FC3_ID*/
	DO i=1 TO 10;
		IF i=FC1_IDn THEN DO;
			FC1_SAMP_NUM=samp_numq[i]*1;
			FC1_RELATIONSHIP=relationshipq[i]*1;
			FC1_GENDER=genderq[i];
			FC1_CHILD_WITH=cwq[i];
			FC1_NEWBORN=newbornq[i];
			FC1_STATUS=fc_statusq[i];

			FC1_AAIM=AAIMq[i]*1;
			FC1_A18MOAGE=A18MOAGEq[i];
			FC1_SC2=SC2q[i];
			FC1_SC2REFDK_C7=SC2AREFDK_C7q[i];
			FC1_SC2REFDK_C8=SC2AREFDK_C8q[i];
			FC1_SC3=SC3q[i];

			FC1_BAIM=BAIMq[i]*1;
			FC1_B18MOAGE=B18MOAGEq[i];
			FC1_SC4=SC4q[i];
			FC1_SC4REFDK_C7=SC4AREFDK_C7q[i];
			FC1_SC4REFDK_C8=SC4AREFDK_C8q[i];
			FC1_SC5=SC5q[i];
			FC1_SC6=SC6q[i];
			FC1_SC7A=SC7Aq[i];
			FC1_SC7B=SC7Bq[i];
			FC1_SC7C=SC7Cq[i];
			FC1_SC7D=SC7Dq[i];
		END;

		IF i=FC2_IDn THEN DO;
			FC2_SAMP_NUM=samp_numq[i]*1;
			FC2_RELATIONSHIP=relationshipq[i]*1;
			FC2_GENDER=genderq[i];
			FC2_CHILD_WITH=cwq[i];
			FC2_NEWBORN=newbornq[i];
			FC2_STATUS=fc_statusq[i];

			FC2_AAIM=AAIMq[i]*1;
			FC2_A18MOAGE=A18MOAGEq[i];
			FC2_SC2=SC2q[i];
			FC2_SC2REFDK_C7=SC2AREFDK_C7q[i];
			FC2_SC2REFDK_C8=SC2AREFDK_C8q[i];
			FC2_SC3=SC3q[i];

			FC2_BAIM=BAIMq[i]*1;
			FC2_B18MOAGE=B18MOAGEq[i];
			FC2_SC4=SC4q[i];
			FC2_SC4REFDK_C7=SC4AREFDK_C7q[i];
			FC2_SC4REFDK_C8=SC4AREFDK_C8q[i];
			FC2_SC5=SC5q[i];
			FC2_SC6=SC6q[i];
			FC2_SC7A=SC7Aq[i];
			FC2_SC7B=SC7Bq[i];
			FC2_SC7C=SC7Cq[i];
			FC2_SC7D=SC7Dq[i];
		END;

		IF i=FC3_IDn THEN DO;
			FC3_SAMP_NUM=samp_numq[i]*1;
			FC3_RELATIONSHIP=relationshipq[i]*1;
			FC3_GENDER=genderq[i];
			FC3_CHILD_WITH=cwq[i];
			FC3_NEWBORN=newbornq[i];
			FC3_STATUS=fc_statusq[i];

			FC3_AAIM=AAIMq[i]*1;
			FC3_A18MOAGE=A18MOAGEq[i];
			FC3_SC2=SC2q[i];
			FC3_SC2REFDK_C7=SC2AREFDK_C7q[i];
			FC3_SC2REFDK_C8=SC2AREFDK_C8q[i];
			FC3_SC3=SC3q[i];

			FC3_BAIM=BAIMq[i]*1;
			FC3_B18MOAGE=B18MOAGEq[i];
			FC3_SC4=SC4q[i];
			FC3_SC4REFDK_C7=SC4AREFDK_C7q[i];
			FC3_SC4REFDK_C8=SC4AREFDK_C8q[i];
			FC3_SC5=SC5q[i];
			FC3_SC6=SC6q[i];
			FC3_SC7A=SC7Aq[i];
			FC3_SC7B=SC7Bq[i];
			FC3_SC7C=SC7Cq[i];
			FC3_SC7D=SC7Dq[i];
		END;
	END;

	*Combine parallel questions for A and B/C focal children, add selection status variable;
	IF FC1_STATUS='A' THEN DO;
		FC1_AIM=FC1_AAIM;
		FC1_18MOAGE=FC1_A18MOAGE;
		FC1_DOBStatus=FC1_SC2;
		FC1_DOBStatusREFDK_C7=FC1_SC2REFDK_C7;
		FC1_DOBStatusREFDK_C8=FC1_SC2REFDK_C8;
		FC1_LiveInHH=FC1_SC3;
		FC1_SelectStatus=1;
		END;
	ELSE IF FC1_STATUS in('B','C') THEN DO;
		FC1_AIM=FC1_BAIM;
		FC1_18MOAGE=FC1_B18MOAGE;
		FC1_DOBStatus=FC1_SC4;
		FC1_DOBStatusREFDK_C7=FC1_SC4REFDK_C7;
		FC1_DOBStatusREFDK_C8=FC1_SC4REFDK_C8;
		FC1_LiveInHH=FC1_SC5;

		IF FC1_STATUS='B' THEN DO;
			IF FC1_SC5 in(1,2) THEN FC1_SelectStatus=2;
			ELSE IF FC1_SC5 in(3,4) THEN FC1_SelectStatus=3;
			ELSE IF FC1_SC5 in(7,8) THEN FC1_SelectStatus=4;
			END;
		ELSE IF FC1_STATUS='C' THEN DO;
			IF FC1_SC5 in(1,2) THEN FC1_SelectStatus=5;
			ELSE IF FC1_SC5 in(3,4) THEN FC1_SelectStatus=6;
			ELSE IF FC1_SC5 in(7,8) THEN FC1_SelectStatus=7;
			END;
		END;

	IF FC2_STATUS='A' THEN DO;
		FC2_AIM=FC2_AAIM;
		FC2_18MOAGE=FC2_A18MOAGE;
		FC2_DOBStatus=FC2_SC2;
		FC2_DOBStatusREFDK_C7=FC2_SC2REFDK_C7;
		FC2_DOBStatusREFDK_C8=FC2_SC2REFDK_C8;
		FC2_LiveInHH=FC2_SC3;
		FC2_SelectStatus=1;
		END;
	ELSE IF FC2_STATUS in('B','C') THEN DO;
		FC2_AIM=FC2_BAIM;
		FC2_18MOAGE=FC2_B18MOAGE;
		FC2_DOBStatus=FC2_SC4;
		FC2_DOBStatusREFDK_C7=FC2_SC4REFDK_C7;
		FC2_DOBStatusREFDK_C8=FC2_SC4REFDK_C8;
		FC2_LiveInHH=FC2_SC5;

		IF FC2_STATUS='B' THEN DO;
			IF FC2_SC5 in(1,2) THEN FC2_SelectStatus=2;
			ELSE IF FC2_SC5 in(3,4) THEN FC2_SelectStatus=3;
			ELSE IF FC2_SC5 in(7,8) THEN FC2_SelectStatus=4;
			END;
		ELSE IF FC2_STATUS='C' THEN DO;
			IF FC2_SC5 in(1,2) THEN FC2_SelectStatus=5;
			ELSE IF FC2_SC5 in(3,4) THEN FC2_SelectStatus=6;
			ELSE IF FC2_SC5 in(7,8) THEN FC2_SelectStatus=7;
			END;
		END;

	IF FC3_STATUS='A' THEN DO;
		FC3_AIM=FC3_AAIM;
		FC3_18MOAGE=FC3_A18MOAGE;
		FC3_DOBStatus=FC3_SC2;
		FC3_DOBStatusREFDK_C7=FC3_SC2REFDK_C7;
		FC3_DOBStatusREFDK_C8=FC3_SC2REFDK_C8;
		FC3_LiveInHH=FC3_SC3;
		FC3_SelectStatus=1;
		END;
	ELSE IF FC3_STATUS in('B','C') THEN DO;
		FC3_AIM=FC3_BAIM;
		FC3_18MOAGE=FC3_B18MOAGE;
		FC3_DOBStatus=FC3_SC4;
		FC3_DOBStatusREFDK_C7=FC3_SC4REFDK_C7;
		FC3_DOBStatusREFDK_C8=FC3_SC4REFDK_C8;
		FC3_LiveInHH=FC3_SC5;

		IF FC3_STATUS='B' THEN DO;
			IF FC3_SC5 in(1,2) THEN FC3_SelectStatus=2;
			ELSE IF FC3_SC5 in(3,4) THEN FC3_SelectStatus=3;
			ELSE IF FC3_SC5 in(7,8) THEN FC3_SelectStatus=4;
			END;
		ELSE IF FC3_STATUS='C' THEN DO;
			IF FC3_SC5 in(1,2) THEN FC3_SelectStatus=5;
			ELSE IF FC3_SC5 in(3,4) THEN FC3_SelectStatus=6;
			ELSE IF FC3_SC5 in(7,8) THEN FC3_SelectStatus=7;
			END;
		END;


RUN;






*Give variables common names so can stack the child datasets;
%MACRO s02_rename;
%DO yy=1 %TO 3;
DATA s02_18mo_fcstack&yy;
	SET focal_child&yy (RENAME=( 

%IF &yy=1 %THEN %DO; FCA_age = FC_age_char FC_A_ID=FC_ID_char %END; /*No F20 variable for focal child 1 b/c could not be a newborn*/
%IF &yy=2 %THEN %DO; FCB_age = FC_age_char FC_B_ID=FC_ID_char F20A1_&yy.=F20A1 F20A2_&yy.=F20A2 F20A_&yy.=F20A %END;
%IF &yy=3 %THEN %DO; FCC_age = FC_age_char FC_C_ID=FC_ID_char F20A1_&yy.=F20A1 F20A2_&yy.=F20A2 F20A_&yy.=F20A %END;

id_famfc&yy._vand = id_famfc_vand
FC&yy._SAMP_NUM = FC_SAMP_NUM
FC&yy._RELATIONSHIP = FC_RELATIONSHIP
FC&yy._GENDER = FC_GENDER
FC&yy._CHILD_WITH = FC_CHILD_WITH
FC&yy._NEWBORN = FC_NEWBORN
FC&yy._STATUS = FC_STATUS
FC&yy._SelectStatus = FC_SelectStatus
FC&yy._IDn = FC_IDn

FC&yy._AAIM= FC_AAIM
FC&yy._A18MOAGE = FC_A18MOAGE
FC&yy._SC2 = FC_SC2
FC&yy._SC2REFDK_C7 = FC_SC2AREFDK_C7
FC&yy._SC2REFDK_C8 = FC_SC2AREFDK_C8
FC&yy._SC3 = FC_SC3
FC&yy._BAIM = FC_BAIM
FC&yy._B18MOAGE = FC_B18MOAGE
FC&yy._SC4 = FC_SC4
FC&yy._SC4REFDK_C7 = FC_SC4AREFDK_C7
FC&yy._SC4REFDK_C8 = FC_SC4AREFDK_C8
FC&yy._SC5 = FC_SC5
FC&yy._SC6 = FC_SC6
FC&yy._SC7A = FC_SC7A
FC&yy._SC7B = FC_SC7B
FC&yy._SC7C = FC_SC7C
FC&yy._SC7D = FC_SC7D
FC&yy._AIM = FC_AIM
FC&yy._18MOAGE = FC_18MOAGE
FC&yy._DOBStatus = FC_DOBStatus
FC&yy._DOBStatusREFDK_C7 = FC_DOBStatusREFDK_C7
FC&yy._DOBStatusREFDK_C8 = FC_DOBStatusREFDK_C8
FC&yy._LiveInHH = FC_LiveInHH

fc_age_&yy. = fc_age 
FC_AGE_M_&yy. = FC_AGE_M 
FC_AGE_Y_&yy. = FC_AGE_Y 
F6_&yy. = F6 
F7M_&yy. = F7M 
F7Y_&yy. = F7Y 
F8_&yy. = F8 
F9_&yy. = F9 
F10_&yy. = F10 
F10A1_&yy. = F10A1 
F11_1_&yy. = F11_1 
F11_95_OTHER_1_&yy. = F11_95_OTHER_1 
F11B_1_&yy. = F11B_1 
F11C_1_1_&yy. = F11C_1_1 
F11C_2_1_&yy. = F11C_2_1 
F11C_3_1_&yy. = F11C_3_1 
F12A1_&yy. = F12A1 
F12B_&yy. = F12B 
F12C_&yy. = F12C 
F13A1_&yy. = F13A1 
F14_&yy. = F14 
F15_&yy. = F15 
F16_&yy. = F16 
F17_&yy. = F17 
F18_&yy. = F18 
F18A_&yy. = F18A 
F18B_&yy. = F18B 
F18B_95_OTHER_&yy. = F18B_95_OTHER 
F19_&yy. = F19 

F21_1_A_&yy. = F21_1_A 
F21_1_B_&yy. = F21_1_B 
F21_1_C_&yy. = F21_1_C 
F21_1_D_&yy. = F21_1_D 
F21_1_E_&yy. = F21_1_E 
F21_1_F_&yy. = F21_1_F 
F21_1_G_&yy. = F21_1_G 
F21_1_H_&yy. = F21_1_H 
F21_1_I_&yy. = F21_1_I 
F21_1_J_&yy. = F21_1_J 
F21_1_K_&yy. = F21_1_K 
F21_1_L_&yy. = F21_1_L 
F21_2_M_&yy. = F21_2_M 
F21_2_N_&yy. = F21_2_N 
F21_2_O_&yy. = F21_2_O 
F21_2_P_&yy. = F21_2_P 
F21_2_Q_&yy. = F21_2_Q 
F21_2_R_&yy. = F21_2_R 
F21_2_S_&yy. = F21_2_S 
F21_2_T_&yy. = F21_2_T 
F21_2_U_&yy. = F21_2_U 
F21_2_V_&yy. = F21_2_V 
F21_2_W_&yy. = F21_2_W 
F21_2_X_&yy. = F21_2_X 
F21_2_Y_&yy. = F21_2_Y 
F22_1_A_&yy. = F22_1_A 
F22_1_B_&yy. = F22_1_B 
F22_1_C_&yy. = F22_1_C 
F22_1_D_&yy. = F22_1_D 
F22_1_E_&yy. = F22_1_E 
F22_1_F_&yy. = F22_1_F 
F22_1_G_&yy. = F22_1_G 
F22_1_H_&yy. = F22_1_H 
F22_1_I_&yy. = F22_1_I 
F22_1_J_&yy. = F22_1_J 
F22_1_K_&yy. = F22_1_K 
F22_1_L_&yy. = F22_1_L 
F22_2_M_&yy. = F22_2_M 
F22_2_N_&yy. = F22_2_N 
F22_2_O_&yy. = F22_2_O 
F22_2_P_&yy. = F22_2_P 
F22_2_Q_&yy. = F22_2_Q 
F22_2_R_&yy. = F22_2_R 
F22_2_S_&yy. = F22_2_S 
F22_2_T_&yy. = F22_2_T 
F22_2_U_&yy. = F22_2_U 
F22_2_V_&yy. = F22_2_V 
F22_2_W_&yy. = F22_2_W 
F22_2_X_&yy. = F22_2_X 
F22_2_Y_&yy. = F22_2_Y 
F23_1_A_&yy. = F23_1_A 
F23_1_B_&yy. = F23_1_B 
F23_1_C_&yy. = F23_1_C 
F23_1_D_&yy. = F23_1_D 
F23_1_E_&yy. = F23_1_E 
F23_1_F_&yy. = F23_1_F 
F23_1_G_&yy. = F23_1_G 
F23_1_H_&yy. = F23_1_H 
F23_1_I_&yy. = F23_1_I 
F23_1_J_&yy. = F23_1_J 
F23_1_K_&yy. = F23_1_K 
F23_1_L_&yy. = F23_1_L 
F23_2_M_&yy. = F23_2_M 
F23_2_N_&yy. = F23_2_N 
F23_2_O_&yy. = F23_2_O 
F23_2_P_&yy. = F23_2_P 
F23_2_Q_&yy. = F23_2_Q 
F23_2_R_&yy. = F23_2_R 
F23_2_S_&yy. = F23_2_S 
F23_2_T_&yy. = F23_2_T 
F23_2_U_&yy. = F23_2_U 
F23_2_V_&yy. = F23_2_V 
F23_2_W_&yy. = F23_2_W 
F23_2_X_&yy. = F23_2_X 
F23_2_Y_&yy. = F23_2_Y 
F24_&yy. = F24 
F25_&yy. = F25 
F26_1_A_&yy. = F26_1_A 
F26_1_B_&yy. = F26_1_B 
F26_1_C_&yy. = F26_1_C 
F26_1_D_&yy. = F26_1_D 
F26_1_E_&yy. = F26_1_E 
F26_2_F_&yy. = F26_2_F 
F26_2_G_&yy. = F26_2_G 
F26_2_H_&yy. = F26_2_H 
F26_2_I_&yy. = F26_2_I 
F26_2_J_&yy. = F26_2_J 
F26_2_K_&yy. = F26_2_K 
F27_1_&yy. = F27_1 
F27_2_&yy. = F27_2 
F27_3_&yy. = F27_3 
F27_4_&yy. = F27_4 
F28_&yy. = F28 
F29_A_&yy. = F29_A 
F29_B_&yy. = F29_B 
F29_C_&yy. = F29_C 
F29_D_&yy. = F29_D 
F30_&yy. = F30 
F31_&yy. = F31 
F32_&yy. = F32 
F32A_&yy. = F32A 
F36_&yy. = F36 
F36A_&yy. = F36A 
F38_A_&yy. = F38_A 
F38_B_&yy. = F38_B 
F38_C_&yy. = F38_C 
F38_D_&yy. = F38_D 
F38_E_&yy. = F38_E 
F38_F_&yy. = F38_F 
F38_G_&yy. = F38_G 
F38_H_&yy. = F38_H 
F38_I_&yy. = F38_I 
F38_J_&yy. = F38_J 
F39_A_&yy. = F39_A 
F39_B_&yy. = F39_B 
F39_C_&yy. = F39_C 
F39_D_&yy. = F39_D 
F39_E_&yy. = F39_E 
F39_F_&yy. = F39_F 
F39_G_&yy. = F39_G 
F39_H_&yy. = F39_H 
F39_I_&yy. = F39_I 
F39_J_&yy. = F39_J 
F39_K_&yy. = F39_K 
F40_&yy. = F40 
F40A_&yy. = F40A 
F41_&yy. = F41 
F42_&yy. = F42 
F42A_&yy. = F42A 
F42B_&yy. = F42B 
F43_&yy. = F43 
F43A_&yy. = F43A 
F44_&yy. = F44 
F44B_&yy. = F44B 
F44C_&yy. = F44C 
F45_&yy. = F45 
F45A_&yy. = F45A 
F45B_&yy. = F45B 
F45C_&yy. = F45C 
F46_&yy. = F46 
F46A_&yy. = F46A 

sdq_total_&yy. = sdq_total 
sdq_emo_&yy. = sdq_emo 
sdq_conduct_&yy. = sdq_conduct 
sdq_hyper_&yy. = sdq_hyper 
sdq_peer_&yy. = sdq_peer 
sdq_total_cat_&yy. = sdq_total_cat 
sdq_emo_cat_&yy. = sdq_emo_cat 
sdq_conduct_cat_&yy. = sdq_conduct_cat 
sdq_hyper_cat_&yy. = sdq_hyper_cat 
sdq_peer_cat_&yy. = sdq_peer_cat 

score_sdq_A_&yy. = score_sdq_A 
score_sdq_B_&yy. = score_sdq_B 
score_sdq_C_&yy. = score_sdq_C 
score_sdq_D_&yy. = score_sdq_D 
score_sdq_E_&yy. = score_sdq_E 
score_sdq_F_&yy. = score_sdq_F 
score_sdq_G_&yy. = score_sdq_G 
score_sdq_H_&yy. = score_sdq_H 
score_sdq_I_&yy. = score_sdq_I 
score_sdq_J_&yy. = score_sdq_J 
score_sdq_K_&yy. = score_sdq_K 
score_sdq_L_&yy. = score_sdq_L 
score_sdq_M_&yy. = score_sdq_M 
score_sdq_N_&yy. = score_sdq_N 
score_sdq_O_&yy. = score_sdq_O 
score_sdq_P_&yy. = score_sdq_P 
score_sdq_Q_&yy. = score_sdq_Q 
score_sdq_R_&yy. = score_sdq_R 
score_sdq_S_&yy. = score_sdq_S 
score_sdq_T_&yy. = score_sdq_T 
score_sdq_U_&yy. = score_sdq_U 
score_sdq_V_&yy. = score_sdq_V 
score_sdq_W_&yy. = score_sdq_W 
score_sdq_X_&yy. = score_sdq_X 
score_sdq_Y_&yy. = score_sdq_Y 
));


RUN;
%END;
%MEND;
%s02_rename;


*Stack child datasets;
DATA fam18m.s02_18mo_fcstack;
	SET s02_18mo_fcstack1-s02_18mo_fcstack3;
	IF FC_IDn~=.;
	IF fc_age~=.; /*three newborns selected (so have an FC_IDn, but no questions asked or age recorded*/
RUN;
*checked: n=2787 which equals total of 2790 focal children - 3 sampled newborns with no FC age. aggregation worked properly;


*Merge in family-level information with child dataset;
PROC SQL;
	CREATE TABLE fam18m.s02_18mo_fc_base AS 
	SELECT A.*, B.*
	FROM fam18m.s02_18mo_fcstack A LEFT JOIN 
		fam18m.s02_18mo_vand_140211_scr (DROP= F10: F11: F12: F13: F14: F15: F16: F17: F18: F19: F20:
		F21: F22: F23: F24: F25: F26: F27: F28: F29: F31: F32: F36: F38: F40: F41: F42: F43: F44: F45: F46: F6: F7: F8: F9:) B
		ON A.id_fam_vand = B.id_fam_vand
	ORDER BY A.id_famfc_vand;
QUIT;

PROC SQL;
	/*merge in Home observation data on child ids*/
	CREATE TABLE s02_18mo_fc_whome_temp AS 
	SELECT A.*, B.*
	FROM fam18m.s02_18mo_fcstack A LEFT JOIN fam18m.s06_18mo_home_vand_140227 (DROP=id_fam_vand) B
	 ON A.id_famfc_vand = B.id_famfc_vand
	ORDER BY id_famfc_vand;

	/*merge in additional NICHD datasets -- separate program?*/
QUIT;




/*		ADDITIONAL SCALE SCORING		
-Family Routines (F26a-F26h)
-Sleep F26i,j,k
-Parenting Stress (F27, F28)
-Challenging environment for effective parenting (F29)
-HOME (18mo + observational data)
*/


DATA fam18m.s02_18mo_fc_whome; 

	SET work.s02_18mo_fc_whome_temp;

	IF fc_age in(0:35) THEN fc_age_0to2=1; ELSE fc_age_0to2=0;
	IF fc_age in(36:95) THEN fc_age_3to7=1; ELSE fc_age_3to7=0;
	IF fc_age in(0:71) THEN fc_age_u6=1; ELSE fc_age_u6=0;
	IF fc_age in(72:95) THEN fc_age_6to7=1; ELSE fc_age_6to7=0;
	IF fc_age in(96:215) THEN fc_age_8to17=1; ELSE fc_age_8to17=0;

/*  FAMILY ROUTINES AND SLEEP SCORING	
	routines is F26a-h, sleep is F26i-k*/

	ARRAY f26 (11) F26_1_A F26_1_B F26_1_C F26_1_D F26_1_E 
				F26_2_F F26_2_G F26_2_H F26_2_I F26_2_J F26_2_K;
	ARRAY sf26 (11) score_F26_1_A score_F26_1_B score_F26_1_C score_F26_1_D score_F26_1_E 
				score_F26_2_F score_F26_2_G score_F26_2_H score_F26_2_I score_F26_2_J score_F26_2_K;
	
	DO i=1 TO 11;
		IF i=1 THEN DO; miss_fam_routines=0; miss_sleep=0; END;
			if i in(1:5) AND f26[i] not in (1,2,3,4,5) THEN DO; sf26[i]=.; miss_fam_routines+1; END;
			else IF i in(1:5) THEN DO; /*Reverse code so higher = better routines*/
				IF f26[i]=1 THEN sf26[i]=5;
				ELSE IF f26[i]=2 THEN sf26[i]=4;
				ELSE IF f26[i]=3 THEN sf26[i]=3;
				ELSE IF f26[i]=4 THEN sf26[i]=2;
				ELSE IF f26[i]=5 THEN sf26[i]=1;
				END;

		if i in(6:8) AND fc_age_u6=0 AND f26[i] not in (1,2,3,4,5) THEN DO; sf26[i]=.; miss_fam_routines+1; END;
			else IF i in(6:8) AND fc_age_u6=0 THEN DO; /*Reverse code so higher = better routines*/
				IF f26[i]=1 THEN sf26[i]=5;
				ELSE IF f26[i]=2 THEN sf26[i]=4;
				ELSE IF f26[i]=3 THEN sf26[i]=3;
				ELSE IF f26[i]=4 THEN sf26[i]=2;
				ELSE IF f26[i]=5 THEN sf26[i]=1;
				END;
			else if i in(6:8) AND fc_age_u6=1 THEN sf26[i]=.;

		if i in(9:11) AND f26[i] not in (1,2,3,4,5) THEN DO; sf26[i]=.; miss_sleep+1; END;
			else IF i in(9:11) THEN sf26[i]=f26[i];
	
	END;
		miss_fam_routines=miss_fam_routines-1; miss_sleep=miss_sleep-1; /*adjust missing for a question that is worded diff dep on age in each section*/

	*collapse items to adjust for age skips;
		*F26d and e are one item with slightly different wording for age groups;
		IF score_F26_1_D=. AND score_F26_1_E=. THEN score_F26_1_DE=.;
			ELSE DO; score_F26_1_DE=sum(score_F26_1_D,score_F26_1_E); END;

		*Average scale score;
		IF fc_age_u6=1 AND miss_fam_routines in(0,1) 
			THEN score_fam_routines_avg=sum(score_F26_1_A, score_F26_1_B, score_F26_1_C,
			score_F26_1_DE)/(4-miss_fam_routines);
		ELSE IF fc_age_u6=0 AND miss_fam_routines in(0,1,2)
			THEN score_fam_routines_avg=sum(score_F26_1_A, score_F26_1_B, score_F26_1_C,
			score_F26_1_DE, score_F26_2_F, score_F26_2_G, score_F26_2_H)/(7-miss_fam_routines);
		ELSE score_fam_routines_avg=.;

		*score not accounting for any missings;
		score_fam_routines_nomiss=sum(score_F26_1_A, score_F26_1_B, score_F26_1_C,
			score_F26_1_DE, score_F26_2_F, score_F26_2_G, score_F26_2_H);

		*score common to all children is A,B,C,D/E, missing if missing one;
		score_fam_routines_AtoE=score_F26_1_A + score_F26_1_B + score_F26_1_C + score_F26_1_DE;

		*score for all children 6 and up--include f,g,h, missing if missing one;
		score_fam_routines_AtoH=score_F26_1_A + score_F26_1_B + score_F26_1_C + score_F26_1_DE
			+ score_F26_2_F + score_F26_2_G + score_F26_2_H;



		*collapse items I and J for sleep into item IJ;
		IF score_F26_2_I=. AND score_F26_2_J=. THEN score_F26_2_IJ=.;
			ELSE score_F26_2_IJ=sum(score_F26_2_I,score_F26_2_J);

		*score sleep scale by averaging IJ and K, NOTE--if missing part, just use one of the two?;
		score_sleep_prob_avg_miss=(score_F26_2_IJ + score_F26_2_K) / 2; *avg missing if either missing;
			*avg only missing if both missing;
		IF score_F26_2_IJ=. AND score_F26_2_K=. THEN score_sleep_prob_avg=.;
			ELSE IF score_F26_2_IJ=. OR score_F26_2_K=. THEN score_sleep_prob_avg=sum(score_F26_2_IJ, score_F26_2_K);
			ELSE score_sleep_prob_avg=sum(score_F26_2_IJ, score_F26_2_K) / 2;
			*sum-based score;
		score_sleep_prob_sum=score_F26_2_IJ + score_F26_2_K;

	*END family routines/sleep;


*Parenting Stress: F27,F28  --note reverse coding F27 so higher score = more stress;
	ARRAY f27 F27_1-F27_4 F28;
	ARRAY sf27 score_F27_1-score_F27_4 score_F28;
	miss_parent_stress=0;
	DO i=1 TO 5;
		IF f27[i] not in(1,2,3,4,5) THEN DO; sf27[i]=.; miss_parent_stress+1; END;
		IF i in(1:4) THEN DO;
			IF f27[i]=1 THEN sf27[i]=4;
			ELSE IF f27[i]=2 THEN sf27[i]=3;
			ELSE IF f27[i]=3 THEN sf27[i]=2;
			ELSE IF f27[i]=4 THEN sf27[i]=1;
			END;
		IF i=5 THEN DO;
			IF f27[i]=1 THEN sf27[i]=1;
			ELSE IF f27[i]=2 THEN sf27[i]=2;
			ELSE IF f27[i]=3 THEN sf27[i]=3;
			ELSE IF f27[i] in(4,5) THEN sf27[i]=4;
			END;
	END;

	score_parent_stress= score_F27_1 + score_F27_2 + score_F27_3 + score_F27_4 + score_F28;

	IF miss_parent_stress in(0,1) THEN score_parent_stress_avg=
		sum(score_F27_1 , score_F27_2 , score_F27_3 , score_F27_4 , score_F28)/(5-miss_parent_stress);
		ELSE score_parent_stress_avg=.;


*Challenging Parenting Environment (F29);
	ARRAY f29 F29_A F29_B F29_C F29_D;
	ARRAY sf29 score_F29_A score_F29_B score_F29_C score_F29_D;
	miss_chlgprntenv=0;
	DO OVER f29;
	IF f29 not in(1,2,3,4) THEN DO; sf29=.; miss_chlgprntenv+1; END;
		ELSE DO;
			IF f29=1 THEN sf29=4;
			ELSE IF f29=2 THEN sf29=3;
			ELSE IF f29=3 THEN sf29=2;
			ELSE IF f29=4 THEN sf29=1;
		END;
	END;


	score_chlgprntenv= score_F29_A + score_F29_B + score_F29_C + score_F29_D;

	IF miss_chlgprntenv in(0,1) THEN score_chlgprntenv_avg=
		sum(score_F29_A , score_F29_B , score_F29_C , score_F29_D)/(4-miss_chlgprntenv);
		ELSE score_chlgprntenv_avg=.;

	*END Parenting Stress / Challenging parenting environment;


/* HEALTH AND EDUCATION MEASURES */

*Low Birth weight
  Source: Low Birth Weight is weight less than 5lbs 8oz (,  Univeristy of Maryland Health and Reference Guide  
			Very low birth weight is 400g to 1500g or  14.1096oz to 52.9109oz (3.31 lbs)
			High birth weight is greater than 8.8 lbs (8lbs 12.8oz)

	suspicious values: 20 lbs 0oz, 23 lbs, 12 oz, and 16lbs 0oz (heaviest baby ever was around 15.5 lbs) 
		seems likely 20 was supposed to be 10 and 16 to be 6, less sure on 20; 

	*Weight in ounces and pounds;
	IF F20A1~="-2" THEN n_F20A1=F20A1*1;
	IF F20A2~="-2" THEN n_F20A2=F20A2*1;

	IF n_F20A1~=. THEN DO;
		F20_oz=sum(F20A1*16, F20A2);
		F20_lb=sum(F20A1   , (F20A2/16));
		END;

	*low/very low/high birth weight;
	IF F20_lb~=. AND F20_lb<5.5 THEN birth_weight_low=1; 
		ELSE IF F20_lb~=. AND F20_lb>=5.5 THEN birth_weight_low=0;
		ELSE birth_weight_low=.;
	IF F20_oz~=. AND F20_oz<53 THEN birth_weight_verylow=1; 
		ELSE IF F20_oz~=. AND F20_oz>=53 THEN birth_weight_verylow=0;
		ELSE birth_weight_verylow=.;
	IF F20_lb~=. AND F20_lb>8.8 THEN birth_weight_high=1; 
		ELSE IF F20_lb~=. AND F20_lb<=8.8 THEN birth_weight_high=0;
		ELSE birth_weight_high=.;

*Education;
		
	*Grades;
	IF F12C in(1:3) THEN score_grades=F12C;
		ELSE IF F12C in(4:5) THEN score_grades=4;

	*Number of schools;
	IF F12A1 not in("-1","-2"," ") THEN n_F12A1=F12A1*1; ELSE n_F12A1=.;

	*Absenteeism;
	IF F13A1 not in("-1","-2"," ") THEN n_F13A1=F13A1*1; ELSE n_F13A1=.;
	SELECT (n_F13A1);
		WHEN (0,1,2,3,4,5) absent_cat=n_F13A1;
		WHEN (6,7,8,9,10) absent_cat=6;
		WHEN (.) absent_cat=.;
		OTHERWISE absent_cat=7;
	END;


*Score the HOME data;
/*************  HOME Scale Scoring   ***************/
*HOME questions run from F30 to F46
	-5 subscales: 
		-Parental warmth, lack of hostility, learning/literacy, developmental stimulation, access to reading
	-Scoring varies by age
	-approach: score measures used across age first, then
	 go through age-specific measures and calculate scale scores within age;

*ALL AGES;
	*PARENTAL WARMTH
		-F33_A-F33_F is common to all ages
		-F34_A - infant/toddler (age 0-2) only
		-F35_A-F35_C - age 3-17;
	*LACK OF HOSTILITY
		-F33_G-F33_F common to all ages
		-F34B is age 0-2 only;

*LEARNING/LITERACY (age 0-2 only)
	-F30, F32/32a, F36/36a, F37, F38_A-F38_E;
*DEVELOPMENTAL STIMULATION 
	-age 3-7, F39a-F39j
	-age 8-17, F41, F42 + 42a + 42b, F43 + 43a,  F44 + 44b + 44c, F45 + 45a + 45b + 45c ;
*ACCESS TO READING
	-ages 3-7: F31, F32 + 32a, F39k, F40 + 40a
	-ages 8-17: F31, F32 + 32a, F46 + 46a;

/*All Age questions*/
	
	*Parental warmth and lack of hostility - observation;
		ARRAY hF33 (10) QF33A QF33B QF33C QF33D QF33E QF33F QF33G QF33H QF33I QF33J;
		ARRAY sF33 (10) score_F33A score_F33B score_F33C score_F33D score_F33E score_F33F score_F33G score_F33H score_F33I score_F33J;

		DO i=1 TO 10; 
			IF i=1 THEN DO; miss_HOME_warmth=0; miss_HOME_lackhostile=0; END;
			IF i in(1:6) THEN DO; IF hF33[i]=1 THEN sF33[i]=1; ELSE IF hF33[i]=2 THEN sF33[i]=0; ELSE DO; sF33[i]=.; miss_HOME_warmth+1;END;END;
			/*reverse code so scale is LACK of hostility*/
			ELSE IF i in(7:10) THEN DO; IF hF33[i]=1 THEN sF33[i]=0; ELSE IF hF33[i]=2 THEN sF33[i]=1; ELSE DO; sF33[i]=.; miss_HOME_lackhostile+1; END;END;
		END;


/*Age-specific questions*/
	*loop for age 0-2;
	IF fc_age in(0:35) THEN DO;
		miss_HOME_learn=0;

		IF F30 in(2,3) THEN score_F30=1; ELSE IF F30=1 THEN score_F30=0; ELSE miss_HOME_learn+1;
		IF F32A=3 THEN score_F32A=1; ELSE IF F32A in(1,2) OR (F32=1 AND F32A in(7,8,.)) THEN score_F32A=0; ELSE miss_HOME_learn+1;

		IF QF34A=1 THEN score_F34A=1; ELSE IF QF34A=2 THEN score_F34A=0; ELSE DO; score_F34A=.; miss_home_warmth+1;END;
		*reverse code F34B to be consistent with a LACK of hostility scale;
		IF QF34B=1 THEN score_F34B=0; ELSE IF QF34B=2 THEN score_F34B=1; ELSE DO; score_F34B=.; miss_home_lackhostile+1;END;

		IF F36A in(1,2) THEN score_F36A=1; ELSE IF F36=2 or (F36=1 AND F36A in(3,4,7,8)) THEN score_F36A=0;

		IF QF37=1 THEN score_F37=1; ELSE IF QF37=2 THEN score_F37=0; ELSE score_F37=.;

		*CHECK for F38 -- says age 12 months to 3 years -- did this include 36 months or only 35 months?;
		IF F38_A=1 THEN score_F38_A=1; ELSE IF F38_A=2 THEN score_F38_A=0; ELSE miss_HOME_learn+1;
		IF F38_B=1 THEN score_F38_B=1; ELSE IF F38_B=2 THEN score_F38_B=0; ELSE miss_HOME_learn+1;
		IF F38_C=1 THEN score_F38_C=1; ELSE IF F38_C=2 THEN score_F38_C=0; ELSE miss_HOME_learn+1;
		IF F38_D=1 THEN score_F38_D=1; ELSE IF F38_D=2 THEN score_F38_D=0; ELSE miss_HOME_learn+1;
		IF F38_E=1 THEN score_F38_E=1; ELSE IF F38_E=2 THEN score_F38_E=0; ELSE miss_HOME_learn+1;
			*Literature or music -- have to have at least one of each;
		IF F38_F=1 AND F38_G=1 THEN score_F38_FG=1; ELSE IF F38_F in(1,2) AND F38_G in(1,2) THEN score_F38_FG=0;  ELSE miss_HOME_learn+1;
		IF F38_F=1 THEN score_F38_F=1; ELSE IF F38_F=2 THEN score_F38_F=0;
		IF F38_G=1 THEN score_F38_G=1; ELSE IF F38_G=2 THEN score_F38_G=0; 
		*Note -- items after G are associated with the questions for age 3-7, but are included
		  in the age 0 to 2 battery in our survey;
		IF F38_H=1 THEN score_F38_H=1; ELSE IF F38_H=2 THEN score_F38_H=0;
		IF F38_I=1 THEN score_F38_I=1; ELSE IF F38_I=2 THEN score_F38_I=0;
		IF F38_J=1 THEN score_F38_J=1; ELSE IF F38_J=2 THEN score_F38_J=0;

		/*Score scales -- calculate total as long as all not missing, then only calculate average if meet 2/3 rule */
		IF miss_HOME_warmth in(0:6) THEN score_HOME_warmth_tot=SUM(score_F33A, score_F33B, score_F33C, score_F33D, score_F33E, score_F33F, score_F34A);
		IF miss_HOME_warmth in (0,1,2) THEN score_HOME_warmth_avg = score_HOME_warmth_tot/(7-miss_HOME_warmth);

		IF miss_HOME_lackhostile in(0:4) THEN score_HOME_lackhostile_tot=SUM(score_F33G, score_F33H, score_F33I, score_F33J, score_F34B);
		IF miss_HOME_lackhostile in (0,1) THEN score_HOME_lackhostile_avg = score_HOME_lackhostile_tot/(5-miss_HOME_lackhostile);

		IF miss_HOME_learn in(0:9) THEN score_HOME_learn_tot=SUM(score_F30, score_F32A, score_F36A, score_F37, score_F38_A, score_F38_B, score_F38_C, score_F38_D, score_F38_E, score_F38_FG);
		IF miss_HOME_learn in (0:3) THEN score_HOME_learn_avg = score_HOME_learn_tot/(10-miss_HOME_learn);
	END;


	*loop for age 3-7;
	IF fc_age in(36:95) THEN DO;
		miss_HOME_readaccess=0; miss_HOME_devstim=0;

		IF F31=1 THEN score_F31=1; ELSE IF F31=2 THEN score_F31=0; ELSE miss_HOME_readaccess+1;

		IF F32A=3 THEN score_F32A=1; ELSE IF F32A in(1,2) OR (F32=1 AND F32A in(7,8,.)) THEN score_F32A=0; ELSE miss_HOME_readaccess+1;

		IF QF35A=1 THEN score_F35A=1; ELSE IF QF35A=2 THEN score_F35A=0; ELSE DO; score_F35A=.; miss_HOME_warmth+1; END;
		IF QF35B=1 THEN score_F35B=1; ELSE IF QF35B=2 THEN score_F35B=0; ELSE DO; score_F35B=.; miss_HOME_warmth+1; END;
		IF QF35C=1 THEN score_F35C=1; ELSE IF QF35C=2 THEN score_F35C=0; ELSE DO; score_F35C=.; miss_HOME_warmth+1; END;

		IF F39_A=1 THEN score_F39_A=1; ELSE IF F39_A=2 THEN score_F39_A=0; ELSE miss_HOME_devstim+1;
		IF F39_B=1 THEN score_F39_B=1; ELSE IF F39_B=2 THEN score_F39_B=0; ELSE miss_HOME_devstim+1;
		IF F39_C=1 THEN score_F39_C=1; ELSE IF F39_C=2 THEN score_F39_C=0; ELSE miss_HOME_devstim+1;
		IF F39_D=1 THEN score_F39_D=1; ELSE IF F39_D=2 THEN score_F39_D=0; ELSE miss_HOME_devstim+1;
		IF F39_E=1 THEN score_F39_E=1; ELSE IF F39_E=2 THEN score_F39_E=0; ELSE miss_HOME_devstim+1;
		IF F39_F=1 THEN score_F39_F=1; ELSE IF F39_F=2 THEN score_F39_F=0; ELSE miss_HOME_devstim+1;
		IF F39_G=1 THEN score_F39_G=1; ELSE IF F39_G=2 THEN score_F39_G=0; ELSE miss_HOME_devstim+1;
		IF F39_H=1 THEN score_F39_H=1; ELSE IF F39_H=2 THEN score_F39_H=0; ELSE miss_HOME_devstim+1;
		IF F39_I=1 THEN score_F39_I=1; ELSE IF F39_I=2 THEN score_F39_I=0; ELSE miss_HOME_devstim+1;
		IF F39_J=1 THEN score_F39_J=1; ELSE IF F39_J=2 THEN score_F39_J=0; ELSE miss_HOME_devstim+1;
			*F39k is literacy/learning;
		IF F39_K=1 THEN score_F39_K=1; ELSE IF F39_K=2 THEN score_F39_K=0; ELSE miss_HOME_readaccess+1;
		IF F40A in(1,2) THEN score_F40A=1; ELSE IF F40=2 or (F40=1 AND F40A in(3,4,7,8)) THEN score_F40A=0; ELSE miss_HOME_readaccess+1;

		/*scale scoring*/
		IF miss_HOME_warmth in (0:8) THEN score_HOME_warmth_tot=SUM(score_F33A, score_F33B, score_F33C, score_F33D, score_F33E, score_F33F, score_F35A, score_F35B, score_F35C);
		IF miss_HOME_warmth in (0:3) THEN score_HOME_warmth_avg = score_HOME_warmth_tot/(9-miss_HOME_warmth);

		IF miss_HOME_lackhostile in (0:3) THEN score_HOME_lackhostile_tot=SUM(score_F33G, score_F33H, score_F33I, score_F33J);
		IF miss_HOME_lackhostile in (0,1) THEN score_HOME_lackhostile_avg = score_HOME_lackhostile_tot/(4-miss_HOME_lackhostile);

		IF miss_HOME_devstim in (0:9) THEN score_HOME_devstim_tot=SUM(score_F39_A, score_F39_B, score_F39_C, score_F39_D, score_F39_E, score_F39_F, score_F39_G, score_F39_H, score_F39_I, score_F39_J);
		IF miss_HOME_devstim in (0:3) THEN score_HOME_devstim_avg = score_HOME_devstim_tot/(10-miss_HOME_devstim);

		IF miss_HOME_readaccess in (0:3) THEN score_HOME_readaccess_tot=SUM(score_F31, score_F32A, score_F39_K, score_F40A);
		IF miss_HOME_readaccess in (0,1) THEN score_HOME_readaccess_avg = score_HOME_readaccess_tot/(4-miss_HOME_readaccess);

	END;

	*loop for age 8-17;
	ELSE IF fc_age in(96:215) THEN DO;
		miss_HOME_readaccess=0; miss_HOME_devstim=0;

		IF F31=1 THEN score_F31=1; ELSE IF F31=2 THEN score_F31=0; ELSE miss_HOME_readaccess+1;
		IF F32A=3 THEN score_F32A=1; ELSE IF F32A in(1,2) OR (F32=1 AND F32A in(7,8,.)) THEN score_F32A=0; ELSE miss_HOME_readaccess+1;


		IF QF35A=1 THEN score_F35A=1; ELSE IF QF35A=2 THEN score_F35A=0; ELSE DO; score_F35A=.; miss_HOME_warmth+1; END;
		IF QF35B=1 THEN score_F35B=1; ELSE IF QF35B=2 THEN score_F35B=0; ELSE DO; score_F35B=.; miss_HOME_warmth+1; END;
		IF QF35C=1 THEN score_F35C=1; ELSE IF QF35C=2 THEN score_F35C=0; ELSE DO; score_F35C=.; miss_HOME_warmth+1; END;

		*For homework, assumed parent had to have rules (F42), stick to them most of the time (F42a) and regularly check to make sure HW is done (F42b) to get the point
			Otherwise, if answered F42 then counted as 0;
		IF F42=1 and F42A=1 AND F42B=1 THEN score_F42=1; ELSE IF F42 in(1,2) THEN score_F42=0; ELSE miss_HOME_devstim+1;
		IF F43=1 and F43A in(1,2) THEN score_F43=1; ELSE IF F43 in(1,2) THEN score_F43=0; ELSE miss_HOME_devstim+1;
		IF F44=1 and F44B=1 and F44C in(1,2,3) THEN score_F44=1; ELSE IF F44 in(1,2) THEN score_F44=0; ELSE miss_HOME_devstim+1;
		*If child isn't interested in current events, does this still get scored as a zero?;
		IF F45=1 and F45A=1 and F45B=1 and F45C in(1,2,3) THEN score_F45=1; ELSE IF F45 in(1,2) THEN score_F45=0; ELSE miss_HOME_devstim+1;

		IF F46=1 or F46A=1 THEN score_F46=1; ELSE IF F46 in(1,2) or F46A in(1,2) THEN score_F46=0; ELSE miss_HOME_readaccess+1;

		/*scale scoring*/
		IF miss_HOME_warmth in (0:8) THEN score_HOME_warmth_tot=SUM(score_F33A, score_F33B, score_F33C, score_F33D, score_F33E, score_F33F, score_F35A, score_F35B, score_F35C);
		IF miss_HOME_warmth in (0:3) THEN score_HOME_warmth_avg = score_HOME_warmth_tot/(9-miss_HOME_warmth);

		IF miss_HOME_lackhostile in (0:3) THEN score_HOME_lackhostile_tot=SUM(score_F33G, score_F33H, score_F33I, score_F33J);
		IF miss_HOME_lackhostile in (0,1) THEN score_HOME_lackhostile_avg = score_HOME_lackhostile_tot/(4-miss_HOME_lackhostile);

		IF miss_HOME_devstim in (0:3) THEN score_HOME_devstim_tot=SUM(score_F42, score_F43, score_F44, score_F45);
		IF miss_HOME_devstim in (0,1) THEN score_HOME_devstim_avg = score_HOME_devstim_tot/(4-miss_HOME_devstim);

		IF miss_HOME_readaccess in (0:2) THEN score_HOME_readaccess_tot=SUM(score_F31, score_F32A, score_F46);
		IF miss_HOME_readaccess in (0,1) THEN score_HOME_readaccess_avg = score_HOME_readaccess_tot/(3-miss_HOME_readaccess);
	END;



*End Home Scale Scoring;


RUN;

