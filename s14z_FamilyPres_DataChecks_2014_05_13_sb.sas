/*
Exploration of bases and calculations for fam pres outcomes



*/

OPTIONS NOFMTERR;

*s14_fam_pres_impacts_140506_sb;

*Missingness Analysis;
	*#1: How many total families are in the preservation file?
			7 families of the 1877 completed 18 month surveys missing;
PROC MEANS DATA=SASUSER.s14_fam_preservation_vand_140504 NOPRINT MISSING;
	BY id_fam_vand;
	OUTPUT OUT=temp1 N(id_fam_vand)=tot_people;
RUN;
	*#2: Did not have at least one member of household listed as
			spouse/partner/child or grandchild
		8 families had children present listed under alternate coding;
PROC MEANS DATA=SASUSER.s14_fam_preservation_vand_140504 NOPRINT MISSING;
	WHERE b_relat in(1,2,3,4,14);
	BY id_fam_vand;
	OUTPUT OUT=temp1a N(id_pers_num_vand)=tot_people ;
RUN;

PROC SQL;
	SELECT A.id_fam_vand, B.tot_people
	FROM SASUSER.s14_fam_preservation_vand_140504 A 
		LEFT JOIN temp1a B ON A.id_fam_vand=B.id_fam_vand
	HAVING B.tot_people=.;
QUIT;

PROC PRINT DATA=s14_fampres_temp; 
	WHERE id_fam_vand in(2173, 2771, 2862, 2877, 2984, 3087, 3257, 3259);
	VAR id_fam_vand b_relat b_present b_age b_child f18_b1a;
RUN;


*ANALYSIS on missing f18_b1a -- does it exclude these families entirely
   from the analysis?;
PROC PRINT DATA=SASUSER.s14_fam_preservation_vand_140504;
	WHERE f18_b1a not in(1,2);
RUN;
PROC PRINT DATA=s14_fampres_temp;
	WHERE id_fam_vand in(1015, 1052, 1254,1303,1461,1505,1939,1984,2025,
		2066, 2281, 2549, 2717, 2788, 2928, 3018, 3243);
	VAR id_fam_vand b_relat b_present b_age b_child f18_b1a;
RUN;






/*Read in data*/
DATA s14_fampres_temp;
	SET SASUSER.s14_fam_preservation_vand_140504;

	/*Create dummy variables*/
	*with or not with family at 18 months;
	IF f18_b1a=2 THEN f18_notwith=1; ELSE IF f18_b1a=1 THEN f18_notwith=0;
	IF f18_b1a=1 THEN f18_with=1; ELSE IF f18_b1a=2 THEN f18_with=0;

	*with family but separated within the last 6 months;
	IF f18_d16=2 THEN f18_seplast6=0; ELSE IF f18_d16=1 THEN f18_seplast6=1;

	*foster care placements: now and within last 6 months;
	IF b_age in(0:16) THEN DO; 
		IF f18_d6b in(2,4,6) THEN f18_foster_nw=1; ELSE IF f18_notwith=1 THEN f18_foster_nw=0;
		IF f18_d18b in(2,4,6) THEN f18_foster_last6=1; ELSE IF f18_with=1 THEN f18_foster_last6=0;
	END;


	/*Create additional descriptive variables*/
	*Time since family member last part of household (d5_1-4), in foster care (d6c_1-4);
	IF f18_d5_1>=0 THEN n_f18_d5_1=f18_d5_1; IF f18_d6c_1>=0 THEN n_f18_d6c_1=f18_d6c_1;
	IF f18_d5_2>=0 THEN n_f18_d5_2=f18_d5_2; IF f18_d6c_2>=0 THEN n_f18_d6c_2=f18_d6c_2;
	IF f18_d5_3>=0 THEN n_f18_d5_3=f18_d5_3; IF f18_d6c_3>=0 THEN n_f18_d6c_3=f18_d6c_3;
	IF f18_d5_4>=0 THEN n_f18_d5_4=f18_d5_4; IF f18_d6c_4>=0 THEN n_f18_d6c_4=f18_d6c_4;

		*calculate time;
	IF n_f18_d5_1~=. THEN f18_d5_days=SUM(SUM(n_f18_d5_1), SUM(n_f18_d5_2*7), SUM(n_f18_d5_3*30.4375), SUM(n_f18_d5_4*365.25));
	IF n_f18_d5_2~=. THEN f18_d5_weeks=SUM(SUM(n_f18_d5_1/7), SUM(n_f18_d5_2), SUM(n_f18_d5_3*4.3333), SUM(n_f18_d5_4*52));
	IF n_f18_d5_3~=. THEN f18_d5_months=SUM(SUM(n_f18_d5_1/30.4375), SUM(n_f18_d5_2/4.333), SUM(n_f18_d5_3), SUM(n_f18_d5_4*12));
	IF n_f18_d5_4~=. THEN f18_d5_years=SUM(SUM(n_f18_d5_1/365.25), SUM(n_f18_d5_2/52), SUM(n_f18_d5_3/12), SUM(n_f18_d5_4));

	IF n_f18_d6c_1~=. THEN f18_d6c_days=SUM(SUM(n_f18_d6c_1), SUM(n_f18_d6c_2*7), SUM(n_f18_d6c_3*30.4375), SUM(n_f18_d6c_4*365.25));
	IF n_f18_d6c_2~=. THEN f18_d6c_weeks=SUM(SUM(n_f18_d6c_1/7), SUM(n_f18_d6c_2), SUM(n_f18_d6c_3*4.3333), SUM(n_f18_d6c_4*52));
	IF n_f18_d6c_3~=. THEN f18_d6c_months=SUM(SUM(n_f18_d6c_1/30.4375), SUM(n_f18_d6c_2/4.333), SUM(n_f18_d6c_3), SUM(n_f18_d6c_4*12));
	IF n_f18_d6c_4~=. THEN f18_d6c_years=SUM(SUM(n_f18_d6c_1/365.25), SUM(n_f18_d6c_2/52), SUM(n_f18_d6c_3/12), SUM(n_f18_d6c_4));

	*time family member has been separated (d8a_1-2);
	IF f18_d8a_1>=0 THEN n_f18_d8a_1=f18_d8a_1; 
	IF f18_d8a_2>=0 THEN n_f18_d8a_2=f18_d8a_2; 

		*calculate time;
	IF n_f18_d8a_1~=. THEN f18_d8a_months=SUM(SUM(n_f18_d8a_1), SUM(n_f18_d8a_2*12));
	IF n_f18_d8a_2~=. THEN f18_d8a_years=SUM(SUM(n_f18_d8a_1/12), SUM(n_f18_d8a_2));

	*time family member was separated (d17);
	IF f18_d17_1>=0 THEN f18_d17_weeks=f18_d17_1;

	*time in foster care in past 6 months (d18c);
	IF f18_d18c_1>=0 THEN n_f18_d18c_1=f18_d18c_1;
	IF f18_d18c_2>=0 THEN n_f18_d18c_2=f18_d18c_2;
	IF f18_d18c_3>=0 THEN n_f18_d18c_3=f18_d18c_3;
	IF f18_d18c_4>=0 THEN n_f18_d18c_4=f18_d18c_4; /*Note--this should get rounded down to 6 months*/

		*calculate time;
	IF f18_d18c_1~=. THEN f18_d18c_days=SUM(SUM(n_f18_d18c_1), SUM(n_f18_d18c_2*7), SUM(n_f18_d18c_3*30.4375), SUM(n_f18_d18c_4*365.25));
	IF f18_d18c_2~=. THEN f18_d18c_weeks=SUM(SUM(n_f18_d18c_1/7), SUM(n_f18_d18c_2), SUM(n_f18_d18c_3/4.3333), SUM(n_f18_d18c_4/52));
	IF f18_d18c_3~=. THEN f18_d18c_months=SUM(SUM(n_f18_d18c_1/30.4375), SUM(n_f18_d18c_2/4.333), SUM(n_f18_d18c_3), SUM(n_f18_d18c_4/12));
	IF f18_d18c_4~=. THEN f18_d18c_years=SUM(SUM(n_f18_d18c_1/365.25), SUM(n_f18_d18c_2/52), SUM(n_f18_d18c_3/12), SUM(n_f18_d18c_4));

	*Combine time in foster care for those with and not with household with a 6 month ceiling;
	IF f18_d6c_months>=6 THEN f18_foster_past6_months=6;
		ELSE IF f18_d18c_months>=6 THEN f18_foster_past6_months=6;
		ELSE IF f18_d6c_months>0 THEN f18_foster_past6_months=f18_d6c_months;
		ELSE IF f18_d18c_months>0 THEN f18_foster_past6_months=f18_d18c_months;
		ELSE IF b_child=1 THEN f18_foster_past6_months=0;


RUN;


*1. Number of spouse/partners separated within last 6 months at 18 month followup
	BASE: Listed as a spouse/partner at baseline and present at baseline
	CALC: Sum of these spouses/partners listed as not with family now (b1a) or separated at any time
			within the last 6 months(d16);

PROC MEANS DATA=s14_fampres_temp SUM NOPRINT;
	WHERE b_present=1 AND b_relat in(1,2);
	VAR f18_notwith f18_seplast6;
	BY id_fam_vand;
	OUTPUT OUT=outcome1 SUM(f18_notwith)=tot_sep_spoupart_nw SUM(f18_seplast6)=tot_sep_spoupart_last6 N(f18_notwith)=n_spoupart_bpres;
RUN;

*2. Number of children separated within last 6 months at 18 month followup
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) and present at baseline
	CALC: Sum of these children listed as not with family now (b1a) or separated at any time
			within the last 6 months (d16)
	QUESTION: Does the current age of the child need to be under 18? 
			If so, may need age at 18 months for kids who were 16 b/c can't tell half years?;

PROC MEANS DATA=s14_fampres_temp SUM NOPRINT;
	WHERE b_present=1 AND b_relat in(3,4,14) AND b_age in(0:17);
	VAR f18_notwith f18_seplast6;
	BY id_fam_vand;
	OUTPUT OUT=outcome2 SUM(f18_notwith)=tot_sep_child_nw SUM(f18_seplast6)=tot_sep_child_last6 N(f18_notwith)=n_child_bpres;
RUN;

*3. Number of children in foster care within last 6 months at 18 month followup
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) age 16 or younger
	CALC: Sum of these children listed either 
			a) as not with family now (b1a) and currently in foster care (d6b)
			b) separated at any time within the last 6 months (d16) AND placed in foster care (d18b)
	NOTE: Assumed that age needed to be 16 or under. Kids 17 or older would be at least 18.5 and 
			could not have been placed in foster care within last 6 months because would have aged out;

PROC MEANS DATA=s14_fampres_temp SUM  NOPRINT;
	WHERE b_relat in(3,4,14) AND b_age in(0:17);
	VAR f18_foster_nw f18_foster_last6;
	BY id_fam_vand;
	OUTPUT OUT=outcome3 SUM(f18_foster_nw)=tot_foster_nw SUM(f18_foster_last6)=tot_foster_last6 N(f18_with)=n_tot_child;
RUN;


*4. Number of spouse/partners reunified at 18 month followup
	BASE: Listed as a spouse/partner at baseline and not present at baseline
	CALC: Sum of these spouses/partners listed as with family now (b1a) 
			within the last 6 months(d16);

PROC MEANS DATA=s14_fampres_temp SUM  NOPRINT;
	WHERE b_present=0 AND b_relat in(1,2);
	VAR f18_with;
	BY id_fam_vand;
	OUTPUT OUT=outcome4 SUM(f18_with)=tot_reunif_spoupart N(f18_with)=n_spoupart_bsep;
RUN;



*5. Number of children reunified at 18 month followup
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) and not present at baseline
	CALC: Sum of these children listed as with family now (b1a)
			within the last 6 months (d16)
	QUESTION: Does the current age of the child need to be under 18? 
			If so, may need age at 18 months for kids who were 16 b/c can't tell half years?;

PROC MEANS DATA=s14_fampres_temp SUM NOPRINT;
	WHERE b_present=0 AND b_relat in(3,4,14) AND b_age in(0:17);
	VAR f18_with;
	BY id_fam_vand;
	OUTPUT OUT=outcome5 SUM(f18_with)=tot_reunif_child N(f18_with)=n_child_bsep;
RUN;


*6. Covariate: age of oldest child with family at baseline
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) 
	CALC: Max of b_age for children present with family at baseline
	QUESTION: Does the current age of the child need to be under 18?;

PROC MEANS DATA=s14_fampres_temp MAX NOPRINT;
	WHERE b_present=1 AND b_relat in(3,4,14) AND b_age in(0:17);
	VAR b_age;
	BY id_fam_vand;
	OUTPUT OUT=ageoldest MAX(b_age)=age_oldest_childwith;
RUN;
*end section 2;



/*Part 3: Merge total separations/reunifications/foster placements with BASELINE head of household survey data*/
PROC SQL;
	CREATE TABLE s14_fampres_merge AS 
	SELECT A.id_fam_vand, 
		B.tot_sep_spoupart_nw, B.tot_sep_spoupart_last6, B.n_spoupart_bpres,
		C.tot_sep_child_nw, C.tot_sep_child_last6, C.n_child_bpres,
		D.tot_foster_nw, D.tot_foster_last6, D.n_tot_child,
		E.tot_reunif_spoupart, E.n_spoupart_bsep,
		F.tot_reunif_child, F.n_child_bsep, G.age_oldest_childwith
	FROM  SASUSER.s02_18mo_vand_140211 (KEEP=id_fam_vand) A
		LEFT JOIN outcome1 B ON A.id_fam_vand=B.id_fam_vand
		LEFT JOIN outcome2 C ON A.id_fam_vand=C.id_fam_vand
		LEFT JOIN outcome3 D ON A.id_fam_vand=D.id_fam_vand
		LEFT JOIN outcome4 E ON A.id_fam_vand=E.id_fam_vand
		LEFT JOIN outcome5 F ON A.id_fam_vand=F.id_fam_vand
		LEFT JOIN ageoldest G ON A.id_fam_vand=G.id_fam_vand
		/*LEFT JOIN SASUSER.s01_base_vand_140117 (KEEP= id_fam_vand AgeatRA GENDER RACE_cat RA_Result PBTH_avail CBRR_avail SUB_avail site_id) H
							ON A.id_fam_vand=H.id_fam_vand*/
	ORDER BY A.id_fam_vand;
QUIT;


DATA s14_fam_pres_impacts_140506_sb ;
	SET s14_fampres_merge;

	/*NOTE: Need to adjust AgeAtRA or get age at follow-up?

	IF CBRR_avail>0 AND PBTH_avail>0 THEN pair_CBRR_PBTH=1; ELSE pair_CBRR_PBTH=0;
	IF CBRR_avail>0 AND SUB_avail>0 THEN pair_CBRR_SUB=1; ELSE pair_CBRR_SUB=0;
	IF SUB_avail>0 AND PBTH_avail>0 THEN pair_SUB_PBTH=1; ELSE pair_SUB_PBTH=0;
	IF CBRR_avail>0 THEN pair_CBRR_UC=1; ELSE pair_CBRR_UC=0;
	IF PBTH_avail>0 THEN pair_PBTH_UC=1; ELSE pair_PBTH_UC=0;
	IF SUB_avail>0 THEN pair_SUB_UC=1; ELSE pair_SUB_UC=0;

	SELECT (RA_Result);
		WHEN ('SUB') DO; ra_SUB=1; ra_PBTH=0; ra_CBRR=0; ra_UC=0; END;
		WHEN ('PBTH') DO; ra_SUB=0; ra_PBTH=1; ra_CBRR=0; ra_UC=0; END;
		WHEN ('CBRR') DO; ra_SUB=0; ra_PBTH=0; ra_CBRR=1; ra_UC=0; END;
		WHEN ('UC') DO; ra_SUB=0; ra_PBTH=0; ra_CBRR=0; ra_UC=1; END;
		OTHERWISE;
	END;*/

	/*Create impact outcome dummy variables*/
	*1. outcome_any_spouspart_sep: Any spouse or partner separations within past 6 months;
	IF tot_sep_spoupart_nw>0 OR tot_sep_spoupart_last6>0 THEN outcome_any_spoupart_sep=1;
		ELSE IF tot_sep_spoupart_nw=0 AND tot_sep_spoupart_last6=0 THEN outcome_any_spoupart_sep=0;

	*2. outcome_any_child_sep: Any child separations;
	IF tot_sep_child_nw>0 OR tot_sep_child_last6>0 THEN outcome_any_child_sep=1;
		ELSE IF tot_sep_child_nw=0 AND tot_sep_child_last6=0 THEN outcome_any_child_sep=0;

	*3. outcome_any_foster: Any foster care placement within past 6 months;
	IF tot_foster_nw>0 OR tot_foster_last6>0 THEN outcome_any_foster=1;
		ELSE IF tot_foster_nw=0 AND tot_foster_last6=0 THEN outcome_any_foster=0;

	*4. outcome_any_spouspart_reunif: Any spouse or partner reunifications;
	IF tot_reunif_spoupart>0  THEN outcome_any_spoupart_reunif=1;
		ELSE IF tot_reunif_spoupart=0 THEN outcome_any_spoupart_reunif=0;

	*5. outcome_any_child_reunif: Any child reunifications;
	IF tot_reunif_child>0 THEN outcome_any_child_reunif=1;
		ELSE IF tot_reunif_child=0 THEN outcome_any_child_reunif=0;

RUN;



