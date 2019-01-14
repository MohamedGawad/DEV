create or replace PROCEDURE VALIDATE_BLOCK_DISPATCH_SP (INPUT_VAL IN XMLTYPE,STATUS_VAL OUT VARCHAR2) AS 
TRANS_DATE_VAL Date;
FI_BLOCK_SUMMARY_VALIDATION_ID NUMBER;
RECORD_ID NUMBER;
NATIONALITY_CODE_VAL VARCHAR2(20 CHAR);
CUST_ID_VAL VARCHAR2(256 CHAR);
CUST_ID_TYPE_VAL VARCHAR2(5 CHAR);
--FI_CODE_VAL VARCHAR2(5 CHAR);
 msg_mode varchar2(5 char);
 AMT_VAL_VAR float;
BEGIN

DBMS_OUTPUT.PUT_LINE('VALIDATE_BLOCK_DISPATCH_SP');




STATUS_VAL:= 'VALID';

/*
<ValidateFICommonCallback>
	<custId> </custId>
	<msgUID> </msgUID>
	<nationality> </nationality>
	<exectionDate> </exectionDate>
	<custIdType> </custIdType>
	<fiCode> </fiCode>
	<firstLevelValidation> </firstLevelValidation>
	<secoundLevelValidation> </secoundLevelValidation>
</ValidateFICommonCallback>
*/



FOR r IN
      (SELECT ExtractValue(Value(p),'/ValidateFICommonCallback/nationality/text()') AS  NAT,
      ExtractValue(Value(p),'/ValidateFICommonCallback/msgUID/text()') As MSGUID,
--      ExtractValue(Value(p),'/ValidateFICommonCallback/exectionDate/text()')  As EXEC_DATE,
      ExtractValue(Value(p),'/ValidateFICommonCallback/custIdType/text()')  As CUST_ID_TYPE,
--      ExtractValue(Value(p),'/ValidateFICommonCallback/fiCode/text()') As FI_CODE,
      ExtractValue(Value(p),'/ValidateFICommonCallback/custId/text()')  As CUST_ID,
       ExtractValue(Value(p),'/ValidateFICommonCallback/firstLevelValidation/text()')  As FRST_LEVEL,
        ExtractValue(Value(p),'/ValidateFICommonCallback/secoundLevelValidation/text()')  As SCND_LEVEL,
        Extract(Value(p),'/ValidateFICommonCallback/amt/text()').getnumberval()  As AMT_VAL
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/ValidateFICommonCallback'))) p)

   LOOP
   begin
   --,'yyyy-MM-dd HH24:MM:ss'
   
   
   
   SELECT TRANS_DATE, FI_BLOCK_SUMMARY_VALIDATION_ID, INVOLVED_PARTY_ID, INVOLVED_PARTY_ID_TYPE, NAT_CD,AMT_VAL INTO TRANS_DATE_VAL, RECORD_ID, CUST_ID_VAL, CUST_ID_TYPE_VAL, NATIONALITY_CODE_VAL,AMT_VAL_VAR
   FROM FI_BLOCK_SUMMARY_VALIDATION
   WHERE FI_BLOCK_SUMMARY_VALIDATION.MSG_UID = r.MSGUID;
 

IF  (r.FRST_LEVEL = 'false' and r.SCND_LEVEL = 'false') THEN

IF r.NAT IS NOT NULL 
THEN
    IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE OR NATIONALITY_CODE_VAL != r. NAT)
    THEN
       STATUS_VAL:='INVALID_CUST_DATA'; 
    END IF;
ELSE
IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE )
    THEN
       STATUS_VAL:='INVALID_CUST_DATA'; 
    END IF;
END IF;
   
ELSIF  (r.FRST_LEVEL = 'true' and r.SCND_LEVEL = 'false') THEN

IF r.NAT IS NOT NULL 
THEN
    IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE OR NATIONALITY_CODE_VAL != r. NAT)
    THEN
       STATUS_VAL:='INVALID_CUST_DATA'; 
    END IF;
ELSE
IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE )
    THEN
       STATUS_VAL:='INVALID_CUST_DATA'; 
    END IF;
END IF;

IF r.AMT_VAL IS NOT NULL 
THEN
    IF (AMT_VAL_VAR < r.AMT_VAL)
    THEN
       STATUS_VAL:='INVALID_TOT_SMRY'; 
    END IF;
 END IF;

ELSIF  (r.FRST_LEVEL = 'false' and r.SCND_LEVEL = 'true') THEN

IF r.AMT_VAL IS NOT NULL 
THEN
    IF (AMT_VAL_VAR < r.AMT_VAL)
    THEN
       STATUS_VAL:='INVALID_TOT_SMRY'; 
    END IF;
 END IF;
 
 IF (msg_mode='OVR')
THEN
SELECT XMLELEMENT("fi_block_summary_validation",XMLELEMENT("fi_block_summary_validation_id",fblock.FI_BLOCK_SUMMARY_VALIDATION_ID),
XMLELEMENT("msg_uid",fblock.MSG_UID),
XMLELEMENT("msg_mode",fblock.MSG_MODE),
XMLELEMENT("fi_code",fblock.FI_CODE),
XMLELEMENT("trans_date",fblock.TRANS_DATE),
XMLELEMENT("is_involved_party",fblock.IS_INVOLVED_PARTY),
XMLELEMENT("is_acc_id",fblock.IS_ACC_ID),
XMLELEMENT("involved_party_id",fblock.INVOLVED_PARTY_ID),
XMLELEMENT("involved_party_id_type",fblock.INVOLVED_PARTY_ID_TYPE),
XMLELEMENT("nat_cd",fblock.NAT_CD),
XMLELEMENT("amt_val",fblock.AMT_VAL),
XMLELEMENT("amr_cur",fblock.AMT_CUR),
XMLELEMENT("acc_num",fblock.ACC_NUM),
XMLELEMENT("is_iban",fblock.IS_IBAN)) .GETCLOBVAL()
into STATUS_VAL
FROM FI_BLOCK_SUMMARY_VALIDATION fblock
WHERE fblock.MSG_UID = r.MSGUID;
END IF;  

ELSIF  (r.FRST_LEVEL = 'true' and r.SCND_LEVEL = 'true') THEN

IF r.NAT IS NOT NULL THEN
    IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE OR NATIONALITY_CODE_VAL != r. NAT)
    THEN
       STATUS_VAL:='INVALID_CUST_DATA'; 
    END IF;
  
ELSE  
  IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE )
    THEN
       STATUS_VAL:='INVALID_CUST_DATA'; 
    END IF;
END IF;    

IF r.AMT_VAL IS NOT NULL 
THEN
    IF (AMT_VAL_VAR < r.AMT_VAL)
    THEN
       STATUS_VAL:='INVALID_TOT_SMRY'; 
    END IF;
 END IF;
 
IF (msg_mode='OVR') THEN
SELECT XMLELEMENT("fi_block_summary_validation",XMLELEMENT("fi_block_summary_validation_id",fblock.FI_BLOCK_SUMMARY_VALIDATION_ID),
XMLELEMENT("msg_uid",fblock.MSG_UID),
XMLELEMENT("msg_mode",fblock.MSG_MODE),
XMLELEMENT("fi_code",fblock.FI_CODE),
XMLELEMENT("trans_date",fblock.TRANS_DATE),
XMLELEMENT("is_involved_party",fblock.IS_INVOLVED_PARTY),
XMLELEMENT("is_acc_id",fblock.IS_ACC_ID),
XMLELEMENT("involved_party_id",fblock.INVOLVED_PARTY_ID),
XMLELEMENT("involved_party_id_type",fblock.INVOLVED_PARTY_ID_TYPE),
XMLELEMENT("nat_cd",fblock.NAT_CD),
XMLELEMENT("amt_val",fblock.AMT_VAL),
XMLELEMENT("amr_cur",fblock.AMT_CUR),
XMLELEMENT("acc_num",fblock.ACC_NUM),
XMLELEMENT("is_iban",fblock.IS_IBAN)) .GETCLOBVAL()
into STATUS_VAL
FROM FI_BLOCK_SUMMARY_VALIDATION fblock
WHERE fblock.MSG_UID = r.MSGUID;
END IF; 
   
--IF (TRANS_DATE_VAL >=  to_date(r.EXEC_DATE, 'yyyy-MM-dd HH24:MI:ss'))
--THEN
--    STATUS_VAL:= 'INVALID_EXEC_DATE';
--END IF;
   
  
END IF; 
   
 end;
END LOOP;


IF (STATUS_VAL = 'VALID')
THEN
DELETE FROM FI_BLOCK_SUMMARY_VALIDATION WHERE FI_BLOCK_SUMMARY_VALIDATION_ID = RECORD_ID;
DBMS_OUTPUT.PUT_LINE('Valid Record Deleted successfully');
END IF;

DBMS_OUTPUT.PUT_LINE('VALIDATE_BLOCK_DISPATCH_SP Ends');

 EXCEPTION
 when no_data_found then
  STATUS_VAL:='INVALID_CRN';
	WHEN OTHERs THEN
		Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 


END VALIDATE_BLOCK_DISPATCH_SP;