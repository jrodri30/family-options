/**************************************************************//*

Program:
Title: Exploratory analyses
Programmer: Scott Brown
Date Created: 04/16/2014
Last Update: 04/16/2014

Input files: 
Output files: 

Purpose:
-Run cross-tabs and non-diagnostic exploratory analyses

Sequence:
1) Within-Dataset Crosstabs
2) Within-Dataset Correlations
3) Within-Dataset Factor Analyses
4) Cross-Dataset Crosstabs
5) Cross-Dataset Correlations
6) Cross-Dataset Measure Development

*//**************************************************************/


LIBNAME fam18m "E:\Family Options\Data\02_18MonthData";
LIBNAME htks "E:\Family Options\Data\04_18MonthHTKSData";
LIBNAME aands "E:\Family Options\Data\05_18MonthAgesAndStagesData";
LIBNAME wjiii "E:\Family Options\Data\09_18MonthWJIIIData";
LIBNAME nichd "E:\Family Options\Data\11_18MonthChildSurveyData";




/******************************************************/
/***		1) Within-Dataset Crosstabs				***/
/******************************************************/


/*	Adult survey parent on child report	*/
OPTIONS FMTSEARCH=(fam18m) NOFMTERR;

ODS RTF FILE="E:\Family Options\Output\Exploratory\FO Low Birth Weight_2014_04_16.doc";
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TABLES birth_weight_low birth_weight_verylow birth_weight_high;
RUN;
PROC UNIVARIATE DATA=fam18m.s02_18mo_fc_whome;
	VAR F20_lb;
RUN;
ODS RTF CLOSE;


ODS RTF FILE="E:\Family Options\Output\Exploratory\FO Addtl Behavior Health Xtabs_2014_05_01.doc";
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Additional Exploratory Adult Survey Xtabs";
	TABLES F24*F25 /missing norow nocol;
	TABLES F14*F15 /missing norow nocol;
	TABLES F18*F19 /missing norow nocol;
	TABLES F12B*F12C /missing norow nocol;
RUN;
TITLE;
ODS RTF CLOSE;


/*  NICHD CHILD SURVEY DATA  */
OPTIONS FMTSEARCH=(nichd) NOFMTERR;


ODS RTF FILE="E:\Family Options\Output\Exploratory\FO Substance Use Frequencies by Age Group_2014_04_16.doc";
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Substance Use - Frequencies, Ages 8-17";
	TABLES score_subst_life miss_subst_life score_subst_recent miss_subst_recent 
			D1-D8 D10-D23;
RUN;

*Age 8 to 12;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Substance Use: Lifetime - Alphas, Age 8-12";
	WHERE child_age_8to12=1;
	VAR score_life_cigs score_life_alcohol score_life_marijuana score_life_cocaine score_life_other;
RUN;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Substance Use: Recent - Alphas, Age 8-12";
	WHERE child_age_8to12=1;
	VAR score_recent_cigs score_recent_alcohol score_recent_binge score_recent_marijuana;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Substance Use: Lifetime and Recent - Average Score (2/3 rule), Age 8-12";
	WHERE child_age_8to12=1;
	VAR score_subst_life_avg score_subst_recent_avg;
RUN;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Substance Use - Frequencies, Age 8-12";
	WHERE child_age_8to12=1;
	TABLES score_subst_life miss_subst_life score_subst_recent miss_subst_recent 
			D1-D8 D10-D23;
RUN;

*Age 13 to 17;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Substance Use: Lifetime - Alphas, Age 13-17";
	WHERE child_age_13to17=1;
	VAR score_life_cigs score_life_alcohol score_life_marijuana score_life_cocaine score_life_other;
RUN;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Substance Use: Recent - Alphas, Age 13-17";
	WHERE child_age_13to17=1;
	VAR score_recent_cigs score_recent_alcohol score_recent_binge score_recent_marijuana;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Substance Use: Lifetime and Recent - Average Score (2/3 rule), Age 13-17";
	WHERE child_age_13to17=1;
	VAR score_subst_life_avg score_subst_recent_avg;
RUN;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Substance Use - Frequencies, Age 13-17";
	WHERE child_age_13to17=1;
	TABLES score_subst_life miss_subst_life score_subst_recent miss_subst_recent 
			D1-D8 D10-D23;
RUN;
ODS RTF CLOSE;





/******************************************************/
/***		2) Within-Dataset Correlations			***/
/******************************************************/



/******************************************************/
/***		3) Within-Dataset Factor Analyses		***/
/******************************************************/

/* NICHD CHILD SURVEY */
OPTIONS FMTSEARCH=(nichd) NOFMTERR;

ODS RTF FILE="E:\Family Options\Output\Exploratory\WithinDatasetEFA Fears and Parenting_2014_04_17.doc";
*FEARS;
	*No rotation (6 factors, 1 big, two moderate);
PROC FACTOR DATA=nichd.s11_18mo_chsurv_vand_140331_scr SCREE;
	TITLE "Fears - PCA";
	VAR score_BA_1-score_BA_11 score_BB_12-score_BB_22 score_BC_23-score_BC_33;
RUN;
	*Varimax rotation (orthogonal--no corr, 6 factors--1 marginal);
PROC FACTOR DATA=nichd.s11_18mo_chsurv_vand_140331_scr SCREE ROTATE=VARIMAX;
	TITLE "Fears - VARIMAX (orthogonal)";
	VAR score_BA_1-score_BA_11 score_BB_12-score_BB_22 score_BC_23-score_BC_33;
RUN;
	*Promax rotation (oblique--allows corr, 6 factors;
PROC FACTOR DATA=nichd.s11_18mo_chsurv_vand_140331_scr SCREE ROTATE=PROMAX;
	TITLE "Fears - PROMAX (oblique)";
	VAR score_BA_1-score_BA_11 score_BB_12-score_BB_22 score_BC_23-score_BC_33;
RUN;

*INVOLVED-VIGILANT PARENTING;
	*No rotation (5 factors--2 stronger);
PROC FACTOR DATA=nichd.s11_18mo_chsurv_vand_140331_scr SCREE;
	TITLE "Involved-Vigilant Parenting - EFA";
	VAR score_FA_1-score_FA_10 score_FB_11-score_FB_20;
RUN;
	*Varimax rotation (orthogonal--no corr, 5 factors);
PROC FACTOR DATA=nichd.s11_18mo_chsurv_vand_140331_scr SCREE ROTATE=VARIMAX;
	TITLE "Fears - VARIMAX (orthogonal)";
	VAR score_FA_1-score_FA_10 score_FB_11-score_FB_20;
RUN;
	*Promax rotation (oblique--allows corr, 5 factors) ;
PROC FACTOR DATA=nichd.s11_18mo_chsurv_vand_140331_scr SCREE ROTATE=PROMAX;
	TITLE "Fears - PROMAX (oblique)";
	VAR score_FA_1-score_FA_10 score_FB_11-score_FB_20;
RUN;
ODS RTF CLOSE;

/******************************************************/
/***		4) Cross-Dataset Crosstabs				***/
/******************************************************/


/******************************************************/
/***		5) Cross-Dataset Correlations			***/
/******************************************************/

*Create merged NICHD / Parent on Focal Child dataset;
PROC SQL;
	CREATE TABLE adult_ch8to17 AS
	SELECT A.*, B.*
	FROM fam18m.s02_18mo_fc_whome (keep=id_famfc_vand F12C score_grades n_F12A1 F12A1 n_F13A1 F13A1 absent_cat) A, 
		nichd.s11_18mo_chsurv_vand_140331_scr B
	WHERE A.id_famfc_vand = B.id_famfc_vand
	ORDER BY A.id_famfc_vand;
QUIT;

ODS RTF FILE="E:\Family Options\Output\Exploratory\CrossDatasetCorrelations Education_2014_04_17.doc";
PROC FREQ DATA=adult_ch8to17;
	TABLES F12C*E1 score_grades*nichd_score_grades /missing norow nocol;
	TABLES n_F13A1*E2 absent_cat*nichd_absent_cat /missing norow nocol;
RUN;
PROC CORR DATA=adult_ch8to17;
	VAR score_grades nichd_score_grades;
RUN;
PROC CORR DATA=adult_ch8to17;
	VAR absent_cat nichd_absent_cat;
RUN;
ODS RTF CLOSE;

/******************************************************/
/***		6) Cross-Dataset Measure Development	***/
/******************************************************/







