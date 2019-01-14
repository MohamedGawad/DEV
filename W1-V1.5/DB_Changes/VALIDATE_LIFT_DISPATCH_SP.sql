create or replace PROCEDURE VALIDATE_LIFT_DISPATCH_SP(INPUT_VAL IN XMLTYPE,STATUS_VAL OUT VARCHAR2) AS 

 firstLevelValidation varchar2(5 char);
 secondLevelValidation varchar2(5 char);
 msg_mode varchar2(5 char);
 
 CUST_ID_VAL VARCHAR2(256 CHAR);
 CUST_ID_TYPE_VAL VARCHAR2(5 CHAR);
 NATIONALITY_CODE_VAL VARCHAR2(20 CHAR);
 TRANS_DATE_VAL Date;
 RECORD_ID NUMBER;
 
BEGIN
  DBMS_OUTPUT.PUT_LINE('VALIDATE_LIFT_DISPATCH_SP');
    STATUS_VAL:= 'VALID';
  /*
<ValidateFICommonCallback>
	<custId>2834404758</custId>
	<msgUID>1800090001107</msgUID>
	<nationality>MLI</nationality>
	<exectionDate>2020-04-01 06:55:53</exectionDate>
	<custIdType>RID</custIdType>
</ValidateFICommonCallback>
<?xml version="1.0" encoding="UTF-8"?>
<p:ValidateFICommonCallback xmlns:p="http://BEA-Solution_Library/ProcessLib/Common" xmlns:msl="http://www.ibm.com/xmlmap" xmlns:out="http://BEA-Solution_Library/ProcessLib/Common" xmlns:in3="http://www.sama.bea.sa/common/BaseLib" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:in4="http://www.sama.bea.sa/common/Header" xmlns:in2="http://www.sama.bea.sa/execution/FILift" xmlns:in="http://BEA-Solution_Library/ProcessLib/Lift" xmlns:xs4xs="http://www.w3.org/2001/XMLSchema" xmlns:in5="http://www.sama.bea.sa/execution/common/ExecutionLibrary/ExecutionLib" xsi:type="p:ValidateFICommonCallback">
  <custId>2834404758</custId>
  <msgUID>1800090001107</msgUID>
  <nationality>MLI</nationality>
  <exectionDate>2020-04-01 06:55:53</exectionDate>
  <custIdType>RID</custIdType>
</p:ValidateFICommonCallback>

*/

  FOR r IN
      (SELECT ExtractValue(Value(p),'/ValidateFICommonCallback/nationality/text()') AS  NAT,
      Extract(Value(p),'/ValidateFICommonCallback/msgUID/text()').getStringVal() As MSGUID,
      Extract(Value(p),'/ValidateFICommonCallback/exectionDate/text()').getStringVal()  As EXEC_DATE,
      Extract(Value(p),'/ValidateFICommonCallback/custIdType/text()').getStringVal()  As CUST_ID_TYPE,
      Extract(Value(p),'/ValidateFICommonCallback/fiCode/text()').getStringVal()  As FI_CODE,
      Extract(Value(p),'/ValidateFICommonCallback/custId/text()').getStringVal()  As CUST_ID
--      Extract(Value(p),'/ValidateFICommonCallback/firstLevelValidation/text()').getStringVal()  As firstLevelValidation,
--      Extract(Value(p),'/ValidateFICommonCallback/secoundLevelValidation/text()').getStringVal()  As secoundLevelValidation
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/ValidateFICommonCallback'))) p)

   LOOP
   begin


SELECT TRANS_DATE, FI_LIFT_SUMMARY_VALIDATION_ID, INVOLVED_PARTY_ID, INVOLVED_PARTY_ID_TYPE, NAT_CD INTO TRANS_DATE_VAL, RECORD_ID, CUST_ID_VAL, CUST_ID_TYPE_VAL, NATIONALITY_CODE_VAL
FROM FI_LIFT_SUMMARY_VALIDATION
WHERE FI_LIFT_SUMMARY_VALIDATION.MSG_UID = r.MSGUID;


IF (TRANS_DATE_VAL >=  to_date(r.EXEC_DATE, 'yyyy-MM-dd HH24:MI:ss') )
THEN
STATUS_VAL:= 'INVALID_EXEC_DATE';
END IF;


IF r.NAT IS NOT NULL 
THEN
    IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE OR  NATIONALITY_CODE_VAL != r.NAT)
    THEN
        STATUS_VAL:='INVALID_CUST_DATA';
    END IF;
ELSE
    IF (CUST_ID_VAL != r.CUST_ID OR CUST_ID_TYPE_VAL != r.CUST_ID_TYPE )
    THEN
        STATUS_VAL:='INVALID_CUST_DATA';
    END IF;
END IF;


if (msg_mode='XFR')
THEN
SELECT XMLELEMENT("fi_lift_summary_validation",XMLELEMENT("fi_lift_summary_validation_id",flift.FI_LIFT_SUMMARY_VALIDATION_ID),
XMLELEMENT("msg_uid",flift.MSG_UID),
XMLELEMENT("msg_mode",flift.MSG_MODE),
XMLELEMENT("fi_code",flift.FI_CODE),
XMLELEMENT("trans_date",flift.TRANS_DATE),
XMLELEMENT("is_involved_party",flift.IS_INVOLVED_PARTY),
XMLELEMENT("is_acc_id",flift.IS_ACC_ID),
XMLELEMENT("involved_party_id",flift.INVOLVED_PARTY_ID),
XMLELEMENT("involved_party_id_type",flift.INVOLVED_PARTY_ID_TYPE),
XMLELEMENT("nat_cd",flift.NAT_CD),
XMLELEMENT("amt_val",flift.AMT_VAL),
XMLELEMENT("amr_cur",flift.AMT_CUR)) .GETCLOBVAL()
into STATUS_VAL
FROM FI_LIFT_SUMMARY_VALIDATION flift
WHERE flift.MSG_UID = r.MSGUID;
END IF;


end;
END LOOP;

IF (STATUS_VAL = 'VALID')
THEN
DELETE FROM FI_LIFT_SUMMARY_VALIDATION WHERE FI_LIFT_SUMMARY_VALIDATION_ID = RECORD_ID;
DBMS_OUTPUT.PUT_LINE('Valid Record Deleted successfully');
END IF;

DBMS_OUTPUT.PUT_LINE('VALIDATE_LIFT_DISPATCH_SP Ends');

 EXCEPTION
 when no_data_found then
  STATUS_VAL:='INVALID_CRN';
	WHEN OTHERs THEN
		Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 
END VALIDATE_LIFT_DISPATCH_SP;