/******************************************************//*

Title: Create Analysis Datasets for HomeFam Interim Report
Program Name: CreateInterimReportDatasets.sas
Programmer: Scott Brown
Last Updated: 1/14/2013

Previous Programs Used: CreateBaselineDataset.sas

Files imported: hfsurv.master_01142013

				EXCEL FILES
				-directory: S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report
				-Community Context Data.xlsx (tabs: "HICandPITforSAS", "CensusforSAS", "BLSforSAS")				
					-> Contains 2011 HIC/PIT data, Census , and Unemployment Data for 12 sites and nationally


Files created: hfsurv.communitycontextdata.sasbdat7

*//******************************************************/

LIBNAME hfsurv "S:\Projects\Homefam\Data\CAPI Baseline Data";
OPTIONS FMTSEARCH=(hfsurv) NOFMTERR;
OPTIONS NOCENTER LINESIZE=220;

*For family details imports;
*Current Week Begin Date;			%let FromDate = 05-16-2012;
*Current Week End Date;				%let ToDate = 05-22-2012;
*Date for Calc Purpose;				%let FromDateB= 5/16/2012;
*Date for Calc Purpose;				%let ToDateB= 5/22/2012;

proc format;
	value a1_catf
	1='A house or apartment that you owned or rented. This does not include your parents or guardians home or apartment'
	2='Your partners (boy/girlfriends/finace, significant others) place'
	3='A friend or relatives house or apartment, and paying part of the rent'
	4='A friend or relatives house or apartment, but not paying part of the rent'
	5='A permanent housing program with service to help you keep your housing (on site or coming to you)'
	6='A transitional housing program'
	7='A voucher hotel or motel'
	8='A hotel or motel you paid for yourself'
	9='A residential drug or alcohol treatment program'
	10='Jail or prison'
	11='A domestic violence shelter'
	12='An emergency shelter other than this one'
	13='A car or other vehicle'
	14='An abandoned building'
	15='Anywhere outside'
	16='Other';
VALUE ageatra_catf
	1 = 'Less than 21 years old'
	2 = '21-24 years'
	3 = '25-29 years'
	4 = '30-34 years'
	5 = '35-44 years'
	6 = '45 years and older';
VALUE fam_income_catf 
	1 = 'Less than $5000'
	2 = '$5000-$9999'
	3 = '$10000-$14999'
	4 = '$15000-$19999'
	5 = '$20000-$24999'
	6 = '$25000 or more';
VALUE edu_attainf 
	1 = 'Less than High School Diploma'
	2 = 'High School Diploma/GED'
	3 = 'Greater than High School Diploma';
VALUE num_adults_catf
	1 = '1'
	2 = '2'
	3 = '3 or more';
VALUE num_child_catf
	1 = '1'
	2 = '2'
	3 = '3'
	4 = '4 or more';
VALUE site_id2f
	1 = 'Alameda County'
	2 = 'Atlanta'
	3 = 'Boston'
	4 = 'Connecticut'
	5 = 'Denver'
	6 = 'Honolulu'
	7 = 'Kansas City'
	8 = 'Minneapolis'
	9 = 'Phoenix'
	10= 'Salt Lake City (Old RA Table)'
	11= 'Baltimore'
	12= 'Louisville (Old RA Table)'
	13= 'Louisville (New RA Table)'
	14= 'Salt Lake City (New RA Table)';
	value ptsdf
	0 = 'No'
	1= 'Yes';
	value psych_distressf
	0 = 'No'
	1= 'Yes';
	value b1_catf 
	1='0-2 barriers big problem'
	2='3-4 barriers big problem'
	3='5-6 barriers big problem'
	4='7 or more barriers big problem';
	value race_catf
	1='Hispanic, all races'
	2='White, non-Hispanic'
	3='African-American, non-Hispanic'
	4='Asian/Pacific Islander, non-Hispanic'
	5='Mixed race, non-Hispanic'
	6='Other';
run;
*CATEGORY FORMATS;
PROC FORMAT;
	VALUE time_c1f
	1-7='1 to 7 nights'
	8-30='8 to 30 nights'
	31-60='31 to 60 nights'
	61-90='61 to 90 nights'
	91-120='91 to 120 nights'
	121-150='121 to 150 nights'
	151-180='151 to 180 nights'
	181-210='181 to 210 nights'
	211-240='211 to 240 nights'
	241-270='241 to 270 nights'
	271-300='271 to 300 nights'
	301-330='301 to 330 nights'
	331-360='331 to 360 nights'
	361-365='361 to 365 nights'
	366-730='366 to 730 nights'
	731-high='Over 730 nights (over 2 years)';
	VALUE age_c3f
	-2='REFUSED'
	-1='DONT KNOW'
	0-<18='0-17 years'
	18-<21='18 to 21 years old'
	21-<25='21-24 years'
	25-<30='25-29 years'
	30-<35='30-34 years'
	35-<45='35-44 years'
	45-high='45 and older';
	VALUE time_days
	0 ='0 days'
	1-30='1 to 30 days'
	31-90='31 to 90 days'
	91-180='91 to 180 days'
	181-365='180 days to 365 days'
	366-730='Greater than 1 year to 2 years'
	731-1095='Greater than 2 years to 3 years'
	1096-1460='Greater than 3 years to 4 years'
	1461-high='Greater than 4 years';
	VALUE time_d6f
	0-1='1 month or less'
	1<-3='Greater than 1 month to 3 months'
	3<-6='Greater than 3 months to 6 months'
	6<-9='Greater than 6 months to 9 months'
	9<-12='Greater than 9 months to 12 months'
	12<-24='Greater than 12 months to 24 months'
	24<-36='Greater than 24 months to 24 months'
	36<-48='Greater than 36 months to 48 months'
	48<-60='Greater than 48 months to 60 months'
	60<-high='Over 60 months'
	;
RUN;

*read in file used in data cleaning to fix households where respondent included self in roster;
PROC IMPORT OUT=hohname_chk replace
			DATAFILE="S:\Projects\Homefam\Output\Data Cleaning\FamWithHoHInRoster.xls" 
			DBMS=XLS;	
RUN;
PROC SORT DATA=hfsurv.master_01142013 OUT=master_s; BY Family_id; RUN;
PROC SORT DATA=hohname_chk OUT=hohname_chk_s; BY Family_id; RUN;

/*
*check for most recent acceptance date;
PROC SQL;
	SELECT family_id, site_id format=site_idf., referral_date , date_accepted_by_provider 
	FROM hfsurv.master_01142014
	WHERE date_accepted_by_provider~=.
	ORDER BY date_accepted_by_provider DESC;
QUIT;*/
*Most recent accept date in this dataset was 1/30/2012 (was one error of 12/22/2012 instead of 2011), 
	in dannys 6-25 dataset was 5/11/2012 -- current dataset missing 45 new acceptances;

DATA hfsurv.options_memo_all  ;
	LENGTH Provider_Name_dedup Shelter_Name Assigned_Provider $200. Fam_Status $35.;
	MERGE master_s (in=aa) hohname_chk_s (KEEP=family_id dupflag2 in=bb);
	BY family_id;
	IF aa;

	*create age;
	IF DOB~=. THEN AgeatRA=FLOOR(YRDIF(dob,RA_Date,'act/act'));
		
	*Eventually need to program in the skip patterns;

	*correct shelter miscoding;
	IF shelter=34 THEN shelter=38; /*duplicate family transitions in CT*/
	IF shelter=35 THEN shelter=49; /*duplicate crossroads family shelter in Boston*/
	IF shelter=22 and site_id=7 THEN shelter=63; /*Separate Salavation Army of Atlanta from K.C.*/
	*checking on shelter 39 in CT -- 1 referral;

	*Add in shelter names;
	SELECT (shelter);
	  WHEN (1) shelter_name = 'UMOM';  
      WHEN (2) shelter_name = 'CASS Vista Colina'  ;
      WHEN (3) shelter_name = 'A New Leaf Shelter (La Mesita)' ; 
      WHEN (4) shelter_name = 'Kaiser Salvation Army'  ;
      WHEN (5) shelter_name = 'Emergency Shelter Program'  ;
      WHEN (6) shelter_name = 'Abode Services Sunrise Village'  ;
      WHEN (7) shelter_name = 'Abode Services Winter Relief'  ;
      WHEN (8) shelter_name = 'Berkeley Food & Housing Shelter for Women and Children'  ;
      WHEN (9) shelter_name = 'Building Futures with Women & Children: San Leandro'  ;
      WHEN (10) shelter_name = 'Building Futures with Women & Children: Midway'  ;
      WHEN (11) shelter_name = 'Building Futures with Women & Children: Sister Me'  ;
      WHEN (12) shelter_name = 'FESCO'  ;
      WHEN (13) shelter_name = 'East Oakland Community Project'  ;
      WHEN (14) shelter_name = 'Gateway Homeless Services Center' ; 
      WHEN (15) shelter_name = 'Road Home'  ;
      WHEN (16) shelter_name = 'Family Promise of Hawaii - Windward'  ;
      WHEN (17) shelter_name = 'Family Promise of Hawaii - Honolulu'  ;
      WHEN (18) shelter_name = 'H-5 Hawaii'  ;
      WHEN (19) shelter_name = "IHS - Ka'ahi Women & Families Shelter";
      WHEN (20) shelter_name = 'Waianae Civic Center'  ;
      WHEN (21) shelter_name = 'Waianae Community Outreach'  ;
	  WHEN (22) shelter_name = 'Salvation Army (Atlanta)'  ;
      WHEN (23) shelter_name = 'reStart, Inc.'  ;
      WHEN (24) shelter_name = 'City Union Mission'  ;
      WHEN (25) shelter_name = 'New Haven Home Recovery';  
      WHEN (26) shelter_name = 'Open Door Shelter'   ;
      WHEN (27) shelter_name = 'St. Lukes Lifeworks'  ;
      WHEN (28) shelter_name = 'Life Haven, Inc.'  ;
      WHEN (29) shelter_name = 'Christian Community Action'  ;
      WHEN (30) shelter_name = 'Home with Hope/Interfaith Housing Associates'  ;
      WHEN (31) shelter_name = 'Samaritan House'  ;
      WHEN (32) shelter_name = 'Family Tree (House of Hope)'  ;
      WHEN (33) shelter_name = 'Colorado Coalition'  ;
      WHEN (34) shelter_name = 'Families in Transition'  ;
      WHEN (35) shelter_name = 'Crossroads Family Shelter' ;
      WHEN (36) shelter_name = "Margaret's House"  ;
      WHEN (37) shelter_name = 'People Serving People'  ;
      WHEN (38) shelter_name = 'CCYMCA-Alpha Community Services - Families in Transitions'  ;
      WHEN (39) shelter_name = 'Operation Hope - Family Shelter Readiness Program'  ;
      WHEN (40) shelter_name = 'Harrison House'  ;
      WHEN (41) shelter_name = 'Access Housing'  ;
      WHEN (42) shelter_name = 'Salvation Army ES (Louisville)'  ;
      WHEN (43) shelter_name = 'Volunteers of America (VOA) ES'  ;
      WHEN (44) shelter_name = 'Wayside Christian Mission ES'  ;
      WHEN (45) shelter_name = "Sarah's Hope"  ;
      WHEN (46) shelter_name = 'Christ Lutheran';  
      WHEN (47) shelter_name = 'Action for Boston Community Development (ABCD)'  ;
      WHEN (48) shelter_name = "Children's Services of Roxbury"  ;
      WHEN (49) shelter_name = 'Crossroads Family Shelter'  ;
      WHEN (50) shelter_name = 'Heading Home'  ;
      WHEN (51) shelter_name = 'Hildenbrand Family Self-Help Center'  ;
      WHEN (52) shelter_name = 'Little Sisters of the Assumption'  ;
      WHEN (53) shelter_name = 'YMCA of Greater Boston'  ;
      WHEN (54) shelter_name = 'Shelter for the homeless, Inc.'  ;
      WHEN (55) shelter_name = 'Share House'  ;
      WHEN (56) shelter_name = 'Decatur Coop'  ;
      WHEN (57) shelter_name = 'Booth House'  ;
      WHEN (58) shelter_name = 'Norwalk SafeHouse'  ;
      WHEN (59) shelter_name = 'Stamford SafeHouse'  ;
      WHEN (60) shelter_name = 'Crittendon' ;
	  WHEN (61) shelter_name = 'Interfaith Hospitality Access Network';
	  WHEN (62) shelter_name = "St. Mary's";
	  WHEN (63) shelter_name = 'Salvation Army (Kansas City)';
	  OTHERWISE;
	END;

	*Provider Name recoding to deduplicate providers;
	SELECT (Provider_Name);
		WHEN ('Abode RR','Abode RR - Alameda City','Abode RR - Oakland','Abode RR - San Leandro') Provider_Name_dedup='Abode RR';
		WHEN ('ABCD Flex Funds', 'Childrens Services Flex Funds','Crossroads Flex Funds',
				'Heading Home Flex Funds','Project Hope Flex Funds','YMCA Flex Funds') Provider_Name_dedup='Boston Flex Funds';
		WHEN ('Alameda Point 2BR','Alameda Point 3BR') Provider_Name_dedup='Alameda Point';
		WHEN ('BOSS Sankofa House','BOSS McKinley House') Provider_Name_dedup='BOSS House';
		WHEN ('FESCO Banyon','FESCO 3rd ST') Provider_Name_dedup='FESCO';
		WHEN ('Henry Robinson 3 Rm','Henry Robinson 2 Rm','Henry Robinson 1 Rm','Henry Robinson') 
			Provider_Name_dedup='Henry Robinson';
		WHEN ('HOPE Atl TH - Fulton 2 Bd','HOPE Atl TH - Cobb 3 Bd','HOPE Atl TH') Provider_Name_dedup='HOPE Atl TH';
		WHEN ('Nicholas House (fam w 3-6 kids)','Nicholas House (fam w 2-4 kids)',
				'Nicholas House (fam w 1-2 kids)','Nicholas House (fam w > 7 kids)') 
			Provider_Name_dedup='Nicholas House';
		WHEN ('Druid Heights TH 3 BR','Druid Heights TH 2 BR') Provider_Name_dedup='Druid Heights TH';
		WHEN ('Alpha Jean Wallace 3 BR','Alpha Jean Wallace 2 BR') Provider_Name_dedup='Alpha Jean Wallace';
		WHEN ('Warren','Warren Vill 2 BR','Warren Vill 1 BR') Provider_Name_dedup='Warren Vill';
		WHEN ('Perspectives 2 BR','Perspectives 1 BR') Provider_Name_dedup='Perspectives';
		WHEN ('Road Home TH 3 BR','Road Home TH 2 BR','Road Home TH') Provider_Name_dedup='Road Home TH';
		WHEN ('BHA','BHA 1 BR','BHA 2 BR','BHA 3 BR') Provider_Name_dedup='BHA - CT';
		WHEN ('DSS','DSS SUB - New Haven','DSS SUB - Bridgeport') Provider_Name_dedup='DSS SUB';
	OTHERWISE Provider_Name_dedup=Provider_Name;
	END;

	*Create provider variable that includes name of shelter if assigned to UC;
	SELECT (ra_result);
		WHEN ('SUB', 'CBRR', 'PBTH') Assigned_Provider=Provider_Name_dedup;
		WHEN ('UC') Assigned_Provider=shelter_name;
		OTHERWISE;
	END;

/**SET DK/REF TO MISSING;
	*Variables with 7=REF 8=DK;
	ARRAY seveneight a1a a1b a1c a1d a1e a1f a1g a1h a1i a1j a1k a1l a1m a1n a1o a1p
					b1a b1b b1c b1d b1e b1f b1g b1h b1i b1j b1k b1l b1m b1n b1o b1p b1q b1r b1s
	;
	*Variables with -1=DK and -2=REF;
	ARRAY neg_a 

	;
	*Variables with REF=97, DK=98;
	ARRAY ninetyseveneight

	;

	DO OVER seveneight;
		IF seveneight=7 THEN seveneight=.R;
		IF seveneight=8 THEN seveneight=.D;
	END;
*/

	*Create flags for referred, contact, accept, enroll, and rejected;
	IF provider_contact_date~=. or ra_result='UC' THEN Contacted=1; ELSE Contacted=0;
	IF date_accepted_by_provider~=. or ra_result='UC' THEN Accepted=1; ELSE Accepted=0;
	IF move_in_or_lease_up_date~=. or ra_result='UC' THEN MoveIn=1; ELSE MoveIn=0;
	IF refusal_date~=. THEN Refusal=1; ELSE Refusal=0;
	IF Accepted=1 or Refusal=1 THEN Verified=1; ELSE Verified=0;

	*Refusal Codes;
	IF Refusal=1 THEN DO;
		SELECT (Refusal_recode);
			WHEN ("Fam Dec'n","No Show",'other-deceased') Fam_Status="Refused, No Show/Fam Decision";
			WHEN ("Unit Filled","Ineligible") Fam_Status="Refused, Ineligible/Unit Filled";
			WHEN (" ") Fam_Status="Refused, Blank";
			OTHERWISE Fam_Status="Error";
		END;
		END;
	ELSE DO;
		IF Refusal=0 AND Accepted=0 THEN Fam_Status="Not yet accepted or refused";
		ELSE IF Refusal=0 AND Accepted=1 AND MoveIn=0 THEN Fam_Status="Accepted but not yet moved in";
		ELSE IF Refusal=0 AND Accepted=1 AND MoveIn=1 THEN Fam_Status="Family moved into housing";
		ELSE Fam_Status="Error2";
	END;

	IF Fam_Status IN("Refused, No Show/Fam Decision","Refused, Blank","Error","Error2" )
		THEN Fam_Status_DropOut=1; ELSE Fam_Status_DropOut=0;
	IF Fam_Status="Refused, Ineligible/Unit Filled" THEN Fam_Status_Ineligible=1;ELSE Fam_Status_Ineligible=0;
	IF Fam_Status="Accepted but not yet moved in" THEN Fam_Status_NotMoveIn=1; ELSE Fam_Status_NotMoveIn=0;

	


	/********************************************************************************//*
							Section A: Last residence
	*//********************************************************************************/

	
	/*RECODES for A1 based on Danny's recoding of the Other (a1p) answers
	File with recodings is here: S:\Homefam\Output\Exploratory\EXPLORE_DANNY\A1p_recodes_7-12-12.pdf 
	code to reproduce answers: proc freq data=hfsurv.master_02292012; where a1p_1_other~=' '; tables family_id*a1p_1_other /norow nocol nopercent; run;*/
	SELECT (family_id);
		WHEN (2569,1696) DO; a1a=1;a1p=.; END;
		WHEN (1370,3387,3145,1450,1862,1439) DO; a1c=1;a1p=.; END;
		WHEN (1328,2163,2665,1281) DO; a1d=1;a1p=.; END;
		WHEN (2014,3025,2582) DO; a1h=1;a1p=.; END;
		WHEN (1238,1597) DO; a1l=1;a1p=.; END;
		WHEN (1874,3033) DO; a1m=1;a1p=.; END;
		WHEN (2834) DO; a1n=1;a1p=.; END;
		WHEN (2104) DO; a1o=1;a1p=.; END;
		OTHERWISE;
	END;
	
	
	*A4 - How long since you had a regular place to stay or regular housing;
	IF a4 NOT IN (-1,-2,.) AND a4a NOT IN (-1,-2)  AND a4b NOT IN (-1,-2) AND a4c NOT IN (-1,-2)
		THEN a4_days=SUM(a4a,(a4b*30),(a4c*365));
		/*assume have to have been in shelter at least 7 days*/
		ELSE IF a4=. THEN a4_days=7; ELSE a4_days=.;
	IF a4 NOT IN (-1,-2,.) AND a4a NOT IN (-1,-2)  AND a4b NOT IN (-1,-2) AND a4c NOT IN (-1,-2)
		THEN a4_months=SUM((a4a/30),a4b,(a4c*12));
		ELSE IF a4=. THEN a4_months=(7/30); ELSE a4_months=.;
	IF a4 NOT IN (-1,-2,.) AND a4a NOT IN (-1,-2)  AND a4b NOT IN (-1,-2) AND a4c NOT IN (-1,-2)
		THEN a4_years=SUM((a4a/365),(a4b/12),(a4c));ELSE a4_years=.;

		ARRAY aonez a1a a1b a1c a1d a1e a1f a1g a1h a1i a1j a1k a1m a1n a1o a1p;
		ARRAY aonez2 a1a_dummy a1b_dummy a1c_dummy a1d_dummy a1e_dummy a1f_dummy a1g_dummy a1h_dummy a1i_dummy a1j_dummy a1k_dummy a1m_dummy a1n_dummy a1o_dummy a1p_dummy ;
		DO OVER aonez; IF aonez=1 THEN aonez2=1; ELSE IF aonez not in(7,8) THEN aonez2=0; END;

		IF a1f=1 or a1g=1 or a1k=1 or a1l=1 or a1m=1 or a1n=1 or a1o=1 
			THEN a1_homeless=1; ELSE a1_homeless=0;
		IF a1e=1 or a1i=1 THEN a1_treat=1;ELSE a1_treat=0;


	/********************************************************************************//*
							Section B: Housing Barriers
	*//********************************************************************************/

	*Created variable for sum of big problem and sum of any problems
	NOTE: REF/DK currently treated in created variable as not a problem (measure+0);
	ARRAY b_one (19) b1a--b1s;
	DO y=1 to 19;
		IF y=1 THEN DO; B1_BigProb=0; B1_AnyProb=0; END;
		SELECT (b_one[y]);
			WHEN (1) DO; B1_BigProb+1; B1_AnyProb+1; END;
			WHEN (2) DO; B1_BigProb+0; B1_AnyProb+1; END;
			OTHERWISE DO; B1_BigProb+0; B1_AnyProb+0; END;
		END;
	END;
		*Create categorical variable for housing barriers;
	SELECT (B1_BigProb);
		WHEN (0,1,2) B1_Cat=1;
		WHEN (3,4) B1_Cat=2;
		WHEN (5,6) B1_Cat=3;
		WHEN (7,8,9,10,11,12,13,14,15,16,17,18,19) B1_Cat=4;
		OTHERWISE B1_Cat=.;
	END;
		*Variables for Jill tables;
	IF b1j=1 or b1k=1 or b1l=1 THEN b1_evict=1; ELSE b1_evict=0;
	IF b1g=1 or b1h=1 or b1i=1 THEN b1_noprevlease=1; ELSE b1_noprevlease=0;

	IF b1j in(1,2) or b1k in(1,2) or b1l in(1,2) THEN b1_evict_bs=1; ELSE b1_evict_bs=0;
	IF b1g in(1,2) or b1h in(1,2) or b1i in(1,2) THEN b1_noprevlease_bs=1; ELSE b1_noprevlease_bs=0;

	IF b1j in(1,2) THEN b1j_bs_dummy=1;ELSE IF B1j=3 THEN b1j_bs_dummy=0;
	IF b1g in(1,2) THEN b1g_bs_dummy=1;ELSE IF B1g=3 THEN b1g_bs_dummy=0;

		/********************************************************************************//*
							Section C
	*//********************************************************************************/

	*C1 - how long have you been homeless prior to coming to shelter (current episode), add 7 days
			since had to be homeless for at least?;
	IF c1A5_97 ~=1 AND c1a6_98~=1 THEN DO;
		c1_days=SUM(c1a1,(c1a2*7),(c1a3*30),(c1a4*365),7);
		c1_months=SUM((c1a1/30),(c1a2/4),c1a3,(c1a4*12),(7/30));
		c1_years=SUM((c1a1/365),(c1a2/52),(c1a3/12),(c1a4),(7/365));
	END;

	*C2 - how many times have you been homeless before?;
	IF C2=0 THEN c2_FirstEp=1;ELSE IF C2>0 THEN c2_FirstEp=0;

	*C3 Age when became homeless -- use C4 for refusals? need to cross with respondent age for 1st time
		NOTE--need to substract duration of current spell from age at ra?;
	IF c2=0 and c2a=1 THEN c3_comb=FLOOR(SUM(ageatra,(c1_years*-1)));
		ELSE c3_comb=c3;

	IF c3_comb<18 and c3_comb>=0 THEN c3_childhomeless=1;ELSE IF c3_comb>=18 THEN c3_childhomeless=0;
	
	*C6 - how long have you been homeless (total lIFetime length)?;
	IF c6a5_97~=1 AND c6a6_98~=1 THEN DO;
		c6_days=SUM(c6a1,(c6a2*7),(c6a3*30),(c6a4*365));
		c6_months=SUM((c6a1/30),(c6a2/4),c6a3,(c6a4*12));
		c6_years=SUM((c6a1/365),(c6a2/52),(c6a3/12),(c6a4));

		IF c6_days~=. THEN c6_days_alt=SUM(c6a1,(c6a2*7),(c6a3*30),(c6a4*365));ELSE c6_days_alt=c1_days;
		IF c6_months~=. THEN c6_months_alt=SUM((c6a1/30),(c6a2/4),c6a3,(c6a4*12)); ELSE c6_months_alt=c1_months;
		IF c6_years~=. THEN	c6_years_alt=SUM((c6a1/365),(c6a2/52),(c6a3/12),(c6a4));ELSE c6_years_alt=c1_years;
		
	END;

	*C7 - Ever doubled up?;
	IF C7=1 THEN c7_doubledup=1;ELSE IF C7=2 THEN c7_doubledup=0;

	*C8 - Since became adult, total time spent livINg with family or friENDs b/c couldn't afford place of your own?;
	IF c8a5_97~=1 AND c8a6_98~=1 THEN DO;
		c8_days=SUM(c8a1,(c8a2*7),(c8a3*30),(c8a4*365));
		c8_months=SUM((c8a1/30),(c8a2/4),c8a3,(c8a4*12));
		c8_years=SUM((c8a1/365),(c8a2/52),(c8a3/12),(c8a4));
	END;

	/********************************************************************************//*
							Section D
	*//********************************************************************************/

	*D6 - Last work for pay;
	IF d6 NOT IN (-1,-2,-3) THEN DO;
		d6_mdy=MDY(d6mm,1,d6yyyy);
		IF d6_mdy~=. THEN d6_years=YRDIF(d6_mdy,ra_Date,'act/act');
		d6_months=d6_years*12;
		END;
	ELSE IF d6=-2 THEN DO; d6_months=.; d6_years=.;d6_cat=-2;END;
	ELSE IF d6=-3 THEN DO; d6_months=.; d6_years=.;d6_cat=-3;END;
	ELSE IF d6=-1 THEN DO;
		IF d6a NOT IN(-1,-2) THEN DO; d6_months=SUM(d6am,(d6ay*12));d6_years=SUM((d6am/12),d6ay);END;
		ELSE IF d6a=-1 THEN DO;d6_months=.; d6_years=.;d6_cat=-1;END;
		ELSE IF d6a=-2 THEN DO;d6_months=.; d6_years=.;d6_cat=-2;END;
	END;

	

	IF d8 in(-1,-2) THEN d8_hours=.; ELSE d8_hours=d8;
	*The d12_wages variable should be considered as estimated annual wages based on hours usually worked
		and assuming those hours are relatively consistent for the year and that the person would work
		for the whole year;
	IF d12 in(-1,-2) THEN d12_wages=.; ELSE DO;
		SELECT (D10);
			WHEN (1) d12_wages=(d12*d8*52);/*Hourly wages - wage by hours per week by 52 weeks*/
			WHEN (2) d12_wages=(d12*5*52);/*Daily wages -- assume work 5 days per week*/
			WHEN (3) d12_wages=(d12*52);/*Weekly wages -- assume 52 weeks per year*/
			WHEN (4) d12_wages=(d12*26);/*Bi-weekly wages -- assume 26 pay periods*/
			WHEN (5) d12_wages=(d12*24);/*Twice monthly -- assume 24 pay periods*/
			WHEN (6) d12_wages=(d12*12);/*Monthly*/
			WHEN (7) d12_wages=(d12);/*Annually*/
			/*No reasonable way to compute annual wages for per-unit or the other categories (i.e., per job) so set to missing*/
			WHEN (8,96,97,98) d12_wages=.;
			OTHERWISE;
		END;
		END;

	*Dummy variables for employment;
			IF d1=2 THEN DO; d1_nowork=1;d1_working=0;END; ELSE IF d1=1 THEN DO; d1_nowork=0;d1_working=1;END;
			IF d6_months>=6 or d6=-3 THEN d6_nowk_6mo=1;ELSE IF d6_months~=. or d1=1 THEN d6_nowk_6mo=0;
			IF d6_months>=12 or d6=-3 THEN d6_nowk_12mo=1;ELSE IF d6_months~=. or d1=1 THEN d6_nowk_12mo=0;
			IF d6_months>=24 or d6=-3 THEN d6_nowk_24mo=1;ELSE IF d6_months~=. or d1=1 THEN d6_nowk_24mo=0;
	*Dummy variable for disability;
			IF D3=1 or d2=11 THEN D3_dummy=1; ELSE IF D3=2 THEN D3_dummy=0;

	/********************************************************************************//*
							Section E
	*//********************************************************************************/

	*Marriage Status;
	SELECT (e1);
		WHEN (1) e1_recode=1;
		WHEN (2) e1_recode=2;
		WHEN (3,4) e1_recode=3;
		OTHERWISE;
	END;

	*Binary variable for any child separated at baseline;
	IF E6A>0 THEN Child_Sep=1; 
		ELSE IF E6a=0 or E6=2 THEN Child_Sep=0;
		ELSE IF E6a=-2 or E6a=. THEN Child_Sep=.;

	*Create check comparing Count questions to roster;

	*Corrections - 16 is a made-up coding for "Other Child"
		See: [REFERENCE DOCUMENT];
	if family_id IN(1071,1178,1275,1467,1702,1895,2694) THEN E7_1=16;
	if family_id IN(1467,1895,2157,2347,2694,3297,3318) THEN E7_2=16;
	if family_id IN(1311,1895,2444,2487,2732) THEN E7_3=16;
	if family_id IN(2487,2732) THEN E7_4=16;
	if family_id IN(2487) THEN E7_5=16;

		*present;
	ARRAY rela (9) E7_1-E7_9 ;
	ARRAY gndr (9) E8_1-E8_9;
	ARRAY age (9) E9_1-E9_9 ;
	ARRAY child_age (9);
	ARRAY bchild (9) E13_1-E13_9 ;
	ARRAY working (9) E10_1-E10_9 ;
	ARRAY disab (9) E11_1-E11_9 ;
	ARRAY felony (9) E12_1-E12_9 ;
		*absent;
	ARRAY rela_a (7) E19_1-E19_7;
	ARRAY age_a (7) E21_1-E21_7;
	ARRAY foster_a (7) E25A_4_1-E25A_4_7;
	ARRAY a_child_age (7);
		*other;
	ARRAY noschl (9) E16_1-E16_9;
	ARRAY child_d (9) E17_1-E17_9;
		*names;
	ARRAY adultname (9) $ E3A_1-E3A_9;
	ARRAY chldname (9) $ E4A_1-E4A_9;
	ARRAY chldname_a (7) $ E6B_1-E6B_7;

	*Back end corrections: ;
		*recorded 0 adults but erroneously put in adult name in E3A_1;
	IF family_id in(1546,1796,2967) THEN E3A_1=' ';
		*use "dupflag" to trigger correction of households where respondent included self in HH roster;
	IF dupflag2=1 THEN DO; adultname[1]=' '; age[1]=.; rela[1]=.; gndr[1]=.; END;
	IF dupflag2=2 THEN DO; adultname[2]=' '; age[2]=.; rela[2]=.; gndr[2]=.; END;

	*Household members present with family;
	DO i=1 TO 9;
		IF i=1 THEN DO; num_adult_with=0;num_child_with=0;child_u3=0;child_u3_Alt=0;childu15_noschl=0;child_disab=0; 
			child_3to5=0;child_6to9=0;child_10to12=0;child_13to17=0;child_w=0;child_w_u18=0;
				/*from jill hhroster routine in previous program*/
			spouse_present=0; all_adults=0; all_nonchild=0; all_men=0; all_women=0;all_nonchild_men=0;all_nonchild_women=0; 
			all_teen_female=0; all_teen_male=0; num_adult_child=0;

			any_bio_child=0; any_step_child=0;spouses_nochild2=0;spouses_stepchild=0; 
			spouse=0;partner=0;any_partners_child=0;spouses_child2=0;spouses_child=0;partners_child=0; 
			working_adult=0;working_teen=0;working_error=0;
			cw_0to2=0;cw_3to5=0;cw_6to8=0;cw_9to11=0;cw_12to14=0;cw_15to17=0;
			disab_nowork=0;e12_felony_dummy=0;
			END;
			
		IF adultname[i]~=' ' THEN num_adult_with+1;
		IF chldname[i]~=' ' THEN num_child_with+1;
		
		IF rela[i] in(3,4,14) and age[i]<=15 and noschl[i]=2 THEN childu15_noschl=1; ELSE childu15_noschl+0;
		IF rela[i] in(3,4,14) and child_d[i]=1 THEN child_disab=1; ELSE child_disab+0;
		IF disab[i]=1 THEN disab_nowork=1; ELSE disab_nowork+0;
		IF felony[i]=1 THEN e12_felony_dummy=1; ELSE e12_felony_dummy+0;

		*child age categories;
		IF rela[i] in(3,4,14) and age[i]<3 THEN child_u3=1; ELSE child_u3+0;

		IF rela[i] in(3,4,14) and age[i]<3 THEN child_u3_alt+1; ELSE child_u3_alt+0;
		IF rela[i] in(3,4,14) and age[i] in(3,4,5) THEN child_3to5+1; ELSE child_3to5+0;
		IF rela[i] in(3,4,14) and age[i] in(6,7,8,9) THEN child_6to9+1; ELSE child_6to9+0;
		IF rela[i] in(3,4,14) and age[i] in(10,11,12) THEN child_10to12+1; ELSE child_10to12+0;
		IF rela[i] in(3,4,14) and age[i] in(13,14,15,16,17) THEN child_13to17+1; ELSE child_13to17+0;
		IF rela[i] in(3,4,14) THEN child_w+1; ELSE child_w+0;
		IF rela[i] in(3,4,14) and age[i]<18 THEN child_w_u18+1; ELSE child_w_u18+0;
		IF rela[i] in(3,4,14) and age[i]>=18 THEN num_adult_child+1; ELSE num_adult_child+0;

		/*from jill hhroster variables*/
		IF rela[i] in(1,2) THEN spouse_present=1; ELSE spouse_present+0;
		IF age[i] >= 18 THEN all_adults+1; ELSE all_adults+0;
		IF age[i] >= 18 and rela[i] not in(3,4,14,.) THEN all_nonchild+1; ELSE all_nonchild+0;
		IF age[i] >= 18  and gndr[i]=1 THEN all_men+1; ELSE all_men+0;
		IF age[i] >= 18  and gndr[i]=2 THEN all_women+1; ELSE all_women+0;
		IF age[i] >= 18 and rela[i] not in(3,4,14,.) and gndr[i]=1 THEN all_nonchild_men+1; ELSE all_nonchild_men+0;
		IF age[i] >= 18 and rela[i] not in(3,4,14,.) and gndr[i]=2 THEN all_nonchild_women+1; ELSE all_nonchild_women+0;

		*Check gender balance of teens;
		IF age[i] in(13,14,15,16,17) and rela[i] in(3,4,14) and gndr[i]=1 THEN all_teen_male+1; ELSE all_teen_male+0;
		IF age[i] in(13,14,15,16,17) and rela[i] in(3,4,14) and gndr[i]=2 THEN all_teen_female+1; ELSE all_teen_female+0;

		*other working hh members;
		IF working[i]=1 and age[i]>=18 THEN working_adult+1; ELSE working_adult+0;
		IF working[i]=1 and age[i] in (15,16,17) THEN working_teen+1; ELSE working_teen+0;
		IF working[i]=1 and age[i] <15 THEN working_error+1; ELSE working_error+0;

		*child age buckets for report exhibit;
		IF age[i] in (0,1,2) and rela[i] in (3,4,14) THEN cw_0to2+1;ELSE cw_0to2+0;
		IF age[i] in (3,4,5) and rela[i] in (3,4,14) THEN cw_3to5+1;ELSE cw_3to5+0;
		IF age[i] in (6,7,8) and rela[i] in (3,4,14) THEN cw_6to8+1;ELSE cw_6to8+0;
		IF age[i] in (9,10,11) and rela[i] in (3,4,14) THEN cw_9to11+1;ELSE cw_9to11+0;
		IF age[i] in (12,13,14) and rela[i] in (3,4,14) THEN cw_12to14+1;ELSE cw_12to14+0;
		IF age[i] in (15,16,17) and rela[i] in (3,4,14) THEN cw_15to17+1;ELSE cw_15to17+0;

		*two-parent households;
		IF rela[i] in(1) THEN spouse=1; ELSE spouse+0;
		IF rela[i] in(2) THEN partner=1; ELSE partner+0;
		/*IF rela[i] in(3,4) and bchild[i]=1 THEN spouses_child2=1; ELSE spouses_child2+0;
		IF rela[i] in(3,4) and bchild[i]=2 THEN spouses_nochild2=1; ELSE spouses_nochild2+0;*/
		IF rela[i] in(3) and bchild[i]=1 THEN spouses_child=1; ELSE spouses_child+0;
		IF rela[i] in(4) and bchild[i]=1 THEN spouses_stepchild=1; ELSE spouses_stepchild+0;
		IF rela[i] in(6) and bchild[i]=1 THEN partners_child=1; ELSE partners_child+0;
		IF rela[i] in(6) THEN any_partners_child=1; ELSE any_partners_child+0;
		IF rela[i] in(3) THEN any_bio_child=1; ELSE any_bio_child+0;
		IF rela[i] in(4) THEN any_step_child=1; ELSE any_step_child+0;

		IF i=9 THEN DO; 
			all_adults+1; all_nonchild+1;
			IF L3=1 THEN DO; all_men+1; all_nonchild_men+1; END;
			ELSE IF L3=2 THEN DO; all_women+1; all_nonchild_women+1;END;
		END;
			/*END jill hhroster variables*/
	END; 

	*Household members not present;
	DO i=1 TO 7;
		IF i=1 THEN DO; partner_nw=0;num_child_nw=0;child_nw=0;child_nw_u18=0;child_u3_nw=0;child_u3_nw2=0;child_3to5_nw2=0;child_3to6_nw=0;child_7to12_nw=0;child_foster_nw=0; 
			child_6to9_nw2=0;child_10to12_nw2=0;child_13to17_nw2=0;
			cnw_0to2=0;cnw_3to5=0;cnw_6to8=0;cnw_9to11=0;cnw_12to14=0;cnw_15to17=0;
			END;

		IF chldname_a[i]~=' ' THEN num_child_nw+1;
		
		IF rela_a[i] in(1,2) and age_a[i]>=18 THEN partner_nw+1; ELSE partner_nw+0;
		IF rela_a[i] in(3,4) THEN child_nw+1; ELSE child_nw+0;
		IF rela_a[i] in(3,4) and age_a[i]<18 THEN child_nw_u18+1; ELSE child_nw_u18+0;
		IF rela_a[i] in(3,4) and age_a[i]<3 THEN child_u3_nw2+1; ELSE child_u3_nw2+0;
		IF rela_a[i] in(3,4) and age_a[i] in(3,4,5) THEN child_3to5_nw2+1; ELSE child_3to5_nw2+0;
		IF rela_a[i] in(3,4) and age_a[i] in(6,7,8,9) THEN child_6to9_nw2+1; ELSE child_6to9_nw2+0;
		IF rela_a[i] in(3,4) and age_a[i] in(10,11,12) THEN child_10to12_nw2+1; ELSE child_10to12_nw2+0;
		IF rela_a[i] in(3,4) and age_a[i] in(13,14,15,16,17) THEN child_13to17_nw2+1; ELSE child_13to17_nw2+0;
		
		IF rela_a[i] in(3,4) and age_a[i]<3 THEN child_u3_nw=1; ELSE child_u3_nw+0;
		IF rela_a[i] in(3,4) and age_a[i] in(3,4,5,6) THEN child_3to6_nw=1; ELSE child_3to6_nw+0;
		IF rela_a[i] in(3,4) and age_a[i] in(7,8,9,10,11,12) THEN child_7to12_nw=1; ELSE child_7to12_nw+0;
		IF foster_a[i]=1 THEN child_foster_nw=1; ELSE child_foster_nw+0;
		
		/*from jill hhroster*/
		IF age_a[i] in (0,1,2) and rela_a[i] in (3,4) THEN cnw_0to2+1;ELSE cnw_0to2+0;
		IF age_a[i] in (3,4,5) and rela_a[i] in (3,4) THEN cnw_3to5+1;ELSE cnw_3to5+0;
		IF age_a[i] in (6,7,8) and rela_a[i] in (3,4) THEN cnw_6to8+1;ELSE cnw_6to8+0;
		IF age_a[i] in (9,10,11) and rela_a[i] in (3,4) THEN cnw_9to11+1;ELSE cnw_9to11+0;
		IF age_a[i] in (12,13,14) and rela_a[i] in (3,4) THEN cnw_12to14+1;ELSE cnw_12to14+0;
		IF age_a[i] in (15,16,17) and rela_a[i] in (3,4) THEN cnw_15to17+1;ELSE cnw_15to17+0;
	
	END;

 
	IF E5a_2_Other~=' ' THEN num_adult_nw=1; ELSE num_adult_nw=0;
	*Compare E2 to HH roster count;
	IF num_adult_with~=E2 THEN flag_adultrost=1;ELSE flag_adultrost=0;
	IF num_child_with~=E4 THEN flag_childrost=1;ELSE flag_childrost=0;
	IF num_child_nw~=E6a THEN DO;
		IF E6>1 AND num_child_nw=0 THEN flag_childnwrost=0;
		ELSE IF E6A=-2 and num_child_nw=0 THEN flag_childnwrost=0;
		ELSE flag_childnwrost=1;
		END;
	ELSE flag_childnwrost=0;
	IF (num_adult_nw=1 AND E5~=1) or (num_adult_nw=0 and E5=1) THEN flag_adultnwrost=1; ELSE flag_adultnwrost=0;

	*categorical variables for number of adults and children;
	SELECT (num_adult_with);
		WHEN (0) num_adults_cat=1; 
		WHEN (1) num_adults_cat=2;
		WHEN (2,3,4,5,6,7,8) num_adults_cat=3;
		OTHERWISE num_adults_cat=.;
	END;
	IF num_adult_with>=2 THEN twoormoreadults=1;ELSE IF num_adult_with in(1,2) THEN twoormoreadults=0;

	SELECT (num_child_with);
		WHEN (1) num_child_cat=1;
		WHEN (2) num_child_cat=2;
		WHEN (3) num_child_cat=3;
		WHEN (4,5,6,7,8) num_child_cat=4;
		OTHERWISE num_child_cat=.;
	END;

	num_in_hh=sum(num_adult_with, num_child_with, 1);

	*Disabilities;
	IF D2=11 or D3=1 THEN HoH_disabled=1; ELSE HoH_disabled=0;
		*any person in HH with family in shelter disabled 
			-combine section D info with hh roster info as some gaps b/t the two
			(i.e., did not check having disabled child in D4 but did in HH roster;
	IF HoH_disabled=1 or d4=1 or d5=1 or child_disab=1 or disab_nowork=1  THEN D_Disabled=1; ELSE D_Disabled=0;

	*any adult male in the household?;
	IF all_men>0 THEN dummy_men=1; ELSE dummy_men=0;

	*Adults 24 and under;
		IF ageatra>0 and ageatra<25 THEN adults_u25=1;ELSE adults_u25=0;
	*Male head without female partner;
		IF L3=1 AND spouse_present=0 THEN male_nopartner=1;ELSE male_nopartner=0;
	*spouse/partner is parent of at least one child;
		IF (spouse=1 or partner=1) and (spouses_child=1 or spouses_stepchild=1) THEN spouses_child_present=1;ELSE spouses_child_present=0;
	*Adult Child;
		IF num_adult_child>0 THEN adult_child=1; ELSE adult_child=0;
	*Partner not present in shelter;
		IF partner_nw>0 THEN absent_partner=1;ELSE absent_partner=0;

	*Total working adults in family;
	total_working_adults=SUM(working_adult,d1_working);

	/********************************************************************************//*
							Section F
	*//********************************************************************************/
	
	*categorical income;
	IF f2 >=0 THEN DO;
		IF 0 <= F2 < 5000 THEN fam_income_cat=1;
		ELSE IF 5000 <= F2 < 10000 THEN fam_income_cat=2;
		ELSE IF 10000 <= F2 < 15000 THEN fam_income_cat=3;
		ELSE IF 15000 <= F2 < 20000 THEN fam_income_cat=4;
		ELSE IF 20000 <= F2 < 25000 THEN fam_income_cat=5;
		ELSE IF F2 >= 25000 THEN fam_income_cat=6;
		END;
	ELSE IF f2 in (-1,-2) THEN DO;
		IF f5=1 THEN fam_income_cat=6;
		ELSE IF f5=2 and f4=1 THEN fam_income_cat=5;
		ELSE IF f4=2 and f6=1 THEN fam_income_cat=4;
		ELSE IF f3=1 and f6=2 THEN fam_income_cat=3;
		ELSE IF f3=2 and f7=1 THEN fam_income_cat=2;
		ELSE IF f7=2 THEN fam_income_cat=1 ;
		END;

	ARRAY FOne f1a f1b f1c f1d f1e f1f f1g f1h f1i f1j f1k f1l;
	ARRAY FOneD f1a_dummy f1b_dummy f1c_dummy f1d_dummy f1e_dummy f1f_dummy f1g_dummy f1h_dummy f1i_dummy f1j_dummy f1k_dummy f1l_dummy;
	DO OVER FOne; IF FOne=1 THEN FOneD=1; ELSE IF FOne=2 THEN FOneD=0;END;

	IF f1j=1 or f1k=1 or f1l=1 THEN f1_med=1;ELSE f1_med=0;
	
	/********************************************************************************//*
							Section G: Health
	*//********************************************************************************/

	ARRAY hlth G3a G3b G3c G3d G3e G3f G3g G3h G3i G3j G3k G3l G3m G3n G3o G3p G3q;
	G_health_prob=0;
	IF G1=5 THEN G_health_prob=1;
	ELSE DO OVER hlth; IF hlth=1 THEN G_health_prob=1; ELSE G_health_prob+0; END;

	/********************************************************************************//*
							Section H: Mental Health
	*//********************************************************************************/
	*SPD Measures;
	ARRAY h1 h1a h1b h1c h1d h1e h1f;
	ARRAY h1_score h1a_score h1b_score h1c_score h1d_score h1e_score h1f_score;
	DO OVER h1;
	IF h1 IN (1) THEN h1_score = 4;
	IF h1 IN (2) THEN h1_score = 3;
	IF h1 IN (3) THEN h1_score = 2;
	IF h1 IN (4) THEN h1_score = 1;
	IF h1 IN (5) THEN h1_score = 0;
	END;
	

	/*if h1a_score = . or h1b_score = . or h1c_score = . or h1d_score = . or h1e_score = .
	   or h1f_score = . then h1sum = .; else*/
	h1sum = h1a_score+h1b_score+h1c_score+h1d_score+h1e_score+h1f_score;
	
	IF h1SUM ge 13 THEN psych_distress = 1; ELSE IF 0 le h1SUM lt 13 THEN psych_distress = 0;
	ATTRIB psych_distress LABEL='Does the respondent K6 score indicate that they have serious psychological distress (SPD)?'
	 FORMAT=psych_distressf. ;

	*PTSD measures;
	ARRAY h2arr h2a--h2q;
	ARRAY h2arrsym h2asym h2bsym h2csym h2dsym h2esym h2fsym h2gsym h2hsym h2isym h2jsym
      h2ksym h2lsym h2msym h2nsym h2osym h2psym h2qsym;
	DO OVER h2arr;
	IF h2arr in ('3','4','5') THEN h2arrsym = 1; ELSE IF h2arr in ('1','2') THEN h2arrsym = 0;
	END;
	pcl_B = SUM(h2asym,h2bsym,h2csym,h2dsym,h2esym);
	pcl_C = SUM(h2fsym, h2gsym, h2hsym, h2isym, h2jsym, h2ksym);
	pcl_D = SUM(h2lsym, h2msym, h2nsym, h2osym, h2psym, h2qsym);
	IF pcl_B ge 1 and pcl_C ge 3 and pcl_d ge 2 THEN ptsd = 1; ELSE ptsd = 0;
	ptsd_SUM=SUM(pcl_B,pcl_c,pcl_d);
	ATTRIB ptsd LABEL='Does the respondent PTSD score indicate that they have PTSD?'
	 FORMAT=ptsdf. ;

	/********************************************************************************//*
							Section I: Family Head Substance Use
	*//********************************************************************************/
	
	*alcohol;
	IF I1=1 or I2=1 or I3=1 or I4=1 THEN I_alcohol=1; ELSE I_alcohol=0;
	*drugs;
	IF I6a=1 or I6b=1 or I6c=1 or I6d=1 or I6e=1 or I6f=1 or I6g=1 or I6h=1 or I7=1
		THEN I_drugs=1;ELSE I_Drugs=0;
	*substance abuse;
	IF I_alcohol=1 or I_drugs=1 THEN I_substance_use=1; ELSE I_substance_use=0;

	/********************************************************************************//*
					Section J: Foster Care/Group Home/Crim Justice/DV History
	*//********************************************************************************/

	 *Single variable for childhood separation;
	 IF j1a=1 or j1b=1 or j1c=1 THEN J1_dummy=1;
	 	ELSE IF J1a in(7,8) and J1b in(7,8) and J1c in(7,8) THEN J1_dummy=.;
		ELSE J1_dummy=0;
	 IF j2=1 THEN J2_dummy=1; ELSE IF j2=2 THEN j2_dummy=0; ELSE j2_dummy=.;
	 IF j3=1 THEN j3_dummy=1; ELSE IF j3=2 THEN j3_dummy=0; ELSE j3_dummy=.;

	 IF j2_dummy=1 OR e12_felony_dummy=1 THEN any_felony=1; ELSE any_felony=0;

	 *Adult well-being composite score;
	Adult_score=sum(psych_distress,ptsd,J1_dummy,J2_dummy,J3_dummy,G_health_prob, I_Substance_use);

		

	/********************************************************************************//*
							Section L: Demographics
	*//********************************************************************************/
	 *race;
	racecount=SUM(L2_1,L2_2,L2_3,L2_4,L2_5,L2_6,L2_96);
	IF L2_97=1 THEN L2=.;*missing -REF;
	ELSE IF L2_98=1 THEN L2=.;*missing -DK;
	ELSE IF L2_1=1 or racecount>1 THEN L2=1;*Multiracial;
	ELSE IF L2_4=1 THEN L2=4;*black/african american;
	ELSE IF L2_6=1 THEN L2=6;*white;
	ELSE IF L2_2=1 THEN L2=2;*Alaskan Native or American Indian;
	ELSE IF L2_3=1 THEN L2=3;*Asian;
	ELSE IF L2_5=1 THEN L2=5;*PacIFic Islander;
	ELSE IF L2_96=1 THEN L2=96;*Other;

	IF L1=1 THEN race_cat=1;
		ELSE IF L2=6 THEN race_cat=2;
		ELSE IF L2=4 THEN race_cat=3;
		ELSE IF L2 in(3,5) THEN race_cat=4;
		ELSE IF L2=1 THEN race_cat=5;
		ELSE IF L2 in(2,96) THEN race_cat=6;
		ELSE race_cat=.;

	*categorical age;
	IF 0< ageatra <21 THEN ageatra_cat=1;
		ELSE IF 21<=ageatra<25 THEN ageatra_cat=2;
		ELSE IF 25<=ageatra<30 THEN ageatra_cat=3;
		ELSE IF 30<=ageatra<35 THEN ageatra_cat=4;
		ELSE IF 35<=ageatra<45 THEN ageatra_cat=5;
		ELSE IF ageatra>=45 THEN ageatra_cat=6;
		ELSE ageatra_cat=.;

	*create educational attainment variable;
	SELECT (L5);
		WHEN (1,2) edu_attain=1;/*LT High School*/
		WHEN (3,4) edu_attain=2;/*High School Diploma and GED*/
		WHEN (5,6,7,8,9) edu_attain=3;/*GT High School*/
		OTHERWISE edu_attain=.;
	END;

	*additional dummy variables for frequencies;
	dummy=1;		
	

	 /* Formats, KEEP statement*/
	FORMAT /*a1 a1f.*/ fam_income_cat fam_income_catf. ageatra_cat ageatra_catf. b1_Cat B1_Catf. race_cat race_catf. 
	edu_attain edu_attainf. num_adults_cat num_adults_catf. num_child_cat num_child_catf.;
RUN;

/*
ODS TAGSETS.EXCELXP Style=normalprinter FILE="S:\Projects\Homefam\Data Documentation\Baseline Survey Contents 11_15_2012.xls";
PROC CONTENTS DATA=hfsurv.options_memo_all; RUN;
ODS TAGSETS.EXCELXP CLOSE;
*/


*create analysis dataset with just variables used in report frequencies
	apply labels to match report labels;
DATA hfsurv.options_memo_select ;
		SET hfsurv.options_memo_all (KEEP= family_id site_id ra_result shelter a1a--a1p a4_months
		b1a--b1s b1_bigprob b1_anyprob B1_Cat b1_evict b1_noprevlease
		c1_years c1_days c2 c2a c3 c3_comb c4 c5 c6_days c6_years c6_days_alt c6_years_alt c7 c8b c8_days c8_years
		d1 d3 d6 d6a d6_months d6_years D_Disabled d8_hours d12_wages
		e1 e2 e4 e5 e6 e6a Child_Sep num_adult_with num_child_with child_u3
			num_child_nw child_u3_nw child_3to6_nw child_7to12_nw child_foster_nw num_adult_nw
			flag_adultrost flag_childrost flag_childnwrost flag_adultnwrost childu15_noschl child_disab
			num_adults_cat num_child_cat num_in_hh
		f1a--f1p f2 fam_income_cat 
		g1 g2 g3a--g3q G_health_prob 
		I_alcohol I_drugs I_substance_use
		psych_distress ptsd
		j1a j1b j1c j2 j3 j1_dummy j2_dummy j3_dummy
		l1 l2 l3 ageatra ageatra_cat l5 l6 race_cat edu_attain
		d6mm d6yyyy c1a1 c1a2 c1a3 c1a4 c6a1 c6a2 c6a3 c6a4 c8a1 c8a2 c8a3 c8a4 c8a5_97 c8a6_98 
		adult_score);
RUN;




*Danny request 10/2/12;

/*ODS TAGSETS.EXCELXP Style=NormalPrinter FILE='H:\HCR\HomeFam\Task 6--Interim Report\Data Documentation\Danny Requests\HH Heads 10-2-2012.xls' 
OPTIONS(Sheet_Name='HHheads' embedded_titles='No');
PROC FREQ DATA=hfsurv.jill_hhcomp;
TABLES l3 l3*e8_1*e7_1*e8_2*e7_2/LIST MISSING;
RUN;
ODS TAGSETS.EXCELXP CLOSE;*/


*check adults as part of hh size;
/*PROC FREQ DATA=hfsurv.options_memo_all;
TABLES num_in_hh*num_adult_with /norow nocol ;
RUN;*/

*for lauren - check number of men and women;
/*PROC SQL;
	CREATE TABLE tot_person AS
	SELECT SUM(all_men) AS MEN 'All Adult Men',
			SUM(all_women) AS WOMEN 'All Adult Women',
			SUM(num_adult_with) AS  'Total Non-HoH Adults',
			SUM(num_child_with) 'Total Children'
			SUM(num_in_hh) 'Total Persons'
	FROM hfsurv.options_memo_all;
QUIT;*/







					/* CHAPTER 1 -- additional datasets */

*JSB Request 10-15-12 -- re-run top PBTH acceptances;
ODS TAGSETS.EXCELXP STYLE=normalprinter FILE="S:\Projects\Homefam\Output\Other Requests\JBS_THAcceptances_101512.xls";
PROC SQL;
	SELECT Site_id,Provider_Name_dedup, SUM(Accepted) AS Tot_Accepted
	FROM hfsurv.options_memo_all (KEEP= family_id site_id ra_result Provider_Name_dedup shelter
			Contacted Accepted MoveIn Refusal)
	WHERE RA_Result='PBTH'
	GROUP BY Site_id, Provider_Name_dedup
	HAVING Tot_Accepted>0
	ORDER BY Tot_Accepted DESC;
QUIT;
ODS TAGSETS.EXCELXP CLOSE;
ODS TAGSETS.EXCELXP STYLE=normalprinter FILE="S:\Projects\Homefam\Output\Other Requests\JBS_CBRRAcceptances_101512.xls";
PROC SQL;
	SELECT Site_id,Provider_Name_dedup, SUM(Accepted) AS Tot_Accepted
	FROM hfsurv.options_memo_all (KEEP= family_id site_id ra_result Provider_Name_dedup shelter
			Contacted Accepted MoveIn Refusal)
	WHERE RA_Result='CBRR'
	GROUP BY Site_id, Provider_Name_dedup
	HAVING Tot_Accepted>0
	ORDER BY Tot_Accepted DESC;
QUIT;
ODS TAGSETS.EXCELXP CLOSE;



PROC MEANS DATA=hfsurv.options_memo_all noprint;
CLASS site_id ra_result provider_name_dedup;
OUTPUT OUT=programs_summ2 N(family_id)=Referred 
	SUM(Contacted Accepted MoveIn Refusal) = Contacted Accepted MoveIn Refusal;
RUN;

PROC MEANS DATA=hfsurv.options_memo_all noprint;
CLASS site_id shelter_name;
OUTPUT OUT=shelters_summ2 N(family_id)=Referred 
	SUM(Contacted Accepted MoveIn ) = Contacted Accepted MoveIn ;
RUN;

DATA programs_summ3; SET programs_summ2;WHERE _TYPE_=7 and ra_result~='UC';	program_count=1;RUN;
DATA shelters_summ3; LENGTH Provider_Name_dedup $200.;
	SET shelters_summ2;WHERE _TYPE_=3;	program_count=1;ra_result='UC';provider_name_dedup=shelter_name;RUN;

DATA hfsurv.programs_summ; SET programs_summ3 shelters_summ3;RUN;

/*proc sql;
	SELECT provider_name, N(family_id)
	FROM hfsurv.options_memo_all
	GROUP BY provider_name;
QUIT;
proc sql;
	SELECT provider_name_dedup, SUM(program_count) AS sumprog LABEL='sumprog'
	FROM hfsurv.programs_summ
	GROUP BY provider_name_dedup
	ORDER BY ra_result, site_id, provider_name_dedup;
QUIT;*/

*Get HIC_PIT/Census/BLS for Exhibit 1-4 & 1-5 from Lauren -- create dataset;
PROC IMPORT OUT=commcontext_hp replace
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Community Context Data.xlsx" 
			DBMS=EXCELCS;
			SHEET="HICandPITforSAS"	;
RUN;
PROC IMPORT OUT=commcontext_census replace
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Community Context Data.xlsx" 
			DBMS=EXCELCS;
			SHEET="CensusforSAS"	;
RUN;
PROC IMPORT OUT=commcontext_bls replace
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Community Context Data.xlsx" 
			DBMS=EXCELCS;
			SHEET="BLSforSAS"	;
RUN;
PROC SORT DATA=commcontext_hp; BY site; RUN; 
PROC SORT DATA=commcontext_census; BY site; RUN;
PROC SORT DATA=commcontext_bls; BY site; RUN;
*Merge the three datasets;
DATA hfsurv.communitycontextdata;
	MERGE commcontext_hp commcontext_census commcontext_bls;
	WHERE site~=' ';
	BY site;
RUN;



					/* CHAPTER 2 -- additional datasets */

*Read in Program Data Forms for chapter 2;
	*Case Management;
PROC IMPORT OUT= cm_es REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Case Management 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="ESforSAS"	;
RUN;
PROC IMPORT OUT= cm_cbrr REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Case Management 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="RRforSAS"	;
RUN;
PROC IMPORT OUT= cm_th REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Case Management 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="THforSAS"	;
RUN;
PROC IMPORT OUT= cm_sub REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Case Management 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS ; SHEET="SUBforSAS"	;
RUN;
	*Housing Features;
PROC IMPORT OUT= hfsurv.feat_es REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Housing Features and Subsidy Types 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="ESforSAS"	;
RUN;
PROC IMPORT OUT= hfsurv.feat_cbrr REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Housing Features and Subsidy Types 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="RRforSAS"	;
RUN;
PROC IMPORT OUT= hfsurv.feat_th REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Housing Features and Subsidy Types 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="THforSAS"	;
RUN;
PROC IMPORT OUT= hfsurv.feat_thunit REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Housing Features and Subsidy Types 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="TH UNIT SIZE"	;
RUN;
PROC IMPORT OUT= hfsurv.feat_sub REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Housing Features and Subsidy Types 12-05-12 forSAS.xlsx" 
			DBMS=EXCELCS ; SHEET="SUBforSAS"	;
RUN;
	*Program Rules;
PROC IMPORT OUT= rules_es REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Rules coding 7-20-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="ESforSAS"	;
RUN;
PROC IMPORT OUT= rules_th REPLACE
			DATAFILE="S:\Projects\Homefam\Data Documentation\Copies of Datasets Used In Interim Report\Rules coding 7-20-12 forSAS.xlsx" 
			DBMS=EXCELCS; SHEET="THforSAS"	;
RUN;

*format rules datasets;
DATA hfsurv.rules_th;
	SET rules_th;
	*created inverted variable for daytime/overnight visitors.
		Was initially coded as 0 = Limit, 1 = No limit but recoded so consistent with other rules vars codings;
	IF daytime_visitors=1 THEN daytime_visitors_invert=0;
		ELSE IF daytime_visitors=0 THEN daytime_visitors_invert=1;
	IF overnight_visitors=1 THEN overnight_visitors_invert=0;
		ELSE IF overnight_visitors=0 THEN overnight_visitors_invert=1;
	LABEL
		daily_curfew='Weekday curfew' 
		Weekend_curfew='Weekend curfew' 
		daytime_visitors_invert='Limit on daytime visitors' 
		overnight_visitors_invert='Limit on overnight visitors' 
		Service_requirements='Compliance with mandatory service requirements';
RUN;

DATA hfsurv.rules_es;
	SET rules_es;
	*created inverted variable for daytime/overnight visitors.
		Was initially coded as 0 = Limit, 1 = No limit but recoded so consistent with other rules vars codings;
	IF daytime_visitors=1 THEN daytime_visitors_invert=0;
		ELSE IF daytime_visitors=0 THEN daytime_visitors_invert=1;
	IF overnight_visitors=1 THEN overnight_visitors_invert=0;
		ELSE IF overnight_visitors=0 THEN overnight_visitors_invert=1;
	LABEL
		daily_curfew='Weekday curfew' 
		diff_Weekend_curfew='Weekend curfew' 
		daytime_visitors_invert='Limit on daytime visitors' 
		overnight_visitors_invert='Limit on overnight visitors' 
		Service_requirements='Compliance with mandatory service requirements';
RUN;

DATA hfsurv.casemanagement;
	LENGTH prgtype $4;
	SET cm_es cm_cbrr cm_th cm_sub;
	WHERE provider ~= ' ';
	IF prg_type='CB' THEN prgtype='CBRR'; 
	ELSE IF prg_type='SU' THEN prgtype='SUB';
	ELSE IF prg_type='TH' THEN prgtype='PBTH';
	ELSE prgtype=prg_type;

	IF Ext_employ_complab=1 or Ext_employ_training=1 THEN ext_employ=1;ELSE ext_employ=0;
	IF Int_employ_complab=1 or Int_employ_training=1 THEN Int_employ=1;ELSE Int_employ=0;
	IF int_selfsuff_childcare=1 or int_selfsuff_eduged=1 or int_selfsuff_finmgmt=1 or
		int_selfsuff_general=1 or int_selfsuff_pubbene=1 or int_selfsuff_transp=1 THEN int_selfsuff=1;ELSE int_selfsuff=0;
	IF ext_selfsuff_childcare=1 or ext_selfsuff_eduged=1 or ext_selfsuff_finmgmt=1 or
		ext_selfsuff_any=1 or ext_selfsuff_pubbene=1 or ext_selfsuff_transp=1 THEN ext_selfsuff=1;ELSE ext_selfsuff=0;
	DROP prg_type;
	LABEL 
	Serv_hsgassist='Housing search and placement assistance'
	Serv_selfsuff='Self-sufficiency (e.g., financial literacy, money management, help obtaining public benefits, education, transportation, childcare, and after-school care)' 
	Serv_employ ='Employment training'
	serv_lifeskills='Life skills' 
	serv_physHC ='Physical health care'
	serve_childadvoc ='Child advocacy'
	serv_parentingskills ='Parenting skills'
	serv_mentalHC ='Mental health care' 
	cm_hsgassist='Housing search and placement assistance'
	cm_selfsuff='Self-sufficiency (e.g., financial literacy, money management, help obtaining public benefits, education, transportation, childcare, and after-school care)' 
	cm_employ ='Employment training'
	cm_lifeskills='Life skills' 
	cm_physHC ='Physical health care'
	cm_childadvoc ='Child advocacy'
	cm_parentingskills ='Parenting skills'
	cm_mentalHC ='Mental health care'
	int_hsgassist='Housing search and placement assistance'
	int_selfsuff='Self-sufficiency (e.g., financial literacy, money management, help obtaining public benefits, education, transportation, childcare, and after-school care)' 
	int_employ ='Employment training'
	int_lifeskills='Life skills' 
	int_physHC ='Physical health care'
	int_childadvoc ='Child advocacy'
	int_parentingskills ='Parenting skills'
	int_mentalHC ='Mental health care'
	ext_hsgassist='Housing search and placement assistance'
	ext_selfsuff='Self-sufficiency (e.g., financial literacy, money management, help obtaining public benefits, education, transportation, childcare, and after-school care)' 
	ext_employ ='Employment training'
	ext_lifeskills='Life skills' 
	ext_physHC ='Physical health care'
	ext_childadvoc ='Child advocacy'
	ext_parentingskills ='Parenting skills'
	ext_mentalHC ='Mental health care' 

	int_selfsuff_childcare='Childcare/after-school care' 
	int_selfsuff_finmgmt='Financial management' 
	int_selfsuff_pubbene='Help obtaining public benefits' 
	int_selfsuff_transp='Transportation'
	ext_selfsuff_childcare='Childcare/after-school care' 
	ext_selfsuff_finmgmt='Financial management' 
	ext_selfsuff_pubbene='Help obtaining public benefits' 
	ext_selfsuff_transp='Transportation'

	Serv_substabuse='Substance abuse'
	Serv_familyreunif='Family reunification'
	CM_substabuse='Substance abuse'
	CM_familyreunif='Family reunification'
	Int_substabuse='Substance abuse'
	Int_familyreunif='Family reunification'
	Ext_substabuse='Substance abuse'
	Ext_familyreunif='Family reunification'
	;
RUN;

proc contents data=hfsurv.casemanagement;run;



/*Eligibility question analyses*/
/******************************************************//*

Title: EligibilityAnalysis
Program Name: EligibilityQ_Analysis
Programmer: Scott Brown
Last Updated: 6/11/2012

Previous Programs Used: CreateBaselineDataset.sas

Files imported: hfsurv.master_02292012
Files created: 

*//******************************************************/

*Families eligibilty question answers;
PROC IMPORT OUT=elig_info replace
			DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Eligibility\Copy of eligibility_answers.xls" 
			DBMS=XLS;
			GETNAMES=YES;
RUN;
*families entirely screened out as ineligible;
PROC IMPORT OUT=inelig_info replace
			DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Eligibility\Ineligibility Matrix  Report.xls" 
			DBMS=XLS;
			GETNAMES=YES;
RUN;




DATA eligibility;
	SET elig_info (in=aa RENAME=(familystudy_id=family_id) DROP=lastupdatedate)
		inelig_info (in=bb DROP=site_name first_name last_name have_spouse last_modified create_date);
	*set up array for each type of eligibility question;
	IF bb THEN Ineligible=1; ELSE Ineligible=0;

	*Dropped E32 (pets --only 7 asked, zero no's),e33 & e34 (artifact of study), set E73 as max income?;
	ARRAY minincemp E2-E6 E8 E66 E79 E87; /*9 Qs*/
	ARRAY rent E45 E57 E63-E65 E78 E80 E83; /*8 Qs*/
	ARRAY maxinc E38 E73; /*2 Q */
	ARRAY eduwork E1 E7 ;/*2 Qs*/
	ARRAY fam E15 E53-E56 E58 E62 E75 E82 E100;/*10 Qs*/
	ARRAY unit E12-E14 E36 E42-E44 E69 E70 E74 E77 E84-E86;/*14 Qs*/
	ARRAY health E16 E61; /*2 Qs*/
	ARRAY DV E99; /*1 Q*/
	ARRAY disab E47 E48; /*2 Qs*/
	ARRAY sober E17-E19 E20 E35 E52; /*6 Qs*/
	ARRAY crim E21-E27 E46 E59;/*9 Qs*/
	ARRAY citizen E28 E29 E81;/*3 Qs*/
	ARRAY particip E30 E31 E39 E51 E88;/*5 Qs*/
	ARRAY location E40 E41 E49 E50 E60 E73 E76 E89 E90-E97; /*18 Qs*/
	ARRAY stability E68 E71; /*2 Qs*/
	ARRAY credit E9 E11 E37 E67 E98; /*5 Qs*/
	ARRAY arrears E10; /*1 Q*/
	ARRAY meta_b inelig_minincemp inelig_rent inelig_maxinc inelig_eduwork 
	inelig_fam inelig_unit inelig_health inelig_DV inelig_disab 
	inelig_sober inelig_crim inelig_citizen inelig_particip 
	inelig_location inelig_stability inelig_credit inelig_arrears;

	minincemp_sum=sum(of E2-E6, E8, E66, E79, E87);
	rent_sum=sum(of E45, E57, of E63-E65, E78, E80, E83);
	maxinc_sum=sum(E38);
	eduwork_sum=sum(of E1, E7);
	fam_sum=sum(of E15, of E53-E56, E58 , E62, E75, E82, E100);
	unit_sum=sum(of E12-E14, E36, of E42-E44, E69, E70, E74, E77, of E84-E86);
	health_sum=sum(of E16, E61);
	DV_sum=sum(E99);
	disab_sum=sum(E47, E48);
	sober_sum=sum(of E17-E19, E20, E35, E52);
	crim_sum=sum(of E21-E27, E46, E59);
	citizen_sum=sum(of E28, E29, E81);
	particip_sum=sum(of E30, E31, E39, E51, E88);
	location_sum=sum(of E33, E34, E40, E41, E49, E50, E60, E73, E76, E89, of E90-E97);
	stability_sum=sum(of E68, E71);
	credit_sum=sum(of E9, E11, E37, E67, E98);
	arrears_sum=sum(E10);
	
	*Create flag for asked question and for no answer by type;
	DO OVER meta_b; meta_b=0; END;
	DO OVER minincemp; IF minincemp=2 THEN inelig_minincemp=1; ELSE inelig_minincemp+0; END;
	DO OVER rent; IF rent=2 THEN inelig_rent=1; ELSE inelig_rent+0; END;
	DO OVER maxinc; IF maxinc=2 THEN inelig_maxinc=1; ELSE inelig_maxinc+0; END;
	DO OVER eduwork; IF eduwork=2 THEN inelig_eduwork=1; ELSE inelig_eduwork+0; END;
	DO OVER fam; IF fam=2 THEN inelig_fam=1; ELSE inelig_fam+0; END;
	DO OVER unit; IF unit=2 THEN inelig_unit=1; ELSE inelig_unit+0; END;
	DO OVER health; IF health=2 THEN inelig_health=1; ELSE inelig_health+0; END;
	DO OVER dv; IF dv=2 THEN inelig_dv=1; ELSE inelig_dv+0; END;
	DO OVER disab; IF disab=2 THEN inelig_disab=1; ELSE inelig_disab+0; END;
	DO OVER sober; IF sober=2 THEN inelig_sober=1; ELSE inelig_sober+0; END;
	DO OVER crim; IF crim=2 THEN inelig_crim=1; ELSE inelig_crim+0; END;
	DO OVER citizen; IF citizen=2 THEN inelig_citizen=1; ELSE inelig_citizen+0; END;
	DO OVER particip; IF particip=2 THEN inelig_particip=1; ELSE inelig_particip+0; END;
	DO OVER location; IF location=2 THEN inelig_location=1; ELSE inelig_location+0; END;
	DO OVER stability; IF stability=2 THEN inelig_stability=1; ELSE inelig_stability+0; END;
	DO OVER credit; IF credit=2 THEN inelig_credit=1; ELSE inelig_credit+0; END;
	DO OVER arrears; IF arrears=2 THEN inelig_arrears=1; ELSE inelig_arrears+0; END;

	ARRAY meta_a minincemp_sum rent_sum maxinc_sum eduwork_sum fam_sum unit_sum health_sum dv_sum disab_sum
			sober_sum crim_sum 	citizen_sum particip_sum location_sum stability_sum credit_sum arrears_sum;
	ARRAY meta_c n_minincemp n_rent n_maxinc n_eduwork n_fam n_unit n_health n_dv n_disab n_sober n_crim n_citizen n_particip 
		n_location n_stability n_credit n_arrears;
	*create Ns
		If meta_a (sum of the category) = 0 then the corresponding inelig_xx var should be set to missing because 
			the question was not asked.
		meta_c -- the n for each category -- then says if the inelig_cc var is 0 or 1 (i.e., if asked the question), then
			set to 1, otherwise set to zero. Then the sum will equal the N;
	DO OVER meta_a; 
		IF meta_a=0 THEN meta_b=.; ELSE meta_b=meta_b; 
		IF meta_b in(0,1) THEN meta_c=1; ELSE meta_c=0;
	END;

	
RUN;

PROC SORT DATA=eligibility OUT=eligibility_s; BY family_id; RUN;

PROC SORT DATA=hfsurv.master_01142013 (KEEP=family_id) OUT=famid; BY family_id; RUN;


/*Re-run based on Brooke's table shells*/

*Person pools for each intervention;

*elig_screened_xxx is those who were screened for the intervention
 elig_lost_xxx is those who were screened out of an intervention;
DATA elig_screened_SUB elig_lost_SUB elig_screened_CBRR elig_lost_CBRR elig_screened_PBTH elig_lost_PBTH elig_screened_UC;
	MERGE eligibility_s famid (in=dd) hfsurv.elig_change_07302012 (in=ee);
	BY family_id;
	IF ee;

	IF pre_SUB=1 THEN OUTPUT elig_screened_SUB;
	IF pre_CBRR=1 THEN OUTPUT elig_screened_CBRR;
	IF pre_PBTH=1 THEN OUTPUT elig_screened_PBTH;
	OUTPUT elig_screened_UC;
	IF pre_SUB=1 AND post_SUB=0 THEN OUTPUT elig_lost_SUB;
	IF pre_CBRR=1 AND post_CBRR=0 THEN OUTPUT elig_lost_CBRR;
	IF pre_PBTH=1 AND post_PBTH=0 THEN OUTPUT elig_lost_PBTH;
RUN;
*Ns from log:
elig_screened_SUB: 1810		elig_lost_SUB: 	30
elig_screened_CBRR: 1924	elig_lost_CBRR: 86
elig_screened_PBTH: 1564	elig_lost_PBTH: 356;


*Provider side

Need to match the questions SUB providers at the site asked with the persons answering
Goal--if question only asked by CBRR providers and person said no, don't care when looking at SUB

So need to create a site by site E1 to E100 for each intervention
End up with 12 sites x 3 intervention (minus intervention if not avail at site) rows that can be linked up by site id
Then link SUB rows to those screened for SUB, CBRR rows

Once linked, if person not asked question by SUB provider, then set their answer to zero;

PROC IMPORT OUT=provider_elig replace
			DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Eligibility\Eligibility Matrix Report.xls" 
			DBMS=XLS;
			GETNAMES=YES;
			SHEET="Eligibility Matrix  Report.xls ";
RUN;
PROC IMPORT OUT=provider_elig2 replace
			DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Eligibility\Eligibility Matrix Report.xls" 
			DBMS=XLS;
			GETNAMES=YES;
			SHEET="QBySiteIntervention2";
RUN;
DATA SUB_elig_qs (keep=site_id summ_E1-summ_E100)
	CBRR_elig_qs (keep=site_id summ_E1-summ_E100)
	PBTH_elig_qs (keep=site_id summ_E1-summ_E100);
	SET provider_elig2;
	IF Intervention='CBRR' THEN OUTPUT CBRR_elig_qs;
	IF Intervention='PBTH' THEN OUTPUT PBTH_elig_qs;
	IF Intervention='SUB' THEN OUTPUT SUB_elig_qs;
RUN;

PROC SORT DATA=elig_screened_SUB OUT=elig_screened_SUB_s; BY site_id; RUN;

DATA screened_SUB_match screenedout_SUB_match;
	MERGE elig_screened_SUB_s (in=aa keep=family_id site_id e1-e100 pre_SUB post_SUB) SUB_elig_qs (in=bb);
	BY site_id;
	IF aa and bb;
	ARRAY clientE E1-E100;
	ARRAY providerE summ_E1-summ_e100;
	ARRAY clientnewE E_ADJ1-E_ADJ100;
	*Set questions not asked by SUB providers to zero (by site) so do not factor into analysis;
	DO OVER clientE; IF ProviderE=0 THEN clientnewE=0; ELSE clientnewE=ClientE; END;

	
	*Dropped E32 (pets --only 7 asked, zero no's),e33 & e34 (artifact of study), set E73 as max income?;
	ARRAY minincemp E_ADJ2-E_ADJ6 E_ADJ8 E_ADJ66 E_ADJ79 E_ADJ87; /*9 Qs*/
	ARRAY rent E_ADJ45 E_ADJ57 E_ADJ63-E_ADJ65 E_ADJ78 E_ADJ80 E_ADJ83; /*8 Qs*/
	ARRAY maxinc E_ADJ38 E_ADJ73; /*2 Q */
	ARRAY eduwork E_ADJ1 E_ADJ7 ;/*2 Qs*/
	ARRAY fam E_ADJ15 E_ADJ53-E_ADJ56 E_ADJ58 E_ADJ62 E_ADJ75 E_ADJ82 E_ADJ100;/*10 Qs*/
	ARRAY unit E_ADJ12-E_ADJ14 E_ADJ36 E_ADJ42-E_ADJ44 E_ADJ69 E_ADJ70 E_ADJ74 E_ADJ77 E_ADJ84-E_ADJ86;/*14 Qs*/
	ARRAY health E_ADJ16 E_ADJ61; /*2 Qs*/
	/*ARRAY DV E_ADJ99; 1 Q*/
	ARRAY disab E_ADJ47 E_ADJ48; /*2 Qs*/
	ARRAY sober E_ADJ17-E_ADJ19 E_ADJ20 E_ADJ35 E_ADJ52; /*6 Qs*/
	ARRAY crim E_ADJ21-E_ADJ27 E_ADJ46 E_ADJ59;/*9 Qs*/
	ARRAY citizen E_ADJ28 E_ADJ29 E_ADJ81;/*3 Qs*/
	ARRAY particip E_ADJ30 E_ADJ31 E_ADJ39 E_ADJ51 E_ADJ88;/*5 Qs*/
	ARRAY location E_ADJ40 E_ADJ41 E_ADJ49 E_ADJ50 E_ADJ60 E_ADJ73 E_ADJ76 E_ADJ89 E_ADJ90-E_ADJ97; /*18 Qs*/
	ARRAY stability E_ADJ68 E_ADJ71; /*2 Qs*/
	ARRAY credit E_ADJ9 E_ADJ11 E_ADJ37 E_ADJ67 E_ADJ98; /*5 Qs*/
	/*ARRAY arrears E_ADJ10; 1 Q */
	ARRAY meta_b inelig_minincemp inelig_rent inelig_maxinc inelig_eduwork 
	inelig_fam inelig_unit inelig_health inelig_DV inelig_disab 
	inelig_sober inelig_crim inelig_citizen inelig_particip 
	inelig_location inelig_stability inelig_credit inelig_arrears;

	minincemp_sum=sum(of E_ADJ2-E_ADJ6, E_ADJ8, E_ADJ66, E_ADJ79, E_ADJ87);
	rent_sum=sum(of E_ADJ45, E_ADJ57, of E_ADJ63-E_ADJ65, E_ADJ78, E_ADJ80, E_ADJ83);
	maxinc_sum=sum(E_ADJ38 , E_ADJ73);
	eduwork_sum=sum(of E_ADJ1, E_ADJ7);
	fam_sum=sum(of E_ADJ15, E_ADJ53-E_ADJ56, E_ADJ58 , E_ADJ62, E_ADJ75, E_ADJ82, E_ADJ100);
	unit_sum=sum(of E_ADJ12-E_ADJ14, E_ADJ36, of E_ADJ42-E_ADJ44, E_ADJ69, E_ADJ70, E_ADJ74, E_ADJ77, of E_ADJ84-E_ADJ86);
	health_sum=sum(of E_ADJ16, E_ADJ61);
	DV_sum=E_ADJ99;
	disab_sum=sum(E_ADJ47, E_ADJ48);
	sober_sum=sum(of E_ADJ17-E_ADJ19, E_ADJ20, E_ADJ35, E_ADJ52);
	crim_sum=sum(of E_ADJ21-E_ADJ27, E_ADJ46, E_ADJ59);
	citizen_sum=sum(of E_ADJ28, E_ADJ29, E_ADJ81);
	particip_sum=sum(of E_ADJ30, E_ADJ31, E_ADJ39, E_ADJ51, E_ADJ88);
	location_sum=sum(of E_ADJ33, E_ADJ34, E_ADJ40, E_ADJ41, E_ADJ49, E_ADJ50, E_ADJ60, E_ADJ73, E_ADJ76, E_ADJ89, of E_ADJ90-E_ADJ97);
	stability_sum=sum(of E_ADJ68, E_ADJ71);
	credit_sum=sum(of E_ADJ9, E_ADJ11, E_ADJ37, E_ADJ67, E_ADJ98);
	arrears_sum=E_ADJ10;
	
	*Create flag for asked question and for no answer by type;
	DO OVER meta_b; meta_b=0; END;
	DO OVER minincemp; IF minincemp=2 THEN inelig_minincemp=1; ELSE inelig_minincemp+0; END;
	DO OVER rent; IF rent=2 THEN inelig_rent=1; ELSE inelig_rent+0; END;
	DO OVER maxinc; IF maxinc=2 THEN inelig_maxinc=1; ELSE inelig_maxinc+0; END;
	DO OVER eduwork; IF eduwork=2 THEN inelig_eduwork=1; ELSE inelig_eduwork+0; END;
	DO OVER fam; IF fam=2 THEN inelig_fam=1; ELSE inelig_fam+0; END;
	DO OVER unit; IF unit=2 THEN inelig_unit=1; ELSE inelig_unit+0; END;
	DO OVER health; IF health=2 THEN inelig_health=1; ELSE inelig_health+0; END;
	IF E_ADJ99=2 THEN inelig_dv=1; ELSE inelig_dv+0; 
	DO OVER disab; IF disab=2 THEN inelig_disab=1; ELSE inelig_disab+0; END;
	DO OVER sober; IF sober=2 THEN inelig_sober=1; ELSE inelig_sober+0; END;
	DO OVER crim; IF crim=2 THEN inelig_crim=1; ELSE inelig_crim+0; END;
	DO OVER citizen; IF citizen=2 THEN inelig_citizen=1; ELSE inelig_citizen+0; END;
	DO OVER particip; IF particip=2 THEN inelig_particip=1; ELSE inelig_particip+0; END;
	DO OVER location; IF location=2 THEN inelig_location=1; ELSE inelig_location+0; END;
	DO OVER stability; IF stability=2 THEN inelig_stability=1; ELSE inelig_stability+0; END;
	DO OVER credit; IF credit=2 THEN inelig_credit=1; ELSE inelig_credit+0; END;
	IF E_ADJ10=2 THEN inelig_arrears=1; ELSE inelig_arrears+0; 

	ARRAY meta_a minincemp_sum rent_sum maxinc_sum eduwork_sum fam_sum unit_sum health_sum dv_sum disab_sum
			sober_sum crim_sum 	citizen_sum particip_sum location_sum stability_sum credit_sum arrears_sum;
	ARRAY meta_c n_minincemp n_rent n_maxinc n_eduwork n_fam n_unit n_health n_dv n_disab n_sober n_crim n_citizen n_particip 
		n_location n_stability n_credit n_arrears;
	DO OVER meta_a; 
		IF meta_a=0 THEN meta_b=.; ELSE meta_b=meta_b; 
		IF meta_b in(0,1) THEN meta_c=1; ELSE meta_c=0;
	END;
	OUTPUT screened_SUB_match;
	IF pre_SUB=1 and post_SUB=0 THEN OUTPUT screenedout_SUB_match;
RUN;

PROC MEANS DATA=screened_SUB_match SUM ;
VAR  pre_sub n_minincemp n_rent n_maxinc n_eduwork n_fam n_unit n_health n_dv n_disab n_sober n_crim n_citizen n_particip n_location n_stability
n_credit n_arrears;
OUTPUT OUT=SUB_elig_summ SUM(pre_sub n_minincemp--n_arrears)= /autoname;
RUN;

DATA sub_elig_summ2;
	SET sub_elig_summ;
	Prgtype='SUB';
	ARRAY BB n_minincemp_sum n_rent_sum n_maxinc_sum n_eduwork_sum n_fam_sum n_unit_sum n_health_sum 
			n_dv_sum n_disab_sum n_sober_sum n_crim_sum n_citizen_sum n_particip_sum n_location_sum n_stability_sum 
			n_credit_sum n_arrears_sum;
	ARRAY CC per_minincemp per_rent per_maxinc per_eduwork per_fam per_unit per_health 
			per_dv per_disab per_sober per_crim per_citizen per_particip per_location per_stability 
			per_credit per_arrears;
	DO OVER BB; IF BB not in(0,.) THEN CC=BB/pre_sub_sum; ELSE CC=0; END;
	FORMAT per_minincemp per_rent per_maxinc per_eduwork per_fam per_unit per_health per_dv per_disab 
			per_sober per_crim per_citizen per_particip per_location per_stability per_credit per_arrears percent10.1;
	KEEP   prgtype per_: ;
RUN;

PROC TRANSPOSE DATA=sub_elig_summ2 OUT=sub_elig_tp NAME=Qtype; ID prgtype; VAR per_: ; RUN;


*CBRR;

PROC SORT DATA=elig_screened_CBRR OUT=elig_screened_CBRR_s; BY site_id; RUN;

DATA screened_CBRR_match screenedout_CBRR_match;
	MERGE elig_screened_CBRR_s (in=aa keep=family_id site_id e1-e100 pre_CBRR post_CBRR) CBRR_elig_qs (in=bb);
	BY site_id;
	IF aa and bb;
	ARRAY clientE E1-E100;
	ARRAY providerE summ_E1-summ_E100;
	ARRAY clientnewE E_ADJ1-E_ADJ100;
	DO OVER clientE; IF ProviderE=0 THEN clientnewE=0; ELSE clientnewE=ClientE; END;

	
	*Dropped E32 (pets --only 7 asked, zero no's),e33 & e34 (artifact of study), set E73 as max income?;
	ARRAY minincemp E_ADJ2-E_ADJ6 E_ADJ8 E_ADJ66 E_ADJ79 E_ADJ87; /*9 Qs*/
	ARRAY rent E_ADJ45 E_ADJ57 E_ADJ63-E_ADJ65 E_ADJ78 E_ADJ80 E_ADJ83; /*8 Qs*/
	ARRAY maxinc E_ADJ38 E_ADJ73; /*2 Q */
	ARRAY eduwork E_ADJ1 E_ADJ7 ;/*2 Qs*/
	ARRAY fam E_ADJ15 E_ADJ53-E_ADJ56 E_ADJ58 E_ADJ62 E_ADJ75 E_ADJ82 E_ADJ100;/*10 Qs*/
	ARRAY unit E_ADJ12-E_ADJ14 E_ADJ36 E_ADJ42-E_ADJ44 E_ADJ69 E_ADJ70 E_ADJ74 E_ADJ77 E_ADJ84-E_ADJ86;/*14 Qs*/
	ARRAY health E_ADJ16 E_ADJ61; /*2 Qs*/
	/*ARRAY DV E_ADJ99; 1 Q*/
	ARRAY disab E_ADJ47 E_ADJ48; /*2 Qs*/
	ARRAY sober E_ADJ17-E_ADJ19 E_ADJ20 E_ADJ35 E_ADJ52; /*6 Qs*/
	ARRAY crim E_ADJ21-E_ADJ27 E_ADJ46 E_ADJ59;/*9 Qs*/
	ARRAY citizen E_ADJ28 E_ADJ29 E_ADJ81;/*3 Qs*/
	ARRAY particip E_ADJ30 E_ADJ31 E_ADJ39 E_ADJ51 E_ADJ88;/*5 Qs*/
	ARRAY location E_ADJ40 E_ADJ41 E_ADJ49 E_ADJ50 E_ADJ60 E_ADJ73 E_ADJ76 E_ADJ89 E_ADJ90-E_ADJ97; /*18 Qs*/
	ARRAY stability E_ADJ68 E_ADJ71; /*2 Qs*/
	ARRAY credit E_ADJ9 E_ADJ11 E_ADJ37 E_ADJ67 E_ADJ98; /*5 Qs*/
	/*ARRAY arrears E_ADJ10; 1 Q*/
	ARRAY meta_b inelig_minincemp inelig_rent inelig_maxinc inelig_eduwork 
	inelig_fam inelig_unit inelig_health inelig_DV inelig_disab 
	inelig_sober inelig_crim inelig_citizen inelig_particip 
	inelig_location inelig_stability inelig_credit inelig_arrears;

	minincemp_sum=sum(of E_ADJ2-E_ADJ6, E_ADJ8, E_ADJ66, E_ADJ79, E_ADJ87);
	rent_sum=sum(of E_ADJ45, E_ADJ57, of E_ADJ63-E_ADJ65, E_ADJ78, E_ADJ80, E_ADJ83);
	maxinc_sum=sum(E_ADJ38 , E_ADJ73);
	eduwork_sum=sum(of E_ADJ1, E_ADJ7);
	fam_sum=sum(of E_ADJ15, E_ADJ53-E_ADJ56, E_ADJ58 , E_ADJ62, E_ADJ75, E_ADJ82, E_ADJ100);
	unit_sum=sum(of E_ADJ12-E_ADJ14, E_ADJ36, of E_ADJ42-E_ADJ44, E_ADJ69, E_ADJ70, E_ADJ74, E_ADJ77, of E_ADJ84-E_ADJ86);
	health_sum=sum(of E_ADJ16, E_ADJ61);
	DV_sum=E_ADJ99;
	disab_sum=sum(E_ADJ47, E_ADJ48);
	sober_sum=sum(of E_ADJ17-E_ADJ19, E_ADJ20, E_ADJ35, E_ADJ52);
	crim_sum=sum(of E_ADJ21-E_ADJ27, E_ADJ46, E_ADJ59);
	citizen_sum=sum(of E_ADJ28, E_ADJ29, E_ADJ81);
	particip_sum=sum(of E_ADJ30, E_ADJ31, E_ADJ39, E_ADJ51, E_ADJ88);
	location_sum=sum(of E_ADJ33, E_ADJ34, E_ADJ40, E_ADJ41, E_ADJ49, E_ADJ50, E_ADJ60, E_ADJ73, E_ADJ76, E_ADJ89, of E_ADJ90-E_ADJ97);
	stability_sum=sum(of E_ADJ68, E_ADJ71);
	credit_sum=sum(of E_ADJ9, E_ADJ11, E_ADJ37, E_ADJ67, E_ADJ98);
	arrears_sum=E_ADJ10;
	
	*Create flag for asked question and for no answer by type;
	DO OVER meta_b; meta_b=0; END;
	DO OVER minincemp; IF minincemp=2 THEN inelig_minincemp=1; ELSE inelig_minincemp+0; END;
	DO OVER rent; IF rent=2 THEN inelig_rent=1; ELSE inelig_rent+0; END;
	DO OVER maxinc; IF maxinc=2 THEN inelig_maxinc=1; ELSE inelig_maxinc+0; END;
	DO OVER eduwork; IF eduwork=2 THEN inelig_eduwork=1; ELSE inelig_eduwork+0; END;
	DO OVER fam; IF fam=2 THEN inelig_fam=1; ELSE inelig_fam+0; END;
	DO OVER unit; IF unit=2 THEN inelig_unit=1; ELSE inelig_unit+0; END;
	DO OVER health; IF health=2 THEN inelig_health=1; ELSE inelig_health+0; END;
	IF E_ADJ99=2 THEN inelig_dv=1; ELSE inelig_dv+0; 
	DO OVER disab; IF disab=2 THEN inelig_disab=1; ELSE inelig_disab+0; END;
	DO OVER sober; IF sober=2 THEN inelig_sober=1; ELSE inelig_sober+0; END;
	DO OVER crim; IF crim=2 THEN inelig_crim=1; ELSE inelig_crim+0; END;
	DO OVER citizen; IF citizen=2 THEN inelig_citizen=1; ELSE inelig_citizen+0; END;
	DO OVER particip; IF particip=2 THEN inelig_particip=1; ELSE inelig_particip+0; END;
	DO OVER location; IF location=2 THEN inelig_location=1; ELSE inelig_location+0; END;
	DO OVER stability; IF stability=2 THEN inelig_stability=1; ELSE inelig_stability+0; END;
	DO OVER credit; IF credit=2 THEN inelig_credit=1; ELSE inelig_credit+0; END;
	IF E_ADJ10=2 THEN inelig_arrears=1; ELSE inelig_arrears+0; 

	ARRAY meta_a minincemp_sum rent_sum maxinc_sum eduwork_sum fam_sum unit_sum health_sum dv_sum disab_sum
			sober_sum crim_sum 	citizen_sum particip_sum location_sum stability_sum credit_sum arrears_sum;
	ARRAY meta_c n_minincemp n_rent n_maxinc n_eduwork n_fam n_unit n_health n_dv n_disab n_sober n_crim n_citizen n_particip 
		n_location n_stability n_credit n_arrears;
	DO OVER meta_a; 
		IF meta_a=0 THEN meta_b=.; ELSE meta_b=meta_b; 
		IF meta_b in(0,1) THEN meta_c=1; ELSE meta_c=0;
	END;
	OUTPUT screened_CBRR_match;
	IF pre_CBRR=1 and post_CBRR=0 THEN OUTPUT screenedout_CBRR_match;
RUN;

PROC MEANS DATA=screened_CBRR_match SUM NOPRINT;
VAR  pre_CBRR n_minincemp n_rent n_maxinc n_eduwork n_fam n_unit n_health n_dv n_disab n_sober n_crim n_citizen n_particip n_location n_stability
n_credit n_arrears;
OUTPUT OUT=cbrr_elig_summ SUM(pre_CBRR n_minincemp--n_arrears)= /autoname;
RUN;

DATA cbrr_elig_summ2;
	SET cbrr_elig_summ;
	Prgtype='CBRR';
	ARRAY BB n_minincemp_sum n_rent_sum n_maxinc_sum n_eduwork_sum n_fam_sum n_unit_sum n_health_sum 
			n_dv_sum n_disab_sum n_sober_sum n_crim_sum n_citizen_sum n_particip_sum n_location_sum n_stability_sum 
			n_credit_sum n_arrears_sum;
	ARRAY CC per_minincemp per_rent per_maxinc per_eduwork per_fam per_unit per_health 
			per_dv per_disab per_sober per_crim per_citizen per_particip per_location per_stability 
			per_credit per_arrears;
	DO OVER BB; IF BB not in(0,.) THEN CC=BB/pre_CBRR_sum; ELSE CC=0; END;
	FORMAT per_minincemp per_rent per_maxinc per_eduwork per_fam per_unit per_health per_dv per_disab 
			per_sober per_crim per_citizen per_particip per_location per_stability per_credit per_arrears percent10.1;
	KEEP   prgtype per_: ;
RUN;

PROC TRANSPOSE DATA=cbrr_elig_summ2 OUT=cbrr_elig_tp NAME=Qtype; ID prgtype; VAR per_: ; RUN;



*PBTH;

PROC SORT DATA=elig_screened_PBTH OUT=elig_screened_PBTH_s; BY site_id; RUN;

DATA screened_PBTH_match screenedout_PBTH_match;
	MERGE elig_screened_PBTH_s (in=aa keep=family_id site_id e1-e100 pre_PBTH post_PBTH) PBTH_elig_qs (in=bb);
	BY site_id;
	IF aa and bb;
	ARRAY clientE E1-E100;
	ARRAY providerE summ_E1-summ_E100;
	ARRAY clientnewE E_ADJ1-E_ADJ100;
	DO OVER clientE; IF ProviderE=0 THEN clientnewE=0; ELSE clientnewE=ClientE; END;

	
	*Dropped E32 (pets --only 7 asked, zero no's),e33 & e34 (artifact of study), set E73 as max income?;
	ARRAY minincemp E_ADJ2-E_ADJ6 E_ADJ8 E_ADJ66 E_ADJ79 E_ADJ87; /*9 Qs*/
	ARRAY rent E_ADJ45 E_ADJ57 E_ADJ63-E_ADJ65 E_ADJ78 E_ADJ80 E_ADJ83; /*8 Qs*/
	ARRAY maxinc E_ADJ38 E_ADJ73; /*2 Q */
	ARRAY eduwork E_ADJ1 E_ADJ7 ;/*2 Qs*/
	ARRAY fam E_ADJ15 E_ADJ53-E_ADJ56 E_ADJ58 E_ADJ62 E_ADJ75 E_ADJ82 E_ADJ100;/*10 Qs*/
	ARRAY unit E_ADJ12-E_ADJ14 E_ADJ36 E_ADJ42-E_ADJ44 E_ADJ69 E_ADJ70 E_ADJ74 E_ADJ77 E_ADJ84-E_ADJ86;/*14 Qs*/
	ARRAY health E_ADJ16 E_ADJ61; /*2 Qs*/
	/*ARRAY DV E_ADJ99; 1 Q*/
	ARRAY disab E_ADJ47 E_ADJ48; /*2 Qs*/
	ARRAY sober E_ADJ17-E_ADJ19 E_ADJ20 E_ADJ35 E_ADJ52; /*6 Qs*/
	ARRAY crim E_ADJ21-E_ADJ27 E_ADJ46 E_ADJ59;/*9 Qs*/
	ARRAY citizen E_ADJ28 E_ADJ29 E_ADJ81;/*3 Qs*/
	ARRAY particip E_ADJ30 E_ADJ31 E_ADJ39 E_ADJ51 E_ADJ88;/*5 Qs*/
	ARRAY location E_ADJ40 E_ADJ41 E_ADJ49 E_ADJ50 E_ADJ60 E_ADJ73 E_ADJ76 E_ADJ89 E_ADJ90-E_ADJ97; /*18 Qs*/
	ARRAY stability E_ADJ68 E_ADJ71; /*2 Qs*/
	ARRAY credit E_ADJ9 E_ADJ11 E_ADJ37 E_ADJ67 E_ADJ98; /*5 Qs*/
	/*ARRAY arrears E_ADJ10; 1 Q*/
	ARRAY meta_b inelig_minincemp inelig_rent inelig_maxinc inelig_eduwork 
	inelig_fam inelig_unit inelig_health inelig_DV inelig_disab 
	inelig_sober inelig_crim inelig_citizen inelig_particip 
	inelig_location inelig_stability inelig_credit inelig_arrears;

	minincemp_sum=sum(of E_ADJ2-E_ADJ6, E_ADJ8, E_ADJ66, E_ADJ79, E_ADJ87);
	rent_sum=sum(of E_ADJ45, E_ADJ57, of E_ADJ63-E_ADJ65, E_ADJ78, E_ADJ80, E_ADJ83);
	maxinc_sum=sum(E_ADJ38 , E_ADJ73);
	eduwork_sum=sum(of E_ADJ1, E_ADJ7);
	fam_sum=sum(of E_ADJ15, of E_ADJ53-E_ADJ56, E_ADJ58 , E_ADJ62, E_ADJ75, E_ADJ82, E_ADJ100);
	unit_sum=sum(of E_ADJ12-E_ADJ14, E_ADJ36, of E_ADJ42-E_ADJ44, E_ADJ69, E_ADJ70, E_ADJ74, E_ADJ77, of E_ADJ84-E_ADJ86);
	health_sum=sum(of E_ADJ16, E_ADJ61);
	DV_sum=E_ADJ99;
	disab_sum=sum(E_ADJ47, E_ADJ48);
	sober_sum=sum(of E_ADJ17-E_ADJ19, E_ADJ20, E_ADJ35, E_ADJ52);
	crim_sum=sum(of E_ADJ21-E_ADJ27, E_ADJ46, E_ADJ59);
	citizen_sum=sum(of E_ADJ28, E_ADJ29, E_ADJ81);
	particip_sum=sum(of E_ADJ30, E_ADJ31, E_ADJ39, E_ADJ51, E_ADJ88);
	location_sum=sum(of E_ADJ33, E_ADJ34, E_ADJ40, E_ADJ41, E_ADJ49, E_ADJ50, E_ADJ60, E_ADJ73, E_ADJ76, E_ADJ89, of E_ADJ90-E_ADJ97);
	stability_sum=sum(of E_ADJ68, E_ADJ71);
	credit_sum=sum(of E_ADJ9, E_ADJ11, E_ADJ37, E_ADJ67, E_ADJ98);
	arrears_sum=E_ADJ10;
	
	*Create flag for asked question and for no answer by type;
	DO OVER meta_b; meta_b=0; END;
	DO OVER minincemp; IF minincemp=2 THEN inelig_minincemp=1; ELSE inelig_minincemp+0; END;
	DO OVER rent; IF rent=2 THEN inelig_rent=1; ELSE inelig_rent+0; END;
	DO OVER maxinc; IF maxinc=2 THEN inelig_maxinc=1; ELSE inelig_maxinc+0; END;
	DO OVER eduwork; IF eduwork=2 THEN inelig_eduwork=1; ELSE inelig_eduwork+0; END;
	DO OVER fam; IF fam=2 THEN inelig_fam=1; ELSE inelig_fam+0; END;
	DO OVER unit; IF unit=2 THEN inelig_unit=1; ELSE inelig_unit+0; END;
	DO OVER health; IF health=2 THEN inelig_health=1; ELSE inelig_health+0; END;
	IF E_ADJ99=2 THEN inelig_dv=1; ELSE inelig_dv+0; 
	DO OVER disab; IF disab=2 THEN inelig_disab=1; ELSE inelig_disab+0; END;
	DO OVER sober; IF sober=2 THEN inelig_sober=1; ELSE inelig_sober+0; END;
	DO OVER crim; IF crim=2 THEN inelig_crim=1; ELSE inelig_crim+0; END;
	DO OVER citizen; IF citizen=2 THEN inelig_citizen=1; ELSE inelig_citizen+0; END;
	DO OVER particip; IF particip=2 THEN inelig_particip=1; ELSE inelig_particip+0; END;
	DO OVER location; IF location=2 THEN inelig_location=1; ELSE inelig_location+0; END;
	DO OVER stability; IF stability=2 THEN inelig_stability=1; ELSE inelig_stability+0; END;
	DO OVER credit; IF credit=2 THEN inelig_credit=1; ELSE inelig_credit+0; END;
	IF E_ADJ10=2 THEN inelig_arrears=1; ELSE inelig_arrears+0; 

	ARRAY meta_a minincemp_sum rent_sum maxinc_sum eduwork_sum fam_sum unit_sum health_sum dv_sum disab_sum
			sober_sum crim_sum 	citizen_sum particip_sum location_sum stability_sum credit_sum arrears_sum;
	ARRAY meta_c n_minincemp n_rent n_maxinc n_eduwork n_fam n_unit n_health n_dv n_disab n_sober n_crim n_citizen n_particip 
		n_location n_stability n_credit n_arrears;
	DO OVER meta_a; 
		IF meta_a=0 THEN meta_b=.; ELSE meta_b=meta_b; 
		IF meta_b in(0,1) THEN meta_c=1; ELSE meta_c=0;
	END;
	OUTPUT screened_PBTH_match;
	IF post_PBTH=0 THEN OUTPUT screenedout_PBTH_match;
RUN;

PROC MEANS DATA=screened_PBTH_match SUM NOPRINT;
VAR  pre_PBTH n_minincemp n_rent n_maxinc n_eduwork n_fam n_unit n_health n_dv n_disab n_sober n_crim n_citizen n_particip n_location n_stability
n_credit n_arrears;
OUTPUT OUT=pbth_elig_summ SUM(pre_PBTH n_minincemp--n_arrears)= /autoname;
RUN;

DATA pbth_elig_summ2;
	SET pbth_elig_summ;
	Prgtype='PBTH';
	ARRAY BB n_minincemp_sum n_rent_sum n_maxinc_sum n_eduwork_sum n_fam_sum n_unit_sum n_health_sum 
			n_dv_sum n_disab_sum n_sober_sum n_crim_sum n_citizen_sum n_particip_sum n_location_sum n_stability_sum 
			n_credit_sum n_arrears_sum;
	ARRAY CC per_minincemp per_rent per_maxinc per_eduwork per_fam per_unit per_health 
			per_dv per_disab per_sober per_crim per_citizen per_particip per_location per_stability 
			per_credit per_arrears;
	DO OVER BB; IF BB not in(0,.) THEN CC=BB/pre_PBTH_sum; ELSE CC=0; END;
	FORMAT per_minincemp per_rent per_maxinc per_eduwork per_fam per_unit per_health per_dv per_disab 
			per_sober per_crim per_citizen per_particip per_location per_stability per_credit per_arrears percent10.1;
	KEEP   prgtype per_: ;
RUN;

PROC TRANSPOSE DATA=pbth_elig_summ2 OUT=pbth_elig_tp NAME=Qtype; ID prgtype; VAR per_: ; RUN;

PROC SORT DATA=sub_elig_tp;BY Qtype;RUN;
PROC SORT DATA=cbrr_elig_tp;BY Qtype;RUN;
PROC SORT DATA=pbth_elig_tp;BY Qtype;RUN;

DATA hfsurv.eligibility_qs;
	LENGTH QLABEL $175;
	MERGE sub_elig_tp cbrr_elig_tp pbth_elig_tp;
	BY qtype;
	SELECT (Qtype);
		WHEN('per_minincemp') QLABEL='Meet minimum income or employment requirements';
		WHEN('per_rent') QLABEL='Able to pay required rent or move-in fees';
		WHEN('per_maxinc') QLABEL='Income is below maximum income threshold';
		WHEN('per_eduwork') QLABEL='Have adequate education or work experience';
		WHEN('per_fam') QLABEL='Family composition appropriate';
		WHEN('per_unit') QLABEL='Family appropriate for available unit size';
		WHEN('per_health') QLABEL='Meet health screening procedures';
		WHEN('per_dv') QLABEL='Domestic violence requirement';
		WHEN('per_disab') QLABEL='Disability requirement';
		WHEN('per_sober') QLABEL='Require sobriety, drug testing, or treatment' ;
		WHEN('per_crim') QLABEL='No specified criminal convictions';
		WHEN('per_citizen') QLABEL='Documentation of citizenship or legal status';
		WHEN('per_particip') QLABEL='Willingness to participate in mandatory services or activities' ;
		WHEN('per_location') QLABEL='From designated geographic catchment area (or willing to live in designated area)' ;
		WHEN('per_stability') QLABEL='Meet housing stability requirements';
		WHEN('per_credit') QLABEL='Adequate credit or housing history';	
		WHEN('per_arrears') QLABEL='Do not owe housing authority arrears';
	END;
	IF Qtype~='per_dv';
	FORMAT SUB CBRR PBTH percent10.0;
RUN;



					/* CHAPTER 3 -- additional datasets */

/* Chapter 3 eligibility tables (ex3-4 and ex 3-5)*/

/*SB - confirmed that these are the final eligibility tables Sage sent 
	for pre and post eligibility question intervention availability*/
PROC IMPORT DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Copy of export_table6 3.xls" 
OUT=preelig_raw DBMS=xls replace;
GETNAMES=yes; DATAROW=2;
run;
PROC IMPORT DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Eligibility Updated\export_6_7.xls" 
OUT=postelig_raw DBMS=xls replace;
GETNAMES=yes; DATAROW=2;
run;


	/*PRE-RA Eligibility for families entirely screened out -- not in table 6-3*/
PROC IMPORT DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Rassign_Final_Export\Rassign_Final_Export\IRAAVAILABILITY.xls" 
OUT=iraavailability1 DBMS=xls replace;
GETNAMES=yes; DATAROW=2;SHEET='Export Worksheet';
run;
PROC IMPORT DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Rassign_Final_Export\Rassign_Final_Export\IRAAVAILABILITY.xls" 
OUT=iraavailability2 DBMS=xls replace;
GETNAMES=yes; DATAROW=2;SHEET='Sheet1';
run;
PROC IMPORT DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Rassign_Final_Export\Rassign_Final_Export\IRAAVAILABILITY.xls" 
OUT=iraavailability3 DBMS=xls replace;
GETNAMES=yes; DATAROW=2;SHEET='Sheet2';
run;
PROC IMPORT DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Rassign_Final_Export\Rassign_Final_Export\Ifamilyspecificprovider.xls" 
OUT=ifamspecificprovider DBMS=xls replace;
GETNAMES=yes; DATAROW=2;
run;
PROC IMPORT OUT=inelig_info replace
			DATAFILE="S:\Projects\Homefam\Data\RAW Exports\Eligibility\Ineligibility Matrix  Report.xls" 
			DBMS=XLS;
			GETNAMES=YES;
RUN;

DATA iraavailability; SET iraavailability1 iraavailability2 iraavailability3;RUN;

PROC SORT DATA=inelig_info; BY family_id;RUN;
PROC SORT DATA=ifamspecificprovider OUT=ifam2 (RENAME=(fam_id=family_id)); BY fam_id;RUN;

DATA inelig_temp;
	MERGE inelig_info (in=aa) ifam2 (in=bb);
	BY family_id;
	IF aa and bb and iscurrent=1;
RUN;

PROC SORT DATA=inelig_temp;by snapshot_id;run;
PROC SORT DATA=iraavailability out=ira_temp;by snapshot_id;run;

DATA inelig_temp2;MERGE inelig_temp (in=aa) ira_temp (in=bb); BY snapshot_id; IF aa and bb; in_a=aa; in_b=bb; RUN;


PROC SQL;
	CREATE TABLE inelig_snapshot AS
	SELECT DISTINCT ifamspecificprovider.fam_id, ifamspecificprovider.snapshot_id, ifamspecificprovider.lastupdatedate
	FROM inelig_info inel, ifamspecificprovider 
	WHERE inel.family_id=ifamspecificprovider.fam_id;


	/*CREATE TABLE inelig_avail AS*/
	SELECT inelig_snapshot.fam_id, inelig_snapshot.snapshot_id, iraavailability.cbrravailable, iraavailability.pbthavailable, 
			iraavailability.subavailable, iraavailability.raavailable, iraavailability.lastupdatedate
	FROM inelig_snapshot , iraavailability 
	WHERE inelig_snapshot.snapshot_id = iraavailability.snapshot_id
	ORDER BY inelig_snapshot.fam_id, inelig_snapshot.snapshot_id DESC;

QUIT;



*Pre-eligibility Availability;
DATA preelig_import;
	LENGTH family_id 8.;
	SET preelig_raw (RENAME= (familystudy_id=family_id));
	IF family_id~=0;
RUN;
PROC SORT DATA=preelig_import OUT=preelig_s; BY family_id; RUN;

DATA preeligavail
	(DROP=lastupdatedate adj_cbrr adj_PBTH adj_SUB);
	LENGTH pre_CBRR pre_PBTH pre_SUB 8.;
	SET preelig_s (RENAME=(cbrravailable=adj_cbrr pbthavailable=adj_PBTH
		subavailable=adj_SUB));
	IF adj_CBRR>0 THEN pre_CBRR=1; ELSE pre_CBRR=0;
	IF adj_PBTH>0 THEN pre_PBTH=1; ELSE pre_PBTH=0;
	IF adj_SUB>0 THEN pre_SUB=1;ELSE pre_SUB=0;

	*Atlanta and Baltimore did not have SUB, Boston did not have PBTH;
	IF pre_CBRR=0 THEN DO; pre_CBRR_neveravail=0;pre_CBRR_tempunavail=1; END;
	IF pre_SUB=0 THEN DO; 
		IF site_id in(2,11) THEN DO; pre_SUB_neveravail=1;pre_SUB_tempunavail=0; END;
			ELSE DO; pre_SUB_neveravail=0;pre_SUB_tempunavail=1; END;END;
		ELSE DO; pre_SUB_neveravail=0;pre_SUB_tempunavail=0; END;
	IF pre_PBTH=0 THEN DO; 
		IF site_id=3 THEN DO; pre_PBTH_neveravail=1;pre_PBTH_tempunavail=0; END;
			ELSE DO; pre_PBTH_neveravail=0;pre_PBTH_tempunavail=1; END;END;
		ELSE DO; pre_PBTH_neveravail=0;pre_PBTH_tempunavail=0; END;
		

	RAarms_pre=SUM(pre_CBRR,pre_PBTH,pre_SUB,1);
	avail_loss=4-RAarms_pre;	
RUN;

*Post-eligibility Availability;
DATA postelig_import;
	LENGTH family_id 8.;
	SET postelig_raw (RENAME= (fam_id=family_id));
	IF family_id~=0;
RUN;
PROC SORT DATA=postelig_import OUT=postelig_s; BY family_id; RUN;

DATA posteligavail
	(DROP=lastupdatedate adj_cbrr adj_PBTH adj_SUB);
	LENGTH post_CBRR post_PBTH post_SUB 8.;
	SET postelig_s (RENAME=(cbrravailable=adj_cbrr pbthavailable=adj_PBTH
		subavailable=adj_SUB));
	IF adj_CBRR>0 THEN post_CBRR=1; ELSE post_CBRR=0;
	IF adj_PBTH>0 THEN post_PBTH=1; ELSE post_PBTH=0;
	IF adj_SUB>0 THEN post_SUB=1;ELSE post_SUB=0;
	RAarms_post=SUM(post_CBRR,post_PBTH,post_SUB,1);	
RUN;

*Family Details IDs--to use for IDing which families were RA-ed;
DATA FamDetail1; SET hfsurv.famdetail_12122012 (KEEP=family_id); RUN;
PROC SORT DATA=famdetail1; BY family_id; RUN;
DATA famdetail_id; SET famdetail1; BY family_id; IF last.family_id THEN OUTPUT; RUN;

/*could create multi-level based on outcome_b*/
PROC FORMAT;
	VALUE outcome_af
	1='4 way RA'
	2='3 way RA, lost arm to availability'
	3='3 way RA, lost arm to eligibility'
	4='2 way RA, lost 2 arms to availability'
	5='2 way RA, lost 2 arms to eligibility'
	6='2 way RA, lost 1 arm to availability and 1 arm to eligibility';
	VALUE outcome_a2f
	1='4 way RA'
	2='3 way RA, lost intervention to availability (not available in site)'
	3='3 way RA, lost intervention to availability (intervention not available at time of RA)'
	4='3 way RA, lost intervention to eligibility'
	5='2 way RA, lost 2 interventions to availability (both interventions not available at time of RA)'
	6='2 way RA, lost 2 interventions to availability (one not available at time of RA, one not available in site)'
	7='2 way RA, lost 2 interventions to eligibility'
	8='2 way RA, lost 1 intervention to availability (not available in site) and 1 intervention to eligibility'
	9='2 way RA, lost 1 intervention to availability (not available at time of RA) and 1 intervention to eligibility';

	VALUE outcome_bf
	1='4 way RA'
	2='3 way RA, lost CBRR to availability'
	3='3 way RA, lost SUB to availability'
	4='3 way RA, lost PBTH to availability'
	5='3 way RA, lost CBRR to eligibility'
	6='3 way RA, lost SUB to eligibility'
	7='3 way RA, lost PBTH to eligibility'
	8='2 way RA, lost CBRR, SUB to availability'
	9='2 way RA, lost CBRR, PBTH to availability'
	10='2 way RA, lost SUB, PBTH to availability'
	11='2 way RA, lost CBRR, SUB to eligibility'
	12='2 way RA, lost CBRR, PBTH to eligibility'
	13='2 way RA, lost SUB, PBTH to eligibility'
	14='2 way RA, lost avail to CBRR, elig to SUB'
	15='2 way RA, lost elig to CBRR, avail to SUB'
	16='2 way RA, lost avail to CBRR, elig to PBTH'
	17='2 way RA, lost elig to CBRR, avail to PBTH'
	18='2 way RA, lost avail to SUB, elig to PBTH'
	19='2 way RA, lost elig to SUB, avail to PBTH'
	;
	VALUE outcome_cf
	1='Assignment among 4 interventions'
	2='Assignment among 3 interventions'
	3='Assignment among 2 interventions';
	VALUE outcome_c2f
	1='Assigned among 4 interventions'
	2='Assigned among 3 interventions: Lost one intervention'
	3='Assigned among 2 interventions: Lost two interventions, solely due to program availability'
	4='Assigned among 2 interventions: Lost two interventions, solely due to family eligibility'
	5='Assigned among 2 interventions: Lost one intervention due to program availability and one due to family eligibility';

RUN;

 
*Calculate RA arms lost by reason and type;
DATA hfsurv.elig_change_11132012 other ;
	MERGE preeligavail (IN=aa) posteligavail (IN=bb) famdetail_id (IN=cc);
	BY family_id;
	IF aa=1 THEN preelig=1;	IF bb=1 THEN adjavail=1; IF cc=1 THEN famdet=1;
	IF (aa=1 and cc=1) or (bb=1 and cc=1) THEN assigned=1; 
	ELSE DO;
		assigned=0;
		OUTPUT other; 
	END;
	IF assigned=1;
	elig_loss=sum(RAarms_pre,-RAarms_post);
	tot_arms_lost=sum(avail_loss,elig_loss);

	*outcomes a - c do not incorporate site-level availability;
	SELECT (RAarms_post);
		*4 arms;
		WHEN (4) DO; outcome_a=1;outcome_b=1;outcome_c=1;END;
		*3 arms;
		WHEN (3) DO;
			outcome_c=2;
			IF avail_loss=1 THEN DO; outcome_a=2;*one arm lost b/c avail;
				IF pre_CBRR=0 THEN outcome_b=2;
				IF pre_SUB=0 THEN outcome_b=3;
				IF pre_PBTH=0 THEN outcome_b=4;
				END;
			IF elig_loss=1 THEN DO; outcome_a=3;*one arm lost b/c elig;
				IF post_CBRR=0 THEN outcome_b=5;
				IF post_SUB=0 THEN outcome_b=6;
				IF post_PBTH=0 THEN outcome_b=7;
				END;
		END;
		*2 arms;
		WHEN (2) DO;
			outcome_c=3;
			IF avail_loss=2 and elig_loss=0 THEN DO;outcome_a=4;*both arms lost due to avail;
				IF pre_CBRR=0 and pre_SUB=0 THEN outcome_b=8;
				IF pre_CBRR=0 and pre_PBTH=0 THEN outcome_b=9;
				IF pre_SUB=0 and pre_PBTH=0 THEN outcome_b=10;
			END;
			IF avail_loss=0 and elig_loss=2 THEN DO;outcome_a=5;*both arms lost due to eligibility;
				IF post_CBRR=0 and post_SUB=0 THEN outcome_b=11;
				IF post_CBRR=0 and post_PBTH=0 THEN outcome_b=12;
				IF post_SUB=0 and post_PBTH=0 THEN outcome_b=13;
			END;
			IF avail_loss=1 and elig_loss=1 THEN DO;outcome_a=6;*one arm due to elig, one to avail;
				IF pre_CBRR=0 and post_SUB=0 THEN outcome_b=14;
				IF post_CBRR=0 and pre_SUB=0 THEN outcome_b=15;
				IF pre_CBRR=0 and post_PBTH=0 THEN outcome_b=16;
				IF post_CBRR=0 and pre_PBTH=0 THEN outcome_b=17;
				IF pre_SUB=0 and post_PBTH=0 THEN outcome_b=18;
				IF post_SUB=0 and pre_PBTH=0 THEN outcome_b=19;
			END;
		END;
		OTHERWISE bad=1;
	END;

	*incorporating intervention not being available at site;
		*Atlanta and Baltimore did not have SUB, Boston did not have PBTH;
	IF (site_id in(2,11) and pre_SUB=0) or (site_id=3 and pre_PBTH=0) THEN no_avail=1;ELSE no_avail=0;
	SELECT (RAarms_post);
		*4 arms;
		WHEN (4) DO; outcome_a2=1;outcome_b2=1;outcome_c2=1;END;
		*3 arms;
		WHEN (3) DO;
			outcome_c2=2;
			IF avail_loss=1 and no_avail=1  THEN DO; outcome_a2=2;*one arm lost b/c no avail at site;
				IF pre_CBRR=0 THEN outcome_b2=2;
				IF pre_SUB=0 THEN outcome_b2=3;
				IF pre_PBTH=0 THEN outcome_b2=4;
				END;
			IF avail_loss=1 and no_avail=0 THEN DO; outcome_a2=3;*one arm lost b/c temp not avail;
				IF pre_CBRR=0 THEN outcome_b2=2;
				IF pre_SUB=0 THEN outcome_b2=3;
				IF pre_PBTH=0 THEN outcome_b2=4;
				END;
			IF elig_loss=1 THEN DO; outcome_a2=4;*one arm lost b/c elig;
				IF post_CBRR=0 THEN outcome_b2=5;
				IF post_SUB=0 THEN outcome_b2=6;
				IF post_PBTH=0 THEN outcome_b2=7;
				END;
		END;
		*2 arms;
		WHEN (2) DO;
			IF avail_loss=2 and elig_loss=0 and no_avail=0 THEN DO;outcome_a2=5;outcome_c2=3;*both arms lost due to no avail at time;
				IF pre_CBRR=0 and pre_SUB=0 THEN outcome_b2=8;
				IF pre_CBRR=0 and pre_PBTH=0 THEN outcome_b2=9;
				IF pre_SUB=0 and pre_PBTH=0 THEN outcome_b2=10;
			END;
			ELSE IF avail_loss=2 and elig_loss=0 and no_avail=1 THEN DO;outcome_a2=6;outcome_c2=3;*both arms lost due to avail - one no site other none at time;
				IF pre_CBRR=0 and pre_SUB=0 THEN outcome_b2=8;
				IF pre_CBRR=0 and pre_PBTH=0 THEN outcome_b2=9;
				IF pre_SUB=0 and pre_PBTH=0 THEN outcome_b2=10;
			END;
			IF avail_loss=0 and elig_loss=2 THEN DO;outcome_a2=7;outcome_c2=4;*both arms lost due to eligibility;
				IF post_CBRR=0 and post_SUB=0 THEN outcome_b=11;
				IF post_CBRR=0 and post_PBTH=0 THEN outcome_b=12;
				IF post_SUB=0 and post_PBTH=0 THEN outcome_b=13;
			END;
			IF avail_loss=1 and elig_loss=1 and no_avail=1 THEN DO;outcome_a2=8;outcome_c2=5;*one arm due to elig, one to avail (none at site);
				IF pre_CBRR=0 and post_SUB=0 THEN outcome_b2=14;
				IF post_CBRR=0 and pre_SUB=0 THEN outcome_b2=15;
				IF pre_CBRR=0 and post_PBTH=0 THEN outcome_b2=16;
				IF post_CBRR=0 and pre_PBTH=0 THEN outcome_b2=17;
				IF pre_SUB=0 and post_PBTH=0 THEN outcome_b2=18;
				IF post_SUB=0 and pre_PBTH=0 THEN outcome_b2=19;
			END;
			ELSE IF avail_loss=1 and elig_loss=1 and no_avail=0 THEN DO;outcome_a2=9;outcome_c2=5;*one arm due to elig, one to avail (not at time);
				IF pre_CBRR=0 and post_SUB=0 THEN outcome_b2=14;
				IF post_CBRR=0 and pre_SUB=0 THEN outcome_b2=15;
				IF pre_CBRR=0 and post_PBTH=0 THEN outcome_b2=16;
				IF post_CBRR=0 and pre_PBTH=0 THEN outcome_b2=17;
				IF pre_SUB=0 and post_PBTH=0 THEN outcome_b2=18;
				IF post_SUB=0 and pre_PBTH=0 THEN outcome_b2=19;
			END;
		END;
		OTHERWISE bad=1;
	END;

	FORMAT outcome_a outcome_af. outcome_a2 outcome_a2f. outcome_b outcome_bf. outcome_c outcome_cf. outcome_c2 outcome_c2f.;
	LABEL outcome_a='Randomization Circumstance' outcome_b='Randomization Circumstance Detail' outcome_c='Randomization Circumstance'
		outcome_a2='Random Assignment Circumstance (Detail)' outcome_c2='Random Assignment Circumstance (Totals)';
	IF bad=1 or tot_arms_lost<0 THEN OUTPUT other;
	ELSE OUTPUT hfsurv.elig_change_11132012;
	
RUN;

*end section;



/************************************************//*

		CREATE DANNY'S TABLE FOR EXHIBIT 5-5

Create table with series of dummy variables for 
each week of the study. Then run PROC MEANS and output
to produce a WEEK and an UPTAKE variable.

Do by Intervention as well

Updated with new take-up info 1/14/2013.

To reproduce the old one, re-run code producing hfsurv.options_memo_all dataset
   using the hfsurv.master_11..2012 dataset

*//************************************************/

DATA per_fam_movein1a per_fam_movein2a (Keep=RA_Result Week1-Week60 Pred_Week1-Pred_Week60);
	SET hfsurv.options_memo_all (KEEP= family_id ra_result site_id provider_name_dedup ra_date Move_in_or_Lease_up_Date movein);
	Weeks_Since_RA=CEIL(YRDIF(RA_Date,MDY(6,15,2012),'act/act')*52);
	IF Movein=1 and ra_result~='UC' THEN Week_Move_In= CEIL(YRDIF(RA_Date,Move_in_or_Lease_up_Date,'act/act')*52);
	ARRAY Week (60); ARRAY Pred_Week (60); 
	ARRAY Denom_Week (60); ARRAY NumMoveIn (60);

	DO i=1 TO 60;
	IF Week_Move_In=0 THEN Week[1]=1;
	IF Week_Move_In<=i and Week_Move_In>0 THEN Week[i]=1;ELSE Week[i]=0;
	IF Week_Move_In<=i and Week_Move_In>0 THEN Pred_Week[i]=1;ELSE DO;
	IF Weeks_Since_RA>=i THEN Pred_Week[i]=Week[i];ELSE Pred_Week[i]=.;END;

	IF Week_Move_In=i THEN NumMoveIn[i]+1;
	IF Weeks_Since_RA>=i or Week_move_in>0 THEN Denom_Week[i]=1;ELSE Denom_Week[i]=0;
	END;
RUN;


proc sort data=per_fam_movein1a out=per_Fam_movein1a_s; by descending week_move_in;run;
proc sort data=per_fam_movein1a out=per_Fam_movein1a_s2; by ra_result;run;
proc sort data=per_fam_movein2a out=per_Fam_movein2a_s2; by ra_result;run;

PROC FREQ DATA=per_fam_movein1a; TABLES weeks_since_ra week_move_in;RUN;

/*
proc print data=per_fam_movein1_s; var family_id move_in_or_lease_up_date week_move_in weeks_since_ra week20-week29 pred_week20-pred_week29; run;

PROC MEANS data=per_fam_movein1 mean max min;
var week_move_in weeks_since_ra;
run;
PROC MEANS data=per_fam_movein1 mean max min;
where ra_result~='UC' and week_move_in~=0;
var week_move_in weeks_since_ra;
run;
PROC MEANS data=per_fam_movein1_s2 mean max min;
by ra_result;
var week_move_in weeks_since_ra;
run;*/

PROC MEANS data=per_fam_movein2a_s2 N SUM MEAN;
by ra_result;
var week1-week60;
output out=hfam_numweeks;
run;
PROC MEANS data=per_fam_movein2a_s2 N SUM MEAN;
by ra_result;
var pred_week1-pred_week60;
output out=pred_hfam_numweeks;
run;

DATA movein_t1a;
	SET hfam_numweeks (DROP= _TYPE_ _FREQ_);
	WHERE _STAT_='MEAN';
	DROP _STAT_;
RUN;
DATA pred_movein_t1a;
	SET pred_hfam_numweeks (DROP= _TYPE_ _FREQ_);
	WHERE _STAT_='MEAN';
	DROP _STAT_;
	RENAME Pred_Week1-Pred_Week60=Week1-Week60;
RUN;

PROC TRANSPOSE DATA=movein_t1a OUT=movein_t2a name=Week;
ID RA_Result;
VAR Week1-Week60;
RUN;
PROC TRANSPOSE DATA=pred_movein_t1a OUT=pred_movein_t2a name=Week;
ID RA_Result;
VAR Week1-Week60;
RUN;

PROC SORT DATA=movein_t2a;BY Week;RUN;
PROC SORT DATA=pred_movein_t2a;BY Week;RUN;

DATA movein_t3a (DROP=WeekLabel);
	LENGTH WEEK 8.;
	MERGE movein_t2a (RENAME=(Week=WeekLabel) DROP= UC)
			pred_movein_t2a (RENAME=(Week=WeekLabel CBRR=pred_CBRR PBTH=pred_PBTH SUB=pred_SUB) DROP= UC);
	BY WeekLabel;
	Week=INPUT(COMPRESS(WeekLabel,'Week'),$2.);
	IF Week<20 THEN DO; pred_CBRR=.; pred_PBTH=.;pred_SUB=.;END;
	LABEL Week='Weeks after RA';
	FORMAT PBTH SUB CBRR pred_PBTH pred_SUB pred_CBRR percent10.0;
RUN;
PROC SORT DATA=movein_t3a OUT=hfsurv.movein_t3a; BY Week;RUN;

PROC PRINT DATA=hfsurv.movein_t3a;RUN;



*revised;
PROC MEANS data=per_fam_movein1 SUM;CLASS RA_RESULT;VAR NumMoveIn1-NumMoveIn60;RUN;

DATA per_fam_movein1 per_fam_movein2 (Keep=RA_Result Week1-Week60 Denom_week1-Denom_week60 nummovein1-nummovein60);
	SET hfsurv.options_memo_all (KEEP= family_id ra_result site_id provider_name_dedup ra_date Move_in_or_Lease_up_Date movein);
	Weeks_Since_RA=CEIL(YRDIF(RA_Date,MDY(9,1,2012),'act/act')*52);
	IF Movein=1 and ra_result~='UC' THEN Week_Move_In= CEIL(YRDIF(RA_Date,Move_in_or_Lease_up_Date,'act/act')*52);

	*correct for errors;
	If week_move_in=0 THEN week_move_in=1;

	ARRAY Week (60); ARRAY Denom_Week (60); ARRAY NumMoveIn (60);

	DO i=1 TO 60;
		IF Weeks_Since_RA>=i AND Week_Move_In <=i AND Week_Move_In~=. THEN Week[i]=1;ELSE Week[i]=0;
		IF Weeks_Since_RA>=i THEN Denom_Week[i]=1;ELSE Denom_Week[i]=0;
		IF Week_Move_In=i THEN NumMoveIn[i]=1;
	END;
RUN;

proc sort data=per_fam_movein2 out=per_Fam_movein2_s2; by ra_result;run;

PROC MEANS data=per_fam_movein2_s2 N SUM MEAN;
by ra_result;
var week1-week60;
output out=hfam_numweeks SUM(week1-week60)=week1-week60;;
run;
PROC MEANS data=per_fam_movein2_s2 N SUM MEAN;
by ra_result;
var week1-week60;
output out=hfam_n_numweeks N(week1-week60)=week1-week60;;
run;
PROC MEANS data=per_fam_movein2_s2 NoPrint;
by ra_result;
var denom_week1-denom_week60;
output out=denom_hfam_numweeks SUM(denom_week1-denom_week60)=week1-week60;
run;
PROC MEANS data=per_fam_movein2_s2 NoPrint;
by ra_result;
var nummovein1-nummovein60;
output out=movein_hfam_numweeks SUM(nummovein1-nummovein60)=week1-week60;
run;


PROC TRANSPOSE DATA=hfam_numweeks OUT=a (RENAME=(CBRR=CBRR_ReachWeekMoveIn PBTH=PBTH_ReachWeekMoveIn SUB=SUB_ReachWeekMoveIn) DROP=UC) Name=WeekLabel;
ID RA_Result;
VAR Week1-Week60;
RUN;
PROC TRANSPOSE DATA=hfam_n_numweeks OUT=b (RENAME=(CBRR=CBRR_TotSamp PBTH=PBTH_TotSamp SUB=SUB_TotSamp) DROP=UC) Name=WeekLabel;
ID RA_Result;
VAR Week1-Week60;
RUN;
PROC TRANSPOSE DATA=denom_hfam_numweeks OUT=c (RENAME=(CBRR=CBRR_Denom PBTH=PBTH_Denom SUB=SUB_Denom) DROP=UC) Name=WeekLabel;
ID RA_Result;
VAR Week1-Week60;
RUN;
PROC TRANSPOSE DATA=movein_hfam_numweeks OUT=d (RENAME=(CBRR=CBRR_WeeklyMoveIn PBTH=PBTH_WeeklyMoveIn SUB=SUB_WeeklyMoveIn) DROP=UC) Name=WeekLabel;
ID RA_Result;
VAR Week1-Week60;
RUN;

PROC SORT DATA=a;BY WeekLabel;RUN; PROC SORT DATA=b;BY WeekLabel;RUN; PROC SORT DATA=c;BY WeekLabel;RUN; PROC SORT DATA=d;BY WeekLabel;RUN;

DATA movein_merged;
	LENGTH WEEK 8.;
	MERGE a b c d;
	BY WeekLabel;
	Week=INPUT(COMPRESS(WeekLabel,'week'),$2.);
RUN;

PROC SORT DATA=movein_merged OUT=movein_merged_s;BY Week;RUN;
	
DATA hfsurv.movein_t3;
	SET movein_merged_s;

	*Predict Method 1 - percent of those who have reached week X and ever moved in;
	CBRR_PredPct1=CBRR_ReachWeekMoveIn/CBRR_Denom; PBTH_PredPct1=PBTH_ReachWeekMoveIn/PBTH_Denom; SUB_PredPct1=SUB_ReachWeekMoveIn/SUB_Denom;

	*Predict Method 2 - total reached week X and moved in + number not reached week X and moved in (cumulative move ins)
			divided by total sample (within ra type);
	CBRR_CumMoveIn+CBRR_weeklymovein;	PBTH_CumMoveIn+PBTH_weeklymovein; SUB_CumMoveIn+SUB_weeklymovein;
	CBRR_PredPct2=CBRR_CumMoveIn/CBRR_TotSamp; PBTH_PredPct2=PBTH_CumMoveIn/PBTH_TotSamp; SUB_PredPct2=SUB_CumMoveIn/SUB_TotSamp;

	*Take max of the two methods, which assumes:
		-Later cohorts must do as well as earlier cohorts
		-Later cohorts could do better than earlier cohorts
	AND set weeks prior to 20 to missing since have 100% of data for those weeks;
	CBRR_PredPct=MAX(CBRR_PredPct1,CBRR_PredPct2); PBTH_PredPct=MAX(PBTH_PredPct1,PBTH_PredPct2); SUB_PredPct=MAX(SUB_PredPct1,SUB_PredPct2);
	/*IF Week<20 THEN DO; CBRR_PredPct=.; PBTH_PredPct=.; SUB_PredPct=.; END;*/

	*Actual Observed Move in;
	CBRR=CBRR_CumMoveIn/CBRR_TotSamp; PBTH=PBTH_CumMoveIn/PBTH_TotSamp; SUB=SUB_CumMoveIn/SUB_TotSamp;
RUN;



ODS TAGSETS.EXCELXP Style=NormalPrinter FILE='H:\HCR\HomeFam\Task 6--Interim Report\Data Documentation\takeupproj.xls' 
OPTIONS(Sheet_Name='test' embedded_titles='Yes' sheet_interval='None');
TITLE;
PROC PRINT DATA=hfsurv.movein_t3;RUN;

PROC SQL;
	SELECT Week,  PBTH FORMAT=PERCENT10.0, SUB FORMAT=PERCENT10.0, CBRR FORMAT=PERCENT10.0,  
		PBTH_PredPct FORMAT=PERCENT10.0, SUB_PredPct FORMAT=PERCENT10.0, CBRR_PredPct FORMAT=PERCENT10.0
	FROM hfsurv.movein_t3;
QUIT;

ODS TAGSETS.EXCELXP CLOSE;
