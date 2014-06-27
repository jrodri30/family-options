/*

Title: Child Educational Outcomes Analysis Preparation
Program: s02i_EducOutcomes_Prep_2014_06_26_jmr.sas
Programmer: Jason Rodriguez
Created Date: 6/25/2014
Last Updated: 6/25/2014

Input Datasets: fam18m.s02_18mo_fc_whome

Purpose: Engage in various tasks related to variable creation and data quality.
1) Create new variables related to education status.
2) Determine if school vacations contribute to bias in educational outcomes.
3) Explore age of child by grade completion and child care variables.

*/

*18 month adult survey source;
LIBNAME fam18m "E:\Family Options\Data\02_18MonthData";

OPTIONS NOFMTERR;

PROC CONTENTS DATA=fam18m.s02_18mo_fc_whome;
RUN;

/*PART 1: Create new variables related to child education status */
DATA s02_18mo_fc_whome_2;
	SET fam18m.s02_18mo_fc_whome;
	*Create a dummy variable indicating summer interview;
	IF month(TEST_DATE) in (6:8) THEN summerinterview=1;
		ELSE summerinterview=0; 
	*Create a dummy variable for school enrollment = "No";
	IF F6=2 THEN enrolled_no=1;
		ELSE IF F6 in (1,3,4,5) THEN enrolled_no=0;
	*Create a "schoolvacation" proxy variable that considers both the interview date and the parent response to F6.;
	IF F6=4 OR month(TEST_DATE) in (6:8) THEN schoolvacation=1;
		ELSE IF F6 in (1,2,3,5) THEN schoolvacation=0;
	*Create dummy variable for children who are enrolled in school;
	IF F6 in (3,4) or F8 in (2:15) THEN enrolled_school=1;
		ELSE IF F6 in (2,5) or F8=1 THEN enrolled_school=0;
	IF F8=1 THEN enrolled_childcare=1;
		ELSE IF F6 in (2:5) or F8 in (2:15) then enrolled_childcare=0;
	*Format educational outcomes;
	F10A1_2=INPUT(F10A1,8.);
	F12A1_2=INPUT(F12A1,8.);
	F13A1_2=INPUT(F13A1,8.);
RUN;

/*PART 2: Look to see whether child school vacation status results in biased educational outcomes */
ODS RTF;
/*Crosstabs of educational outcomes by child school vacation status */
TITLE "Crosstabs of educational outcomes by child's vacation status";
PROC FREQ DATA=s02_18mo_fc_whome_2;
	TABLES 
	    enrolled_no*summerinterview
		F6*schoolvacation
		F10*schoolvacation
		F10A1_2*schoolvacation
		F12A1_2*schoolvacation
		F13A1_2*schoolvacation
		/ NOPERCENT NOROW;
	*WHERE AGE_YEAR_recalc >=6;
RUN;

/*Histograms of educational outcomes */
PROC SORT DATA=s02_18mo_fc_whome_2;
	BY schoolvacation;
TITLE1 "Number of child care arrangements or schools attended for at least 10 hrs/wk";
TITLE2 "by child vacation status";
PROC SGPANEL DATA=s02_18mo_fc_whome_2;
	PANELBY schoolvacation;
	HISTOGRAM F10A1_2;
	WHERE F10A1_2>=0;
RUN;
TITLE1 "Number of schools attended";
TITLE2 "by child vacation status";
PROC SGPANEL DATA=s02_18mo_fc_whome_2;
	PANELBY schoolvacation;
	HISTOGRAM F12A1_2;
	WHERE F12A1_2>=0;
RUN;
TITLE1 "Number of days in the past month that child missed school";
TITLE2 "by child vacation status";
PROC SGPANEL DATA=s02_18mo_fc_whome_2;
	PANELBY schoolvacation;
	HISTOGRAM F13A1_2;
	WHERE F13A1_2>=0;
RUN;

/*PART 3: Explore age of child by grade completion and child care variables */
TITLE "Crosstabs of age- and education-related variables";
PROC MEANS DATA=s02_18mo_fc_whome_2;
	VAR
		enrolled_childcare
		enrolled_school
		;
	WHERE AGE_YEAR_recalc in (3:7);
	CLASS AGE_MONT_recalc;
	OUTPUT OUT=child_school_enrolls MEAN(enrolled_school)=enrolled_school_pct MEAN(enrolled_childcare)=enrolled_childcare_pct;
RUN;

TITLE "School and child care enrollment rates by age";
PROC SGPLOT DATA=child_school_enrolls;
	SERIES X=AGE_MONT_recalc Y=enrolled_childcare_pct;
	SERIES X=AGE_MONT_recalc Y=enrolled_school_pct;
	YAXIS LABEL="Proportion of children enrolled";
	XAXIS GRID VALUES=(48 to 96 by 2);
	LABEL enrolled_school_pct="School";
	LABEL enrolled_childcare_pct="Child care";
RUN;


ODS RTF CLOSE;
