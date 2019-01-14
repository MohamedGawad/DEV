create or replace PROCEDURE VALIDATE_BAN_DISPATCH_SP(INPUT_VAL IN XMLTYPE, STATUS_VAL OUT VARCHAR2) AS 
TRANS_DATE_VAL Date;
RECORD_ID NUMBER;
NATIONALITY_CODE_VAL VARCHAR2(20 CHAR);
CUST_ID_VAL VARCHAR2(256 CHAR);
CUST_ID_TYPE_VAL VARCHAR2(5 CHAR);
BEGIN

  DBMS_OUTPUT.PUT_LINE('VALIDATE_BAN_DISPATCH_SP');
  STATUS_VAL:='VALID';
  
/*
<ValidateFICommonCallback>
	<custId> </custId>
	<msgUID> </msgUID>
	<nationality> </nationality>
	<exectionDate> </exectionDate>
	<custIdType> </custIdType>
	<fiCode> </fiCode>
  <levelOfValidation> </levelOfValidation>
</ValidateFICommonCallback>
*/

FOR r IN
      (SELECT ExtractValue(Value(p),'/ValidateFICommonCallback/nationality/text()') AS  NAT,
      ExtractValue(Value(p),'/ValidateFICommonCallback/msgUID/text()') As MSGUID,
      ExtractValue(Value(p),'/ValidateFICommonCallback/exectionDate/text()')  As EXEC_DATE,
      ExtractValue(Value(p),'/ValidateFICommonCallback/custIdType/text()')  As CUST_ID_TYPE,
      ExtractValue(Value(p),'/ValidateFICommonCallback/fiCode/text()') As FI_CODE,
      ExtractValue(Value(p),'/ValidateFICommonCallback/custId/text()')  As CUST_ID,
      ExtractValue(Value(p),'/ValidateFICommonCallback/levelOfValidation/text()')  As LEVEL_OF_VALIDATION
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/ValidateFICommonCallback'))) p)

   LOOP
   begin

SELECT FI_BAN_SUMMARY_VALIDATION_ID, TRANS_DATE, INVOLVED_PARTY_ID, INVOLVED_PARTY_ID_TYPE, NAT_CD INTO RECORD_ID, TRANS_DATE_VAL, CUST_ID_VAL, CUST_ID_TYPE_VAL, NATIONALITY_CODE_VAL
FROM FI_BAN_SUMMARY_VALIDATION
WHERE FI_BAN_SUMMARY_VALIDATION.MSG_UID = r.MSGUID;




-- 1st level of validation. validate on [ExecDate only]
if r.LEVEL_OF_VALIDATION = 1
then
  IF (TRANS_DATE_VAL >=  to_date(r.EXEC_DATE, 'yyyy-MM-dd HH24:MI:ss'))
  THEN
    DBMS_OUTPUT.PUT_LINE('TRANS_DATE_VAL: ' || TRANS_DATE_VAL);
    DBMS_OUTPUT.PUT_LINE('r.EXEC_DATE: ' || to_date(r.EXEC_DATE, 'yyyy-MM-dd HH24:MI:ss'));
    STATUS_VAL:= 'INVALID_EXEC_DATE';
    DBMS_OUTPUT.PUT_LINE('-----------> First Level: ' || STATUS_VAL);
  END IF;
  
-- 2nd level of validation. validate on [ExecDate, customerInfo]
else 
if r.LEVEL_OF_VALIDATION = 2
then
  IF (TRANS_DATE_VAL >=  to_date(r.EXEC_DATE, 'yyyy-MM-dd HH24:MI:ss'))
  THEN
    DBMS_OUTPUT.PUT_LINE('TRANS_DATE_VAL: ' || TRANS_DATE_VAL);
    DBMS_OUTPUT.PUT_LINE('r.EXEC_DATE: ' || to_date(r.EXEC_DATE, 'yyyy-MM-dd HH24:MI:ss'));
    STATUS_VAL:= 'INVALID_EXEC_DATE';
  END IF;

  IF r.NAT IS NOT NULL 
  THEN
    IF ( CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE OR NATIONALITY_CODE_VAL != r.NAT)
    THEN
      STATUS_VAL:='INVALID_CUST_DATA';
    END IF;
    ELSE
    IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE)
    THEN
      STATUS_VAL:='INVALID_CUST_DATA';
    END IF;
  END IF;
  DBMS_OUTPUT.PUT_LINE('-----------> Second Level: ' || STATUS_VAL);
end if;
end if;

DBMS_OUTPUT.PUT_LINE('STATUS_VAL: ' || STATUS_VAL);

end;
END LOOP;

IF (STATUS_VAL = 'VALID')
THEN
DELETE FROM FI_BAN_SUMMARY_VALIDATION WHERE FI_BAN_SUMMARY_VALIDATION_ID = RECORD_ID;
DBMS_OUTPUT.PUT_LINE('Valid Record Deleted successfully');
END IF;


DBMS_OUTPUT.PUT_LINE('VALIDATE_BAN_DISPATCH_SP Ends');

 EXCEPTION
 when no_data_found then
  STATUS_VAL:='INVALID_CRN';
	WHEN OTHERs THEN
		Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 
END VALIDATE_BAN_DISPATCH_SP;