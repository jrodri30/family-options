/*************************************************************************************************************************//*
         
Program Name: A21_hf_18mo_childsurv_assess_scoring.sas
Path:	      
Ancestor:     
Project:      HomeFam
Programmer:   Steven Brown 
Inputs: 	  S:\Projects\Homefam\01_DATA\00_ORIGDAT_WITH_PII\06_CHILD_SURVEY_WITH_PII\03_FINAL_CHILDSURVEY\a33_homeless_child_fcstat_140401.sas7bdat
			 			  
Outputs:      S:\Projects\Homefam\01_DATA\00_ORIGDAT_WITH_PII\06_CHILD_SURVEY_WITH_PII\03_FINAL_CHILDSURVEY\A21_hf_18mo_childsurv_scored_&yymmdd
			  
Purpose:      Score the assessments in the child survey. 
			  
Note:         After an email exchange between Danny Gubits and Beth Shinn on 3/25/14, we have decided to use 2/3 rule for all assessments with 
			  less established documentation/rules. ASQ and WJIII would be examples of assessments with well-established documentation and rules. 
			  The assessments in the child survey are assessments WITHOUT those well-established documentation and rules. Thus, all of the 
			  assessments here use the 2/3 rule for dealing with incomplete assessments (meaning any assessments that are at least 2/3 complete
			  are scored. When the assessments are incomplete, we take the average score or the score of the answered questions multiplied by 
			  (# questions / (# questions - # missing)), whichever appropriate. 

Created On:   	03/18/2014                                                                       

Edit History: 	03/31/2014 (took out the code that created FC_STATUS in this file and created program A33)


*//************************************************************************************************************************/


LIBNAME chldsurv "S:\Projects\Homefam\01_DATA\00_ORIGDAT_WITH_PII\06_CHILD_SURVEY_WITH_PII\03_FINAL_CHILDSURVEY"; 
LIBNAME library  "S:\Projects\Homefam\01_DATA\00_ORIGDAT_WITH_PII\06_CHILD_SURVEY_WITH_PII\03_FINAL_CHILDSURVEY";
LIBNAME rost     "S:\Projects\Homefam\01_DATA\00_ORIGDAT_WITH_PII\05_18MO_FOLLOWUP_WITH_PII\04_COMPLETE_FINAL_ROSTER";

OPTIONS fmtsearch=(library.child_formats_abt); 
OPTIONS nofmterr; 

%LET yymmdd=%SYSFUNC(PUTN(%SYSFUNC(DATE()),yymmdd6.));


*************************
/* Program Strategy */*

1) Bring in child survey data with FC_STATUS included 
2) Score Trait-Anxiety
3) Score Life Events (2/3 scale for missing values)
4) Score Children's Hope Scale (2/3 scale for missing values) 
*/*********************/*; 




/* 1: Bring in child survey data with FC_STATUS included */ 
***********************************************************; 
DATA childsurv_temp; 
	SET chldsurv.A33_homeless_child_fcstat_140401; 
RUN; 

PROC SORT DATA=childsurv_temp; BY family_id; RUN; 
PROC CONTENTS DATA=childsurv_temp VARNUM;    RUN; 



/* 2: Score Trait-Anxiety */ 
** DOCUMENTATION: Childrens State Trait Anxiety Measure.pdf
** DOC LOCATION: S:\Homefam\02_DOCUMENTATION\03_ANALYSIS_DATA_DOC\02_18MO_REPORT_DOC\06_CHILDWB_DOC\07_TRAITS-fromMindGarden-Proprietary
** SCORING RULE: Sum of values (value range: 1-3, number of question: 20, score range: 20-60, higher scores indicate more Trait-Anxiety) 
*********************************************; 
TITLE1 "PROC FREQ of Trait-Anxiety Questions";
PROC FREQ DATA=childsurv_temp; 
	TABLE AA_1 -- AB_20; 
RUN; 
TITLE1 ;

DATA childsurv_score1; 
	SET childsurv_temp; 
	ARRAY Traits (20) AA_1  AA_2  AA_3  AA_4  AA_5  AA_6  AA_7  AA_8  AA_9  AA_10
	                  AB_11 AB_12 AB_13 AB_14 AB_15 AB_16 AB_17 AB_18 AB_19 AB_20; 
	ARRAY Traits_temp (20) AA_1_temp  AA_2_temp  AA_3_temp  AA_4_temp  AA_5_temp  AA_6_temp  AA_7_temp  AA_8_temp  AA_9_temp  AA_10_temp
			               AB_11_temp AB_12_temp AB_13_temp Ab_14_temp AB_15_temp AB_16_temp AB_17_temp AB_18_temp AB_19_temp AB_20_temp;

	traits_78cnt = 0;		/* Count of refused and DKs in Trait variables */
	DO i = 1 TO 20; 
		IF Traits(i) in (7,8) THEN traits_78cnt = traits_78cnt + 1; 
		IF Traits(i) in (1,2,3) THEN Traits_temp(i) = Traits(i);
	END;
	
	ATTRIB traits_78cnt LABEL= "Count of refused and DKs in Trait variables"; 
RUN; 


TITLE1 "PROC FREQ of Trait variables to be scored (values 1-3)"; 
PROC FREQ DATA=childsurv_score1; 
	TABLE AA_1_temp -- AA_10_temp; 
RUN; 
TITLE1 "Count of refused and DKs in Trait variables"; 
PROC FREQ DATA=childsurv_score1; 
	TABLE traits_78cnt; 
RUN; 
TITLE1; 


***** SCORING DATA *****; 

DATA childsurv_score2;
	SET childsurv_score1;
	IF traits_78cnt = 0 THEN Traits_totalscore = SUM(OF AA_1_temp -- AB_20_temp); 
	IF 1 <= traits_78cnt <= 6 THEN Traits_totalscore = ((SUM(OF AA_1_temp -- AB_20_temp)) * (20/(20-traits_78cnt))); 

	ATTRIB Traits_totalscore LABEL= "Traits-Anxiety Total Score"; 
	
	DROP AA_1_temp -- AB_20_temp i; 
RUN; 

TITLE1 "MIN Possible score: 20 - MAX Possible score: 60"; 
TITLE2 "Higher scores indicate more Trait-Anxiety"; 
PROC SUMMARY DATA=childsurv_score2 N NMISS MEAN STD MIN MAX PRINT; 
	VAR Traits_totalscore; 
RUN; 
TITLE1 ;
TITLE2 ; 

PROC CONTENTS DATA=childsurv_score2 VARNUM; RUN; 




/* 3: Score Life Events */ 
** DOCUMENTATION: 1994-Masten-JResAdol.pdf
** DOC LOCATION: S:\Homefam\02_DOCUMENTATION\03_ANALYSIS_DATA_DOC\02_18MO_REPORT_DOC\06_CHILDWB_DOC\05_LIFE_EVENTS
** SCORING RULE: Values should be Yes = 1, No = 0. Sum of Yes answers. Three mutually-exclusive subscores come from 29 questions. No total/overall score. 
** NOTE: Questions 57 and 58 from the Matsen article seem to be combined into one question in the survey, CC_57 
*********************************************; 
TITLE1 "PROC FREQ of Life Events questions";
PROC FREQ DATA=childsurv_score1; 
	TABLE CA_1 -- CC_62; 
RUN; 
TITLE1 ;

DATA childsurv_score3_temp; 	/* CC_46 seems to be incorrectly numbered in the dataset. Should be CC_49 according to Matsen et al article (pg 79-80) */
	SET childsurv_score2; 
	ATTRIB CC_46 LABEL= "CC_49 [focal child]: There were many arguments between adults living in the house during this past year"; 
	RENAME CC_46 = CC_49;   
RUN; 

DATA childsurv_score3;
	SET childsurv_score3_temp; 
	ARRAY LifeEvents (29) CA_1  CA_2  CA_5  CA_6  CA_10 CA_11 CA_12 CA_13 CA_14 CA_15
	                      CB_16 CB_20 CB_21 CB_22 CB_23 CB_35 CB_36 CB_37 CB_38 CB_42
						  CC_44 CC_45 CC_49 CC_50 CC_54 CC_55 CC_57 CC_61 CC_62      ; 
	ARRAY LifeEvents_temp (29) CA_1_temp  CA_2_temp  CA_5_temp  CA_6_temp  CA_10_temp CA_11_temp CA_12_temp CA_13_temp CA_14_temp CA_15_temp
	                           CB_16_temp CB_20_temp CB_21_temp CB_22_temp CB_23_temp CB_35_temp CB_36_temp CB_37_temp CB_38_temp CB_42_temp
						       CC_44_temp CC_45_temp CC_49_temp CC_50_temp CC_54_temp CC_55_temp CC_57_temp CC_61_temp CC_62_temp           ; 
							   
	lifeevents_78cnt = 0; 		/* Count of refused and DKs in Life Event variables */
	DO i = 1 TO 29; 
		IF LifeEvents(i) in (7,8) THEN lifeevents_78cnt = lifeevents_78cnt + 1;
		IF LifeEvents(i) in (1,2) THEN LifeEvents_temp(i)  = LifeEvents(i); 
		IF LifeEvents_temp(i) = 2 THEN LifeEvents_temp(i) = 0; 		/*  Questions are Yes/No and should have values 1/0 to be scored */ 
	END; 
	
	ARRAY DNI (17) CA_5  CA_6  CA_10 CA_11 CA_12 CA_13 CA_14 CA_15 
	               CB_20 CB_21 CB_22 CB_37 CC_44 CC_45 CC_54 CC_61 CC_62;
	ARRAY CNI (6)  CB_36 CB_42 CC_49 CC_50 CC_55 CC_57;
	
	ARRAY DAI (6)  CA_1 CA_2 CB_16 CB_23 CB_35 CB_38;
	
	lifeevents_DNI_78cnt = 0;
	lifeevents_CNI_78cnt = 0;
	lifeevents_DAI_78cnt = 0;
	DO i = 1 TO 17; 
		IF DNI(i) in (7,8) THEN lifeevents_DNI_78cnt = lifeevents_DNI_78cnt + 1; 
	END; 
	DO i = 1 TO 6; 
		IF CNI(i) in (7,8) THEN lifeevents_CNI_78cnt = lifeevents_CNI_78cnt + 1; 
	END; 
	DO i = 1 TO 6; 
		IF DAI(i) in (7,8) THEN lifeevents_DAI_78cnt = lifeevents_DAI_78cnt + 1; 
	END; 
	
	ATTRIB lifeevents_78cnt LABEL= "Count of refused and DKs in all Life Event variables";
	ATTRIB lifeevents_DNI_78cnt LABEL= "Count of refused and DKs in Life Event Discrete-Negative-Independent (DNI) variables";
	ATTRIB lifeevents_CNI_78cnt LABEL= "Count of refused and DKs in Life Event Chronic-Negative-Independent (CNI) variables";
	ATTRIB lifeevents_DAI_78cnt LABEL= "Count of refused and DKs in Life Event Discrete-Ambiguous-Independent (DAI) variables";
RUN; 


TITLE1 "PROC FREQ of Life Event variables to be scored"; 
PROC FREQ DATA=childsurv_score3; 
	TABLE CA_1_temp -- CC_62_temp; 
RUN; 
TITLE1 "Count of refused and DKs in Life Event variables"; 
TITLE2 "Note: Only ~half of the children provided scorable answers on all 29 questions";
PROC FREQ DATA=childsurv_score3; 
	TABLE lifeevents_78cnt; 
RUN; 
TITLE2 "Note: 914 (96.2%) provided scorable answers on at least 12 questions (2/3 of 17 total)";
PROC FREQ DATA=childsurv_score3; 
	TABLE lifeevents_DNI_78cnt; 
RUN; 
TITLE2 "Note: 868 (91.4%) provided scorable answers on at least 4 questions (2/3 of 6 total)";
PROC FREQ DATA=childsurv_score3; 
	TABLE lifeevents_CNI_78cnt; 
RUN; 
TITLE2 "Note: 926 (97.5%) provided scorable answers on at least 4 questions (2/3 of 6 total)";
PROC FREQ DATA=childsurv_score3; 
	TABLE lifeevents_DAI_78cnt; 
RUN; 
TITLE1 ;
TITLE2 ;


***** SCORING DATA *****; 

PROC SORT DATA=childsurv_score3; 
	BY family_id lifeevents_78cnt; 
RUN; 

DATA childsurv_score4; 
	SET childsurv_score3; 
	
	/* Discrete-Negative-Independent Score */
	IF lifeevents_DNI_78cnt = 0 THEN	
	Events_DNI_score = SUM(CA_5_temp, CA_6_temp, CA_10_temp, CA_11_temp, CA_12_temp, CA_13_temp, CA_14_temp, CA_15_temp, 
	                       CB_20_temp, CB_21_temp, CB_22_temp, CB_37_temp, CC_44_temp, CC_45_temp, CC_54_temp, CC_61_temp, CC_62_temp); 
	IF 1 <= lifeevents_DNI_78cnt <= 5 THEN
	Events_DNI_score = ((SUM(CA_5_temp, CA_6_temp, CA_10_temp, CA_11_temp, CA_12_temp, CA_13_temp, CA_14_temp, CA_15_temp, 
	                       CB_20_temp, CB_21_temp, CB_22_temp, CB_37_temp, CC_44_temp, CC_45_temp, CC_54_temp, CC_61_temp, CC_62_temp)) * (17/(17-lifeevents_DNI_78cnt))); 
	
	/* Chronic-Negative-Independent Score */
	IF lifeevents_CNI_78cnt = 0 THEN	
	Events_CNI_score = SUM(CB_36_temp, CB_42_temp, CC_49_temp, CC_50_temp, CC_55_temp, CC_57_temp); 
	IF lifeevents_CNI_78cnt in (1,2) THEN 
	Events_CNI_score = ((SUM(CB_36_temp, CB_42_temp, CC_49_temp, CC_50_temp, CC_55_temp, CC_57_temp)) * (6/(6-lifeevents_CNI_78cnt)));
	
	/* Discrete-Ambiguous-Independent Score */ 
	IF lifeevents_DAI_78cnt = 0 THEN
	Events_DAI_score = SUM(CA_1_temp, CA_2_temp, CB_16_temp, CB_23_temp, CB_35_temp, CB_38_temp); 
	IF lifeevents_DAI_78cnt in (1,2) THEN 
	Events_DAI_score = ((SUM(CA_1_temp, CA_2_temp, CB_16_temp, CB_23_temp, CB_35_temp, CB_38_temp)) * (6/(6-lifeevents_DAI_78cnt)));
	
	ATTRIB Events_DNI_score LABEL= "Life Events Discrete-Negative-Independent (DNI) Score / C Vars included: 5, 6, 10-15, 20-22, 37, 44, 45, 54, 61, 62"; 
	ATTRIB Events_CNI_score LABEL= "Life Events Chronic-Negative-Independent (CNI) Score / C Vars included: 36, 42, 49, 50, 55, 57"; 
	ATTRIB Events_DAI_score LABEL= "Life Events Discrete-Ambiguous-Independent (DAI) Score / C Vars included: 1, 2, 16, 23, 35, 38"; 
	
	DROP CA_1_temp -- CC_62_temp i; 
RUN; 

TITLE1 "MIN Possible score: 0 - MAX Possible score: 17"; 
TITLE2 "Higher scores indicate higher incidence of negative or ambiguous events in the past year"; 
PROC SUMMARY DATA=childsurv_score4 N NMISS MEAN STD MIN MAX PRINT; 
	VAR Events_DNI_score; 
RUN; 

TITLE1 "MIN Possible score: 0 - MAX Possible score: 6";
TITLE2 "Higher scores indicate higher incidence of negative or ambiguous events in the past year"; 
PROC SUMMARY DATA=childsurv_score4 N NMISS MEAN STD MIN MAX PRINT; 
	VAR Events_CNI_score; 
RUN; 

TITLE2 "Higher scores indicate higher incidence of negative or ambiguous events in the past year"; 
PROC SUMMARY DATA=childsurv_score4 N NMISS MEAN STD MIN MAX PRINT; 
	VAR Events_DAI_score; 
RUN; 
TITLE1 ;
TITLE2 ; 

PROC CONTENTS DATA=childsurv_score4 VARNUM; RUN; 




/* 4: Score Children's Hope Scale */ 
** DOCUMENTATION: 1997-Snyder_etal-JPedPsych.pdf
** DOC LOCATION: S:\Homefam\02_DOCUMENTATION\03_ANALYSIS_DATA_DOC\02_18MO_REPORT_DOC\06_CHILDWB_DOC\06_CHILDRENS_HOPE_SCALE
** SCORING RULE: Sum of values (value range: 1-5, number of question: 5, score range: 6-30, higher scores indicate more hope and optimism) 
*********************************************; 
TITLE1 "PROC FREQ of Children's Hope Scale variables";
PROC FREQ DATA=childsurv_score4; 
	TABLE G_1 - G_6; 
RUN;
TITLE1 ; 

DATA childsurv_score5; 
	SET childsurv_score4; 
	ARRAY Hope (6) G_1 G_2 G_3 G_4 G_5 G_6; 
	ARRAY Hope_temp (6) G_1_temp G_2_temp G_3_temp G_4_temp G_5_temp G_6_temp; 

	hope_78cnt = 0;
	DO i = 1 TO 6; 
		IF Hope(i) in (7,8) THEN hope_78cnt = hope_78cnt + 1; 
		IF Hope(i) in (1,2,3,4,5) THEN Hope_temp(i) = Hope(i);		/* Note: In the Snyder et al article, the Hope scale has 6 options and goes from 1-6. Our survey has 5 options and goes from 1-5. The valence is the same */ 
	END; 
	
	ATTRIB hope_78cnt LABEL= "Count of refused and DKs in Hope Scale variables";
RUN;

TITLE1 "PROC FREQ of Hope Scale variables to be scored"; 
PROC FREQ DATA=childsurv_score5; 
	TABLE G_1_temp -- G_6_temp; 
RUN; 
TITLE1 "Count of refused and DKs in Hope Scale variables"; 
TITLE2 "Note: 901 (94.8%) provided scorable answers on at least 4 questions (2/3 of 6 total)";
PROC FREQ DATA=childsurv_score5; 
	TABLE hope_78cnt; 
RUN;
TITLE1 ;
TITLE2 ; 


***** SCORING DATA *****; 

PROC SORT DATA=childsurv_score5; 
	BY family_id hope_78cnt; 
RUN; 

DATA childsurv_score6;
	SET childsurv_score5;
	
	IF hope_78cnt = 0 THEN
	Hope_totalscore = SUM(G_1_temp, G_2_temp, G_3_temp, G_4_temp, G_5_temp, G_6_temp); 
	IF hope_78cnt in (1,2) THEN
	Hope_totalscore = ((SUM(G_1_temp, G_2_temp, G_3_temp, G_4_temp, G_5_temp, G_6_temp)) * (6/(6-hope_78cnt))); 
	
	ATTRIB Hope_totalscore LABEL= "Children's Hope Scale Total Score";
	
	DROP G_1_temp -- G_6_temp i; 
RUN; 

TITLE1 "MIN Possible score: 6 - MAX Possible score: 30"; 
TITLE2 "Higher scores indicate more hope and optimism"; 
PROC SUMMARY DATA=childsurv_score6 N NMISS MEAN STD MIN MAX PRINT; 
	VAR Hope_totalscore; 
RUN; 
TITLE1 ; 
TITLE2 ;

PROC CONTENTS DATA=childsurv_score6 VARNUM; RUN;


**********; 


PROC FREQ DATA=childsurv_score6; 
	TABLE fc_status; 
RUN; 

DATA childsurv_retain; 
	RETAIN family_id fc_status 
		   MODE SC1_ SC1_1 LAND INTERVIEW_END FC_NAME CHILD_AGE CONSENT
		   AA_1 AA_2 AA_3 AA_4 AA_5 AA_6 AA_7 AA_8 AA_9 AA_10
		   AB_11 AB_12 AB_13 AB_14 AB_15 AB_16 AB_17 AB_18 AB_19 AB_20
		   Traits_totalscore traits_78cnt
		   BA_1 BA_2 BA_3 BA_4 BA_5 BA_6 BA_7 BA_8 BA_9 BA_10 BA_11
		   BB_12 BB_13 BB_14 BB_15 BB_16 BB_17 BB_18 BB_19 BB_20 BB_21 BB_22
		   BC_23 BC_24 BC_25 BC_26 BC_27 BC_28 BC_29 BC_30 BC_31 BC_32 BC_33
		   CA_1  CA_2  CA_5  CA_6  CA_10 CA_11 CA_12 CA_13 CA_14 CA_15
	       CB_16 CB_20 CB_21 CB_22 CB_23 CB_35 CB_36 CB_37 CB_38 CB_42
		   CC_44 CC_45 CC_49 CC_50 CC_54 CC_55 CC_57 CC_61 CC_62
		   Events_DNI_score Events_CNI_score Events_DAI_score
		   lifeevents_78cnt lifeevents_DNI_78cnt lifeevents_CNI_78cnt lifeevents_DAI_78cnt
		   D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D20 D21 D22 D23
		   E1 E2 E3_1 E3_2 E3_3 E3_4 E4_1 E5_2
		   FA_1 FA_2 FA_3 FA_4 FA_5 FA_6 FA_7 FA_8 FA_9 FA_10
		   FB_11 FB_12 FB_13 FB_14 FB_15 FB_16 FB_17 FB_18 FB_19 FB_20 
		   G_1 G_2 G_3 G_4 G_5 G_6 
		   Hope_totalscore hope_78cnt;		   
	SET childsurv_score6;
RUN;

PROC CONTENTS DATA=childsurv_retain VARNUM;    RUN; 
PROC SORT DATA=childsurv_retain; BY family_id; RUN; 


DATA chldsurv.A21_18mo_childsurv_scored_&yymmdd; 
	SET childsurv_retain; 
RUN; 







