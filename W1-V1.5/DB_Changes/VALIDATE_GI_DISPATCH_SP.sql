create or replace PROCEDURE VALIDATE_GI_DISPATCH_SP(INPUT_VAL IN XMLTYPE, STATUS_VAL OUT VARCHAR2) AS 
TRANS_DATE_VAL Date;
RECORD_ID NUMBER;
IS_ACC_ID varchar2(1 char);
BEGIN


DBMS_OUTPUT.PUT_LINE('VALIDATE_GI_DISPATCH_SP Starts');

/*
<ValidateFICommonCallback>
	<custId> </custId>
	<msgUID> </msgUID>
	<nationality> </nationality>
	<exectionDate> </exectionDate>
	<custIdType> </custIdType>
	<fiCode> </fiCode>
</ValidateFICommonCallback>
*/



FOR r IN
      (SELECT ExtractValue(Value(p),'/ValidateFICommonCallback/nationality/text()') AS  NAT,
      ExtractValue(Value(p),'/ValidateFICommonCallback/msgUID/text()') As MSGUID
    --  ExtractValue(Value(p),'/ValidateFICommonCallback/exectionDate/text()')  As EXEC_DATE,
   --   ExtractValue(Value(p),'/ValidateFICommonCallback/custIdType/text()')  As CUST_ID_TYPE,
  --    ExtractValue(Value(p),'/ValidateFICommonCallback/fiCode/text()') As FI_CODE,
     -- ExtractValue(Value(p),'/ValidateFICommonCallback/custId/text()')  As CUST_ID
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/ValidateFICommonCallback'))) p)

   LOOP
   begin
  --SUBSTR('ABCDEFG',3,4)
  -- SELECT CHARINDEX( 'York', 'New York', 1);
  DBMS_OUTPUT.PUT_LINE('sub = ' || SUBSTR(r.MSGUID,0, INSTR(r.MSGUID,'-')-1));

--
--
--      SELECT  FI_GI_SUMMARY_VALIDATION_ID,IS_ACC_ID INTO   RECORD_ID,IS_ACC_ID
--      FROM FI_GI_SUMMARY_VALIDATION
--      WHERE   SUBSTR(FI_GI_SUMMARY_VALIDATION.MSG_UID,0, INSTR(FI_GI_SUMMARY_VALIDATION.MSG_UID,'-')-1)  = SUBSTR(r.MSGUID,0, INSTR(r.MSGUID,'-')-1) 
--      --AND FI_DENY_SUMMARY_VALIDATION.FI_CODE = r.FI_CODE
--   --   AND FI_GI_SUMMARY_VALIDATION.INVOLVED_PARTY_ID = r.CUST_ID
--    --  AND FI_GI_SUMMARY_VALIDATION.INVOLVED_PARTY_ID_TYPE = r.CUST_ID_TYPE
--      --AND FI_GI_SUMMARY_VALIDATION.NAT_CD = r.NAT
--      and rownum=1;





-- delete valid records from validation summary
--DELETE FROM FI_GI_SUMMARY_VALIDATION WHERE FI_GI_SUMMARY_VALIDATION_ID = RECORD_ID;


SELECT XMLELEMENT("fi_gi_summary_validation",XMLELEMENT("fi_gi_summary_validation_id",gi.FI_GI_SUMMARY_VALIDATION_ID),
XMLELEMENT("msg_uid",gi.MSG_UID),

XMLELEMENT("fi_code",gi.FI_CODE),
XMLELEMENT("trans_date",gi.TRANS_DATE),
XMLELEMENT("is_involved_party",gi.IS_INVOLVED_PARTY),
XMLELEMENT("is_acc_id",gi.IS_ACC_ID),
XMLELEMENT("involved_party_id",gi.INVOLVED_PARTY_ID),
XMLELEMENT("involved_party_id_type",gi.INVOLVED_PARTY_ID_TYPE),
XMLELEMENT("nat_cd",gi.NAT_CD),
XMLELEMENT("acc_qry",gi.ACC_QRY),
XMLELEMENT("is_iban",gi.IS_IBAN),
XMLELEMENT("involved_party_type",gi.INVOLVED_PARTY_TYPE)

) .GETCLOBVAL()
into STATUS_VAL
FROM FI_GI_SUMMARY_VALIDATION gi
WHERE   SUBSTR(gi.MSG_UID,0, INSTR(gi.MSG_UID,'-')-1)  = SUBSTR(r.MSGUID,0, INSTR(r.MSGUID,'-')-1)    and rownum=1; 

end;
END LOOP;



DBMS_OUTPUT.PUT_LINE('VALIDATE_GI_DISPATCH_SP Ends');

 EXCEPTION
 when no_data_found then
  STATUS_VAL:='INVALID_CUST_DATA';
	WHEN OTHERs THEN
		Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 
END VALIDATE_GI_DISPATCH_SP;