/*

Title: s02f_Diagnostics_2014_03_26_sb
Purpose: Diagnostic exploratory work for scored 18 month datasets

Input datasets:
Output datasets:
Output files:

This is scott's update

*/


LIBNAME fam18m "E:\Family Options\Data\02_18MonthData";
LIBNAME htks "E:\Family Options\Data\04_18MonthHTKSData";
LIBNAME aands "E:\Family Options\Data\05_18MonthAgesAndStagesData";
%LET expdir="E:\Family Options\Output\Diagnostics";

OPTIONS FMTSEARCH=(fam18m htks aands) NOFMTERR;



/*****************************************************/
/*******   18 Month Parent Survey Dataset    *********/
/*******     and HOME Observational Data     *********/
/*****************************************************/
OPTIONS FMTSEARCH=(fam18m) NOFMTERR;









/*****************************************************/
/*******	   			HTKS Data		     *********/
/*****************************************************/
OPTIONS FMTSEARCH=(htks) NOFMTERR;









/*****************************************************/
/*******	   			ASQ DATA		     *********/
/*****************************************************/
OPTIONS FMTSEARCH=(aands) NOFMTERR;

*Check extreme z-scores
	-1. Check scoring process
	-2. Cross check for disabilities? (may not be able to yet...);

PROC CONTENTS DATA=aands.s05_18mo_ages_vand_140227_scr; RUN;

ODS TAGSETS.EXCELXP STYLE=NormalPrinter FILE="E:\Family Options\Output\Diagnostics\ASQ Low Average Scores.xls";
PROC PRINT DATA=aands.s05_18mo_ages_vand_140227_scr;
	WHERE AGES_zscore_avgdomain<=-3 AND AGES_zscore_avgdomain~=.;
RUN;
ODS TAGSETS.EXCELXP CLOSE;
RUN;





/****** WJIII DATA     ******/



DATA wjiii.s09_18mo_wjiii_vand_140331_scr;
	SET wjiii.s09_18mo_wjiii_vand_140331;

	*transform character vars to numeric;
		*verbal;
	lw_ss=var577*1;
	IF var578="<0.1" THEN lw_pr=0;
		ELSE IF var578=">99.9" THEN lw_pr=100;
		ELSE IF var578=" " THEN lw_pr=.;
		ELSE lw_pr=var578*1;
	/*do we need to transform var579 age equivalent -- change to yrs or months?*/
	IF var580="<0.0" THEN lw_grade=0.0; 
		ELSE IF var580=" " THEN lw_grade=.;
		ELSE lw_grade=var580*1;
	lw_zscore=var581*1;
	lw_wscore=var582*1;
		*numeric;
	ap_ss=var631*1;
	IF var632="<0.1" THEN ap_pr=0;
		ELSE IF var632=">99.9" THEN ap_pr=100;
		ELSE IF var632=" " THEN ap_pr=.;
		ELSE ap_pr=var632*1;
	/*do we need to transform var633 age equivalent -- change to yrs or months?*/
	IF var634="<0.0" THEN ap_grade=0.0; 
		ELSE IF var634=" " THEN ap_grade=.;
		ELSE ap_grade=var634*1;
	ap_zscore=var635*1;
	ap_wscore=var636*1;
	
	

	LABEL
	lw_ss="Letter-Word Identification SS (scaled score)"
	lw_pr="Letter-Word Identification PR (percentile score)"
	lw_grade="Letter-Word Identification Grade Equivalent"
	lw_zscore="Letter-Word Identification Z Score"
	lw_wscore="Letter-Word Identification W Score"

	ap_ss="Applied Problems Identification SS (scaled score)"
	ap_pr="Applied Problems Identification PR (percentile score)"
	ap_grade="Applied Problems Identification Grade Equivalent"
	ap_zscore="Applied Problems Identification Z Score"
	ap_wscore="Applied Problems Identification W Score"
	;

RUN;




PROC FREQ DATA=wjiii.s09_18mo_wjiii_vand_140331_scr;
	TITLE "WJIII Frequencies";
	TABLES CHILD_AGE FCSTATUS GENDER var577-var582 var631-var636;
RUN;

*by age;
PROC FREQ DATA=wjiii.s09_18mo_wjiii_vand_140331_scr;
	TITLE "WJIII gender and score by age";
	TABLES CHILD_AGE*(GENDER /*var577-var582 var631-var636*/);
RUN;

*by age and gender;
PROC FREQ DATA=wjiii.s09_18mo_wjiii_vand_140331_scr;
	TITLE "WJIII Scores: Boys";
	WHERE GENDER=;
	TABLES CHILD_AGE*(var577-var582 var631-var636);
RUN;
PROC FREQ DATA=wjiii.s09_18mo_wjiii_vand_140331_scr;
	TITLE "WJIII Scores: Girls";
	WHERE GENDER= ;
	TABLES CHILD_AGE*(var577-var582 var631-var636);
RUN;
