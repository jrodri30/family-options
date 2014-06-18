/**************************************************************//*

Program:
Title: Explore Abt Family Options Baseline Dataset
Programmer: Scott Brown
Date Created: 01/23/2014
Last Update: 01/23/2014

Input files: fambase.s01_base_vand_140117
Output files: 1) s01_base_vand_140117 PROC CONTENTS.doc
			  2) s01_base_vand_140117.sav (SPSS dataset for Beth)

Purpose:
-Verify contents of dataset
-Produce excel file of variable list for documentation

*//**************************************************************/

*set file directory name;
LIBNAME fambase "E:\Family Options\Data\01_BaselineData";
%LET expdir="E:\Family Options\Data\01_BaselineData";

*%INCLUDE "E:\Family Options\Programs\s02_Attach_Baseline_Data_Formats_01_24_2014.sas" / lrecl=500;
*NOTE: Dropped E5A_2_OTHER which was the name of a spouse or partner who is part of the family but not with them in shelter;
/*DATA fambase.s01_base_vand_140117;
	SET fambase.s01_base_vand_140117 (DROP=E5a_2_OTHER);
RUN;*/

OPTIONS FMTSEARCH=(fambase) NOFMTERR;
OPTIONS NOCENTER LINESIZE=220;

/*
PROC CONTENTS DATA=fambase.s01_base_vand_140117; RUN;
PROC PRINT DATA=fambase.s01_base_vand_140117 (obs=3); RUN;
*/



*Word version of contents;
ODS RTF FILE="E:\Family Options\Documentation\Dataset Documentation\s01_base_vand_140117 PROC CONTENTS.doc";
PROC CONTENTS DATA=fambase.s01_base_vand_140117; RUN;
ODS RTF CLOSE;

*Excel version of contents;
ODS TAGSETS.EXCELXP STYLE=normalprinter FILE="E:\Family Options\Documentation\Dataset Documentation\s01_base_vand_140117 PROC CONTENTS.xls";
PROC CONTENTS DATA=fambase.s01_base_vand_140117; RUN;
ODS TAGSETS.EXCELXP CLOSE;

*Create SPSS export for Beth;

PROC EXPORT DATA=fambase.s01_base_vand_140117
            FILE="E:\Family Options\Data\01_BaselineData\s01_base_vand_140117.sav"
            DBMS=SPSS REPLACE;
RUN;


