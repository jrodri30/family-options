/*

Title: s02e_CreatePsychometricsForScales_2014_03_10_sb
Purpose: Produce psychometric stats and correlations for 18 month scales
Programmer: Scott Brown

Date Created: 3/10/2014
Last Updated: 4/8/2014

Input datasets:
Output datasets:
Output files:

Purpose: Create alphas and scale psychometrics for all child and family mediating scales
-Scales from 18 month survey already scored
-Some data processing for additional scales received from Abt

Sections:
1) 18 month survey scales, family-level
	a)CHAOS
2) 18 month survey scales, focal-child level
	a) Strengths and Difficulties (SDQ)
	b) Family Routines
	c) Parenting Stress
	d) Challenging parenting environment
	e) Non-scale outcomes: Educational, health, behavioral
3) HOME Scales
4) HTKS
5) Ages and Stages
6) 


*/


LIBNAME fam18m "E:\Family Options\Data\02_18MonthData";
LIBNAME htks "E:\Family Options\Data\04_18MonthHTKSData";
LIBNAME aands "E:\Family Options\Data\05_18MonthAgesAndStagesData";
LIBNAME wjiii "E:\Family Options\Data\09_18MonthWJIIIData";
LIBNAME nichd "E:\Family Options\Data\11_18MonthChildSurveyData";
%LET expdir="E:\Family Options\Data\02_18MonthData";

OPTIONS FMTSEARCH=(fam18m) NOFMTERR;




/******  18 month survey scales, family-level  ****/

*CHAOS  -- update dataset once finalized;
ODS RTF FILE="E:\Family Options\Output\FO CHAOS Alphas_2014_03_10.doc";
PROC CORR DATA=FAM18M.S02_18MO_VAND_140211_SCR ALPHA NOMISS;
	VAR score_F48_A  score_F48_B  score_F48_C  score_F48_D  score_F48_E 
			score_F48_F  score_F48_G  score_F48_H  score_F48_I  score_F48_J 
			score_F48_K  score_F48_L  score_F48_M  score_F48_N;
RUN;
ODS RTF CLOSE;




/*****   18 month survey scales, focal-child level *****/

*SDQ: score_sdq_A-score_sdq_Y;

ODS RTF FILE="E:\Family Options\Output\FO SDQ Alphas_2014_03_10.doc";
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_sdq_C score_sdq_H score_sdq_M score_sdq_P score_sdq_X;/*emo*/
RUN;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_sdq_E score_sdq_G score_sdq_L score_sdq_R score_sdq_V;/*conduct*/
RUN;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_sdq_B score_sdq_J score_sdq_O score_sdq_U score_sdq_Y;/*hyper*/
RUN;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_sdq_F score_sdq_K score_sdq_n score_sdq_S score_sdq_W;/*peer*/
RUN;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_sdq_A score_sdq_D score_sdq_I score_sdq_Q score_sdq_T;/*prosocial*/ 
RUN;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_sdq_C score_sdq_H score_sdq_M score_sdq_P score_sdq_X;/*emo*/
	VAR score_sdq_E score_sdq_G score_sdq_L score_sdq_R score_sdq_V;/*conduct*/
	VAR score_sdq_B score_sdq_J score_sdq_O score_sdq_U score_sdq_Y;/*hyper*/
	VAR score_sdq_F score_sdq_K score_sdq_n score_sdq_S score_sdq_W;/*peer*/
RUN;
ODS RTF CLOSE;


*Family Routines F26A-H;
ODS RTF FILE="E:\Family Options\Output\FO Family Routines Sleep Parenting Alphas_2014_03_13.doc";

*Age 6+;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_F26_1_A score_F26_1_B score_F26_1_C score_F26_1_DE score_F26_2_F score_F26_2_G score_F26_2_H;
RUN;

*All children;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_F26_1_A score_F26_1_B score_F26_1_C score_F26_1_DE;
RUN;


PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TABLES score_fam_routines_nomiss score_fam_routines_AtoE score_fam_routines_AtoH
		F26_1_A--F26_2_H;
RUN;
*Sleep scale F26,i,j,k;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_F26_2_IJ score_F26_2_K;
RUN;

PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TABLES score_sleep_avg score_sleep_avg_adjmiss score_sleep_sum 
			F26_2_I F26_2_J F26_2_K score_F26_2_IJ;
RUN;
	*END family routines;


*Parenting Stress: F27,F28;
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_F27_1-score_F27_4 score_F28_rc;
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TABLES  score_parent_stress F27_1-F27_4 F28;
RUN; 

*Challenging Parenting Environment (F29);
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	VAR score_F29_A score_F29_B score_F29_C score_F29_D;
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TABLES  score_chlgprntenv F29_A F29_B F29_C F29_D;
RUN;

ODS RTF CLOSE;




*Non-scale outcomes;
ODS RTF FILE="E:\Family Options\Output\FO 18mo Edu Health Behavior freqs_2014_03_27.doc";
*Educational;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Educational Outcomes: School and child care attendance";
	TABLES F6 /*F7 need to calc based on interview date*/ F10 F10A1 F13A1;
RUN;

PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Educational Outcomes: School mobility";
	TABLES F12A1;
RUN;

PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Educational Outcomes: Grade completion";
	TABLES F8 F9 F12B F12C;
RUN;

PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Educational Outcomes: Preschool/Head Start Enrollment";
	TABLES F11C_1_1 F11C_2_1 F11C_3_1;
RUN;

*Health;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Health Outcomes: General Health";
	TABLES F18 F19 F20A birth_weight_low birth_weight_verylow birth_weight_high;
RUN;
PROC UNIVARIATE DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Health Outcomes: General Health";
	VAR F20_lb ;
RUN;

*Behavioral;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Behavioral Outcomes: School Conduct";
	TABLES F14 F15;
RUN;

PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	TITLE "Behavioral Outcomes: School Conduct";
	TABLES F24 F25;
RUN;
ODS RTF CLOSE;





*HOME;
*HOME alphas are constructed by the three age groups, no overall alpha;
ODS RTF FILE="E:\Family Options\Output\FO HOME Scales Alphas Frequencies and Avg Scores_2014_03_20.doc";
/*Age 0 to 2*/
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (0:35);
	VAR score_F33A score_F33B score_F33C score_F33D score_F33E score_F33F score_F34A;
	TITLE "HOME Alphas Age 0 to 2, Parental Warmth";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (0:35);
	TABLES  QF33A QF33B QF33C QF33D QF33E QF33F QF34A;
	TITLE "HOME Frequencies Age 0 to 2, Parental Warmth";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (0:35);
	VAR score_F33G score_F33H score_F33I score_F33J score_F34B;
	TITLE "HOME alphas Age 0 to 2, Lack of hostility";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (0:35);
	TABLES  QF33G QF33H QF33I QF33J QF34B;
	TITLE "HOME Frequencies Age 0 to 2, Lack of hostility";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (0:35);
	VAR score_F30 score_F32A score_F36A score_F37 score_F38_A score_F38_B score_F38_C score_F38_D score_F38_E score_F38_FG;
	TITLE "HOME alphas Age 0 to 2, Learning/Literacy";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (0:35);
	TABLES  F30 F32 F32A F36 F36A QF37 F38_A F38_B F38_C F38_D F38_E F38_F F38_G;
	TITLE "HOME Frequencies Age 0 to 2, Learning/Literacy";
RUN;

PROC UNIVARIATE DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (0:35);
	VAR score_HOME_warmth_avg score_HOME_lackhostile_avg  score_HOME_learn_avg;
	TITLE "HOME Average Scale Scores Age 0 to 2";
RUN;

/*Age 3 to 7*/
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (36:95);
	VAR score_F33A score_F33B score_F33C score_F33D score_F33E score_F33F score_F35A score_F35B score_F35C;
	TITLE "HOME Alphas Age 3 to 7, Parental Warmth";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (36:95);
	TABLES  QF33A QF33B QF33C QF33D QF33E QF33F QF35A QF35B QF35C;
	TITLE "HOME Frequencies Age 3 to 7, Parental Warmth";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (36:95);
	VAR score_F33G score_F33H score_F33I score_F33J;
	TITLE "HOME alphas Age 3 to 7, Lack of hostility";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (36:95);
	TABLES  QF33G QF33H QF33I QF33J;
	TITLE "HOME Frequencies Age 3 to 7, Lack of hostility";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (36:95);
	VAR score_F39_A score_F39_B score_F39_C score_F39_D score_F39_E score_F39_F score_F39_G score_F39_H score_F39_I score_F39_J;
	TITLE "HOME alphas Age 3 to 7, Developmental Simulation";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (36:95);
	TABLES  F39_A F39_B F39_C F39_D F39_E F39_F F39_G F39_H F39_I F39_J;
	TITLE "HOME Frequencies Age 3 to 7, Developmental Simulation";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (36:95);
	VAR score_F31 score_F32A score_F39_K score_F40A;
	TITLE "HOME alphas Age 3 to 7, Access to Reading";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (36:95);
	TABLES  F31 F32 F32A F39_K F40 F40A;
	TITLE "HOME Frequencies Age 3 to 7, Access to Reading";
RUN;

PROC UNIVARIATE DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (36:95);
	VAR score_HOME_warmth_avg score_HOME_lackhostile_avg  score_HOME_devstim_avg score_HOME_readaccess_avg ;
	TITLE "HOME Average Scale Scores Age 3 to 7";
RUN;

/*Age 8 to 17*/
PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (96:215);
	VAR score_F33A score_F33B score_F33C score_F33D score_F33E score_F33F score_F35A score_F35B score_F35C;
	TITLE "HOME Alphas Age 8 to 17, Parental Warmth";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (96:215);
	TABLES  QF33A QF33B QF33C QF33D QF33E QF33F QF35A QF35B QF35C;
	TITLE "HOME Frequencies Age 8 to 17, Parental Warmth";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (96:215);
	VAR score_F33G score_F33H score_F33I score_F33J;
	TITLE "HOME alphas Age 8 to 17, Lack of hostility";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (96:215);
	TABLES  QF33G QF33H QF33I QF33J;
	TITLE "HOME Frequencies Age 8 to 17, Lack of hostility";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (96:215);
	VAR score_F42 score_F43 score_F44 score_F45;
	TITLE "HOME alphas Age 8 to 17, Developmental Simulation";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (96:215);
	TABLES  F42 F42A F42B F43 F43A F44 F44B F44C F45 F45A F45B F45C;
	TITLE "HOME Frequencies Age 8 to 17, Developmental Simulation";
RUN;

PROC CORR DATA=fam18m.s02_18mo_fc_whome ALPHA NOMISS;
	WHERE fc_age in (96:215);
	VAR score_F31 score_F32A score_F46;
	TITLE "HOME alphas Age 8 to 17, Access to Reading";
RUN;
PROC FREQ DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (96:215);
	TABLES  F31 F32 F32A F46 F46A;
	TITLE "HOME Frequencies Age 8 to 17, Access to Reading";
RUN;

PROC UNIVARIATE DATA=fam18m.s02_18mo_fc_whome;
	WHERE fc_age in (96:215);
	VAR score_HOME_warmth_avg score_HOME_lackhostile_avg  score_HOME_devstim_avg score_HOME_readaccess_avg ;
	TITLE "HOME Average Scale Scores Age 8 to 17";
RUN;

ODS RTF CLOSE;









/******    NICHD add-on scoring    *******/
*HTKS
removed 8/9 DK/REF from scores
Ran alphas on trials 1-10 then trials 1-20
;

/*
*export file to examine refusal notes;
ODS TAGSETS.EXCELXP Style=NormalPrinter FILE="E:\Family Options\Output\FO HTKS Refusals_2014_03_14.xls";
	PROC PRINT DATA=htks.s04_18mo_htks_vand_140227;
		VAR id_famfc_vand AGE_MONTHS_recalc AGE_YEARS_recalc finished_test
		GENERAL_NOTES HTKS_total_score REFUSE_ATTEMPT REFUSE_BEGIN REFUSE_CONTINUE REFUSE_REASON;
	RUN;
ODS TAGSETS.EXCELXP CLOSE;*/


OPTIONS FMTSEARCH=(htks) NOFMTERR;

/*
*Refusal Reason Analysis by Site;
PROC SQL;
	CREATE TABLE temp AS
	SELECT A.id_fam_vand, A.id_famfc_vand, A.finished_test, A.Refuse_reason, A.AGE_YEARS_recalc, B.sitename
	FROM htks.s04_18mo_htks_vand_140331 A, fam18m.s02_18mo_vand_140211 (KEEP=id_fam_vand sitename) B
	WHERE A.id_fam_vand=B.id_fam_vand;
QUIT;

PROC PRINT data=TEMP; WHERE finished_test=0; RUN;
PROC FREQ DATA=temp; tables sitename*finished_test /nocol nopercent; RUN;
PROC FREQ DATA=temp; where finished_test=0; tables sitename*age_years_recalc /norow nopercent; RUN;
PROC FREQ DATA=temp; tables sitename*age_years_recalc /norow nopercent; RUN;
*/

/*
*comparison of tt11 to ZERO SCORE -- if 6 or above should not complete tt11;
PROC FREQ DATA=htks.s04_18mo_htks_vand_140331; tables tt_11*TT1_ZERO_SCORE /norow nocol nopercent missing; RUN;
*/

DATA htks.s04_18mo_htks_vand_140331_scr (DROP=i);
	SET htks.s04_18mo_htks_vand_140331;
	ARRAY tta (20) TT_1-TT_20;
	ARRAY ttb (20) score_TT_1-score_TT_20;
	IF TT_ZERO_SCORE in(1:5) THEN TT_PASS=1;
		ELSE IF TT_ZERO_SCORE IN(6:10) THEN TT_PASS=0;
	DO i=1 to 20;
		IF i=1 THEN miss_num_htks=0;
		IF tta[i]=0 THEN ttb[i]=0;
			ELSE IF tta[i]=1 THEN ttb[i]=1;
			ELSE IF tta[i]=2 THEN ttb[i]=2;
			ELSE ttb[i]=.; 
		IF i in (1:10) THEN DO; IF tta[i] not in(0,1,2) THEN miss_num_htks+1; END;
			ELSE IF i in(11:20) THEN DO; IF TT_PASS=1 AND tta[i] not in (0,1,2) THEN miss_num_htks+1;
	END;

	*compute averages and create flags for whether to keep observation or not based on;
	IF TT_PASS=1 AND miss_num_htks in(0:6) THEN DO; n_htks=20-miss_num_htks; include_htks=1; score_htks_avg=HTKS_total_score/n_htks; END;
		ELSE IF TT_PASS=1 AND miss_num_htks in(7:20) THEN DO; n_htks=20-miss_num_htks; include_htks=0; score_htks_avg=.; END;
		ELSE IF TT_PASS=0 AND miss_num_htks in(0:3) THEN DO; n_htks=10-miss_num_htks; include_htks=1; score_htks_avg=HTKS_total_score/n_htks; END;
		ELSE IF TT_PASS=0 AND miss_num_htks in(4:10) THEN DO; n_htks=10-miss_num_htks; include_htks=0; score_htks_avg=.; END;
		
		
	END;
RUN;


ODS RTF FILE="E:\Family Options\Output\FO HTKS Alphas_2014_04_16.doc";
PROC CORR DATA=htks.s04_18mo_htks_vand_140331_scr ALPHA NOMISS;
	WHERE finished_test=1; /*remove incomplete and missing cases*/
	VAR score_TT_1-score_TT_20;
RUN;
PROC UNIVARIATE DATA=htks.s04_18mo_htks_vand_140331_scr;
	VAR 
RUN;
PROC FREQ DATA=htks.s04_18mo_htks_vand_140331_scr;
	TABLES ;
RUN;
ODS RTF CLOSE;


*ages and stages
can still create a total score when have a DK or REF in one or two questions
added the 10/5/0 scoring, set DK and REF to missing
Used NOMISS for alpha calculation
;

/*IMPORT A+S MATRIX*/
PROC IMPORT FILE="E:\Family Options\Data\05_18MonthAgesAndStagesData\asqcutoffs.xls" 
	DBMS=EXCEL
	OUT=aands.asqcutoffs replace;
RUN;

OPTIONS FMTSEARCH=(aands) NOFMTERR;

PROC SQL;
	CREATE TABLE asq_temp AS
	SELECT A.*, B.*
	FROM aands.s05_18mo_ages_vand_140331 A LEFT JOIN aands.asqcutoffs B
	ON A.ASQ3_Version = B.ASQ_Version
	ORDER BY A.id_famfc_vand;
QUIT;

DATA aands.s05_18mo_ages_vand_140331_scr (DROP=i asq_mean: asq_sd: asq_cutoff:);
	SET asq_temp (DROP=ASQ_Version);
	ARRAY asq (30) communication_1-communication_6 finemotor_1-finemotor_6 grossmotor_1-grossmotor_6 personalsocial_1-personalsocial_6 problemsolving_1-problemsolving_6;
	ARRAY asqs (30) score_communication_1-score_communication_6 score_finemotor_1-score_finemotor_6 score_grossmotor_1-score_grossmotor_6 score_personalsocial_1-score_personalsocial_6 score_problemsolving_1-score_problemsolving_6;
	DO i=1 TO 30;
		IF asq[i]=1 THEN asqs[i]=10;
		ELSE IF asq[i]=2 THEN asqs[i]=5;
		ELSE IF asq[i]=3 THEN asqs[i]=0;
		ELSE asqs[i]=.;
	END;

	/*calculate z-scores by category and whether child met cutoff*/
	ARRAY asqtot 	AGES_totalscore_COMM AGES_totalscore_FINE AGES_totalscore_GROS AGES_totalscore_PERS AGES_totalscore_PROB;
	ARRAY asqmn 	asq_mean_comm asq_mean_fm	asq_mean_gm	 asq_mean_pers	asq_mean_prob;	
	ARRAY asqsd  	asq_sd_comm asq_sd_fm	asq_sd_gm	 asq_sd_pers	asq_sd_prob;
	ARRAY asqcut 	asq_cutoff_comm asq_cutoff_fm	asq_cutoff_gm	 asq_cutoff_pers	asq_cutoff_prob;

	ARRAY asqz 		AGES_zscore_COMM AGES_zscore_FINE AGES_zscore_GROS AGES_zscore_PERS AGES_zscore_PROB;
	ARRAY asqpass 	AGES_pass_COMM AGES_pass_FINE AGES_pass_GROS AGES_pass_PERS AGES_pass_PROB;
	ARRAY asqmiss 	AGES_miss_COMM AGES_miss_FINE AGES_miss_GROS AGES_miss_PERS AGES_miss_PROB;

	DO OVER asqtot;
		IF asqtot=. THEN DO; asqz=.; asqpass=.; asqmiss=1; END;
		ELSE DO; asqz=((asqtot-asqmn)/asqsd);
			IF asqtot>asqcut THEN asqpass=1; ELSE asqpass=0;
			asqmiss=0;
		END;
	END;

	*total missing domains;
	asq_miss_sum=sum(AGES_miss_COMM, AGES_miss_FINE, AGES_miss_GROS, AGES_miss_PERS, AGES_miss_PROB);

	*average z scores across all non-missing domains (first applies 2/3 rule, second is for kids with any domain);
	IF asq_miss_sum in(0,1) THEN AGES_zscore_avgdomain=SUM(AGES_zscore_COMM, AGES_zscore_FINE, AGES_zscore_GROS, AGES_zscore_PERS, AGES_zscore_PROB)/(5-asq_miss_sum);
	IF asq_miss_sum in(0:4) THEN AGES_zscore_avgdomain_any=SUM(AGES_zscore_COMM, AGES_zscore_FINE, AGES_zscore_GROS, AGES_zscore_PERS, AGES_zscore_PROB)/(5-asq_miss_sum);

	*Total and average number of domains passed;
	AGES_pass_tot=SUM(AGES_pass_COMM, AGES_pass_FINE, AGES_pass_GROS, AGES_pass_PERS, AGES_pass_PROB);
	AGES_pass_nomiss=AGES_pass_COMM+ AGES_pass_FINE+ AGES_pass_GROS+ AGES_pass_PERS+ AGES_pass_PROB;

	IF asq_miss_sum in(0,1) THEN AGES_pass_avg=SUM(AGES_pass_COMM, AGES_pass_FINE, AGES_pass_GROS, AGES_pass_PERS, AGES_pass_PROB)/(5-asq_miss_sum);
	IF asq_miss_sum in(0:4) THEN AGES_pass_avg_any=SUM(AGES_pass_COMM, AGES_pass_FINE, AGES_pass_GROS, AGES_pass_PERS, AGES_pass_PROB)/(5-asq_miss_sum);

RUN;


ODS RTF FILE="E:\Family Options\Output\FO Ages and Stages Alphas_2014_03_10.doc";
	*communication subscale;
PROC CORR DATA=aands.s05_18mo_ages_vand_140331_scr ALPHA NOMISS;
	VAR score_COMMUNICATION_1 score_COMMUNICATION_2 score_COMMUNICATION_3 score_COMMUNICATION_4 score_COMMUNICATION_5 score_COMMUNICATION_6;
RUN;
	*fine motor subscale;
PROC CORR DATA=aands.s05_18mo_ages_vand_140331_scr ALPHA NOMISS;
	VAR score_FINEMOTOR_1 score_FINEMOTOR_2 score_FINEMOTOR_3 score_FINEMOTOR_4 score_FINEMOTOR_5 score_FINEMOTOR_6;
RUN;
	*gross motor subscale;
PROC CORR DATA=aands.s05_18mo_ages_vand_140331_scr ALPHA NOMISS;
	VAR score_GROSSMOTOR_1 score_GROSSMOTOR_2 score_GROSSMOTOR_3 score_GROSSMOTOR_4 score_GROSSMOTOR_5 score_GROSSMOTOR_6;
RUN;
	*personal social subscale;
PROC CORR DATA=aands.s05_18mo_ages_vand_140331_scr ALPHA NOMISS;
	VAR score_PERSONALSOCIAL_1 score_PERSONALSOCIAL_2 score_PERSONALSOCIAL_3 score_PERSONALSOCIAL_4 score_PERSONALSOCIAL_5 score_PERSONALSOCIAL_6;
RUN;
	*problem solving subscale;
PROC CORR DATA=aands.s05_18mo_ages_vand_140331_scr ALPHA NOMISS;
	VAR score_PROBLEMSOLVING_1 score_PROBLEMSOLVING_2 score_PROBLEMSOLVING_3 score_PROBLEMSOLVING_4 score_PROBLEMSOLVING_5 score_PROBLEMSOLVING_6;
RUN;
ODS RTF CLOSE;


ODS RTF FILE="E:\Family Options\Output\FO Ages and Stages Summ Stats_2014_03_20.doc";
PROC FREQ DATA=aands.s05_18mo_ages_vand_140331_scr;
	TITLE "ASQ Missing Domains";
	TABLES asq_miss_sum AGES_miss_COMM AGES_miss_FINE AGES_miss_GROS AGES_miss_PERS AGES_miss_PROB;
RUN;

PROC FREQ DATA=aands.s05_18mo_ages_vand_140331_scr;
	TABLES AGES_pass_tot AGES_pass_nomiss AGES_pass_COMM AGES_pass_FINE AGES_pass_GROS AGES_pass_PERS AGES_pass_PROB;
	TITLE "ASQ Domain Pass Rates";
RUN;

PROC FREQ DATA=aands.s05_18mo_ages_vand_140331_scr;
	TABLES ASQ3_VERSION*(AGES_pass_tot AGES_pass_nomiss AGES_pass_COMM AGES_pass_FINE AGES_pass_GROS AGES_pass_PERS AGES_pass_PROB) /nocol nopercent;
	TITLE "ASQ Domain Pass Rates by ASQ Version";
RUN;

/*Convert to a PROC TABULATE later
PROC FREQ DATA=aands.s05_18mo_ages_vand_140331_scr;
	TABLES ASQ3_VERSION*ChronologicalAge_MONTHS_recalc*(AGES_pass_tot AGES_pass_nomiss AGES_pass_avg AGES_pass_avg_any AGES_pass_COMM AGES_pass_FINE AGES_pass_GROS AGES_pass_PERS AGES_pass_PROB) /LIST;
	TITLE "ASQ Domain Pass Rates by ASQ Version and Child Age (accounts for weeks premature)";
RUN;*/

/*Z Scores*/
PROC UNIVARIATE DATA=aands.s05_18mo_ages_vand_140331_scr;
	VAR AGES_zscore_avgdomain AGES_zscore_avgdomain_any AGES_zscore_COMM AGES_zscore_FINE AGES_zscore_GROS AGES_zscore_PERS AGES_zscore_PROB;
RUN;
ODS RTF CLOSE;


/*
*Check on phone completions, n=5, ans2f only used on PROBLEMSOLVING_3;
PROC FREQ DATA=aands.s05_18mo_ages_vand_140227_scr;
	TABLES PROBLEMSOLVING_3;
RUN;
*/





/***** NICHD CHILD SURVEY DATA   ******/


OPTIONS FMTSEARCH=(nichd) NOFMTERR;

/*PROC CONTENTS DATA=nichd.s11_18mo_childsurv_vand_140331; RUN;*/

PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TABLES E2 /missing norow nocol nopercent;
RUN;

/*
IF D7 in(4:7) OR D8 in(2:7) OR  D11 in(4:6) OR D12=1 THEN score_subst_riskcat=3; 
ELSE IF D2 in(2:7) OR D4 in(2:7) OR D5 in(2:7) OR D7 in(2:3) OR D11 in(2:3) THEN score_subst_riskcat=2;
ELSE IF  D2=1 AND D4=1 AND D5=1 AND (D6=2 OR D7=1) AND (D10=2 OR D11=1) THEN score_subst_riskcat=1;

Some kids don't meet the moderate criteria but have enough missingness on the rest that they don't meet all of the AND criteria to be low risk
  Alot of DK/REF scattered in here
*/


DATA nichd.s11_18mo_chsurv_vand_140331_scr;
	SET nichd.s11_18mo_childsurv_vand_140331;

	*A. Traits;
	ARRAY aa (20) AA_1-AA_10 AB_11-AB_20;
	ARRAY aas (20) score_AA_1-score_AA_10 score_AB_11-score_AB_20;

	DO i= 1 TO 20;
		IF i=1 THEN miss_traits=0;
		IF aa[i] not in(1,2,3) THEN DO; aas[i]=.; miss_traits+1;END;
		ELSE aas[i]=aa[i];
	END;

	score_traits=sum(of score_AA_1-score_AA_10, of score_AB_11-score_AB_20);
	IF miss_traits in(0:6) THEN score_traits_avg=score_traits/(20-miss_traits);

	*B. Fears;
	ARRAY ba (33) BA_1-BA_11 BB_12-BB_22 BC_23-BC_33;
	ARRAY bas (33) score_BA_1-score_BA_11 score_BB_12-score_BB_22 score_BC_23-score_BC_33;

	DO i= 1 TO 33;
		IF i=1 THEN miss_fears=0;
		IF ba[i] not in(1,2,3) THEN DO; bas[i]=.; miss_fears+1;END;
		ELSE bas[i]=ba[i];
	END;

	score_fears=sum(of score_BA_1-score_BA_11, of score_BB_12-score_BB_22,of score_BC_23-score_BC_33);
	IF miss_fears in(0:11) THEN score_fears_avg=score_fears/(33-miss_fears);

	*C. Life Events;
	ARRAY ca (29) CA_1 CA_2 CA_5 CA_6 CA_10-CA_15
					CB_16 CB_20-CB_23 CB_35-CB_38 CB_42
					CC_44 CC_45 CC_49 CC_50 CC_54 CC_55 CC_57 CC_61 CC_62;
	ARRAY cas (29) score_CA_1 score_CA_2 score_CA_5 score_CA_6 score_CA_10-score_CA_15
					score_CB_16 score_CB_20-score_CB_23 score_CB_35-score_CB_38 score_CB_42
					score_CC_44 score_CC_45 score_CC_49 score_CC_50 score_CC_54 score_CC_55 score_CC_57 score_CC_61 score_CC_62;

	DO i= 1 TO 29;
		IF i=1 THEN miss_events=0;
		IF ca[i] not in(1,2) THEN DO; cas[i]=.; miss_events+1;END;
		ELSE IF ca[i]=1 THEN cas[i]=1;
		ELSE IF ca[i]=2 THEN cas[i]=0;
	END;

	score_events=sum(of score_CA_1, score_CA_2, score_CA_5, score_CA_6,of score_CA_10-score_CA_15,
					score_CB_16,of score_CB_20-score_CB_23,of score_CB_35-score_CB_38, score_CB_42,
					score_CC_44, score_CC_45, score_CC_49, score_CC_50, score_CC_54, score_CC_55, score_CC_57, score_CC_61, score_CC_62);
	IF miss_events in(0:9) THEN score_events_avg=score_events/(29-miss_events);
	IF miss_events in(0:9) THEN score_events_adjcount=score_events_avg*29;

	*D. Substance Use;
		if child_age_yr in(8:12) THEN child_age_8to12=1; ELSE child_age_8to12=0;
		if child_age_yr in(13:17) THEN child_age_13to17=1; ELSE child_age_13to17=0;

		*Six point (0 to 5) lifetime use scale from Kandel & Yamaguchi (1993) AJPH article
			0 = never use, add one for ever used for each type of use;
		miss_subst_life=0; miss_subst_othertot=0;
		IF D1=1 THEN score_life_cigs=1; ELSE IF D1=2 THEN score_life_cigs=0; ELSE miss_subst_life+1;
		IF D6=1 or (D6~=1 AND D7 in(2:7)) THEN score_life_alcohol=1; ELSE IF D6=2 or D7=1 THEN score_life_alcohol=0; ELSE miss_subst_life+1;
		IF D10=1 or (D10~=1 AND D11 in(2:6)) THEN score_life_marijuana=1; ELSE IF D10=2 or (D10~=1 AND D11=1) THEN score_life_marijuana=0; ELSE miss_subst_life+1;
		IF D12=1 or D13 in(2:6) THEN score_life_cocaine=1; ELSE IF D12=2 or (D12~=1 AND D13=1) THEN score_life_cocaine=0; ELSE miss_life_subst+1;
			*other drug subscores;
			IF D15=1 or D17 in(2:6) THEN score_life_inhalent=1; ELSE IF D15=2 or D17=1 THEN score_life_inhalent=0; ELSE miss_subst_othertot+1;
			IF D16=1 or D21 in(2:6) THEN score_life_steroids=1; ELSE IF D16=2 or D21=1 THEN score_life_steroids=0; ELSE miss_subst_othertot+1;
			IF D18 in(2:6) THEN score_life_heroin=1; ELSE IF D18=1 THEN score_life_heroin=0; ELSE miss_subst_othertot+1;
			IF D19 in(2:6) THEN score_life_meth=1; ELSE IF D19=1 THEN score_life_meth=0; ELSE miss_subst_othertot+1;
			IF D20 in(2:6) THEN score_life_ecstasy=1; ELSE IF D20=1 THEN score_life_ecstasy=0; ELSE miss_subst_othertot+1;
			IF D22 in(2:6) THEN score_life_prescrip=1; ELSE IF D22=1 THEN score_life_prescrip=0; ELSE miss_subst_othertot+1;
			IF D23 in(2:6) THEN score_life_needle=1; ELSE IF D23=1 THEN score_life_needle=0; ELSE miss_subst_othertot+1;

			score_life_othertot=sum(score_life_inhalent,score_life_steroids, score_life_heroin, score_life_meth, 
				score_life_ecstasy, score_life_prescrip, score_life_needle);

			IF score_life_othertot>0 THEN score_life_other=1; 
				ELSE IF (child_age_8to12=1 AND miss_subst_othertot>=2) or
						(child_age_13to17=1 AND miss_subst_othertot>=7) 
						THEN DO; score_life_other=.; miss_subst_life+1; END; /*Count as missing if missing all questions asked of their age group*/
				ELSE IF score_life_othertot=0 THEN score_life_other=0;
			 
		score_subst_life=sum(score_life_cigs, score_life_alcohol, score_life_marijuana, score_life_cocaine, score_life_other);
		IF miss_subst_life in(0,1) THEN score_subst_life_avg=score_subst_life / (5-miss_subst_life);

		*Five point recent use scale (0 to 4) from Kandel & Yamaguchi (1993) AJPH article
			0 = no recent use, plus one point for each type of use in past 30 days (alcohol, binge drinking, drinking and driving, marijuana, more extreme drugs rare);
		miss_subst_recent=0;
		IF D1=2 or (D2=1 AND D4=1 AND D5=1) THEN score_recent_cigs=0;
			ELSE IF D1=1 AND (D2 in(2:7) or D4 in(2:7) or D5 in(2:7)) THEN score_recent_cigs=1;
			ELSE miss_subst_recent+1;

			/*Why did we skip lifetime alcohol use for 13-17?*/
		IF D7 in(2:7) THEN score_recent_alcohol=1; ELSE IF D7=1 or D6=2 THEN score_recent_alcohol=0; ELSE miss_subst_recent+1;
		IF D8 in(2:7) THEN score_recent_binge=1; ELSE IF D8=1 or D7=1 or D6=2 THEN score_recent_binge=0; ELSE miss_subst_recent+1;
		IF D11 in(2:6) THEN score_recent_marijuana=1; ELSE IF D10=2 or D11=1 THEN score_recent_marijuana=0; ELSE miss_subst_recent+1;

		score_subst_recent=sum(score_recent_cigs, score_recent_alcohol, score_recent_binge, score_recent_marijuana);
		IF miss_subst_recent in(0,1) THEN score_subst_recent_avg=score_subst_recent/(4-miss_subst_recent);


		*Categorical variable:
			HIGH (2) = Binge Drinking/Cocaine ever in lifetime, 1+ per week or more on alcohol or marijuana  (including other substances doesn't add any more to high risk)
			LOW (0) = No substance use
			MODERATE (1) = Some use, but not more than cigarettes/alcohol/marijuana and less than 1x per week for alcohol/marijuana;

		/*high*/ IF D7 in(4:7) OR D8 in(2:7) OR  D11 in(4:6) OR D12=1 OR score_life_othertot>0 THEN score_subst_riskcat=3;
		/*mod*/  ELSE IF D2 in(2:7) OR D4 in(2:7) OR D5 in(2:7) OR D7 in(2:3) OR D11 in(2:3) THEN score_subst_riskcat=2;
		/*low*/  ELSE IF  (D1=2 or D2=1) AND D4=1 AND D5=1 AND (D6=2 OR D7=1) AND (D10=2 OR D11=1) THEN score_subst_riskcat=1;
			/*note: currently count age 8-12 that has had a lifetime drink but not in last 30 days as low risk*/

	*E. School -- no coding yet;
			*grades;
	IF E1 in(1:5) THEN nichd_score_grades=E1;

			*absenteeism;
	SELECT (E2);
		WHEN (0,1,2,3,4,5) nichd_absent_cat=E2;
		WHEN (6,7,8,9,10) nichd_absent_cat=6;
		WHEN (.,-1,-2) nichd_absent_cat=.;
		OTHERWISE nichd_absent_cat=7;
	END;

	*F. Involved Vigilant Parenting;
		*Note -- notes from Na Liu (Murray's research assistant) said to reverse code 11, 
			but question wording does not look life should be reverse coded so did not;
		ARRAY fa (20) FA_1-FA_10 FB_11-FB_20;
		ARRAY fas (20) score_FA_1-score_FA_10 score_FB_11-score_FB_20;

		DO i=1 to 20;
			IF i=1 THEN miss_vigilant=0;
			IF i in(1,2,7,8,10,11,12,13,14,15,16,17,18,19,20) THEN DO;
				IF fa[i] in(1:4) THEN fas[i]=fa[i];
				ELSE miss_vigilant+1;
			END;

			ELSE IF i in(3,4,5,6,9) THEN DO;
				IF fa[i]=1 THEN fas[i]=4;
				ELSE IF fa[i]=2 THEN fas[i]=3;
				ELSE IF fa[i]=3 THEN fas[i]=2;
				ELSE IF fa[i]=4 THEN fas[i]=1;
				ELSE miss_vigilant+1;
			END;
		END;

		score_vigilant=sum(of score_FA_1-score_FA_10, of score_FB_11-score_FB_20);
		IF miss_vigilant in(0:6) THEN score_vigilant_avg=score_vigilant/(20-miss_vigilant);

	*G. Children's Hope Scale;
		ARRAY gg (6) G_1-G_6;
		ARRAY ggs (6) score_G_1-score_G_6;

		DO i=1 to 6;
			IF i=1 THEN miss_hope=0;
			IF gg[i] in(1:5) THEN ggs[i]=gg[i];
			ELSE miss_hope+1;
		END;

		score_hope=sum(of score_G_1-score_G_6);
		IF miss_hope in(0,1,2) THEN score_hope_avg=score_hope / (6-miss_hope);

RUN;




ODS RTF FILE="E:\Family Options\Output\FO NICHD Survey Alphas_2014_04_10.doc";
*A. Trait Anxiety;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Trait Anxiety - Alphas";
	VAR score_AA_1-score_AA_10 score_AB_11-score_AB_20;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Trait Anxiety - Average Score (2/3 rule)";
	VAR score_traits_avg;
RUN;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Trait Anxiety - Frequencies";
	TABLES score_traits miss_traits AA_1-AA_10 AB_11-AB_20 ;
RUN;

*B. FEARS;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Fears - Alphas";
	VAR score_BA_1-score_BA_11 score_BB_12-score_BB_22 score_BC_23-score_BC_33;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Fears - Average Score (2/3 rule)";
	VAR score_fears_avg;
RUN;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Fears - Frequencies";
	TABLES score_fears miss_fears BA_1-BA_11 BB_12-BB_22 BC_23-BC_33 ;
RUN;


*C. LIFE EVENTS;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Life Events - Alphas";
	VAR score_CA_1 score_CA_2 score_CA_5 score_CA_6 score_CA_10-score_CA_15
					score_CB_16 score_CB_20-score_CB_23 score_CB_35-score_CB_38 score_CB_42
					score_CC_44 score_CC_45 score_CC_49 score_CC_50 score_CC_54 score_CC_55 score_CC_57 score_CC_61 score_CC_62;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Life Events - Average Score (2/3 rule)";
	VAR score_events_avg;
RUN;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Life Events - Frequencies";
	TABLES score_events miss_events CA_1 CA_2 CA_5 CA_6 CA_10-CA_15
					CB_16 CB_20-CB_23 CB_35-CB_38 CB_42
					CC_44 CC_45 CC_49 CC_50 CC_54 CC_55 CC_57 CC_61 CC_62;
RUN;


*D. SUBSTANCE USE;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Substance Use: Lifetime - Alphas";
	VAR score_life_cigs score_life_alcohol score_life_marijuana score_life_cocaine score_life_other;
RUN;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Substance Use: Recent - Alphas";
	VAR score_recent_cigs score_recent_alcohol score_recent_binge score_recent_marijuana;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Substance Use: Lifetime and Recent - Average Score (2/3 rule)";
	VAR score_subst_life_avg score_subst_recent_avg;
RUN;



*E. SCHOOL;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Education Outcomes - Frequencies";
	TABLES E1 E2 E3_1 E3_2 E3_3 E3_4 E4_1 E5_2;
RUN;



*F. INVOLVED-VIGILANT PARENTING;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Involved-Vigilant Parenting - Alphas";
	VAR score_FA_1-score_FA_10 score_FB_11-score_FB_20;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Involved-Vigilant Parenting - Average Score (2/3 rule)";
	VAR score_vigilant_avg;
RUN;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Involved-Vigilant Parenting - Frequencies";
	TABLES score_vigilant miss_vigilant FA_1-FA_10 FB_11-FB_20 ;
RUN;

*G. CHILDREN'S HOPE;
PROC CORR DATA=nichd.s11_18mo_chsurv_vand_140331_scr ALPHA NOMISS;
	TITLE "Children's HOPE - Alphas";
	VAR score_G_1-score_G_6;
RUN;

PROC UNIVARIATE DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Children's HOPE - Average Score (2/3 rule)";
	VAR score_hope_avg;
RUN;
PROC FREQ DATA=nichd.s11_18mo_chsurv_vand_140331_scr;
	TITLE "Children's HOPE - Frequencies";
	TABLES score_hope miss_hope G_1-G_6;
RUN;

ODS RTF CLOSE;


/***** WOODCOCK-JOHNSON III DATA   ******/


OPTIONS FMTSEARCH=(nichd) NOFMTERR;
