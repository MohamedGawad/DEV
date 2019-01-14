create or replace PROCEDURE INSERT_FI_GI_SUM_VALID_SP (INPUT_VAL IN XMLTYPE , FI_GI_SUM_VALID_ID_OUT OUT VARCHAR2 )AS 

--INPUT_STR VARCHAR2(1000);
--INPUT_CUSTOM_VAL XMLTYPE;

BEGIN


/*
<fi_GI_Summary_Validation>
	<msg_uid> </msg_uid>
	<fi_code></fi_code>
	<trans_date></trans_date>
	<is_involved_party> </is_involved_party>
	<is_acc_id></is_acc_id>
	<involved_party_id> </involved_party_id>
	<involved_party_id_type> </involved_party_id_type>
	<nat_cd></nat_cd>
  <acc_qry></acc_qry>
  <is_iban></is_iban>
  <involved_party_type></involved_party_type>
</fi_GI_Summary_Validation>



 */

-- INPUT_STR := INPUT_VAL.getclobval();
-- INPUT_STR :=  concat('<parent>',INPUT_STR);
-- INPUT_STR := concat(INPUT_STR,'</parent>');
-- INPUT_CUSTOM_VAL := XMLTYPE(INPUT_STR);
-- DBMS_OUTPUT.PUT_LINE('INPUT_STR' || INPUT_STR);

 FOR r IN
          (SELECT ExtractValue(Value(p),'/fi_GI_Summary_Validation/msg_uid/text()') AS  MSG_UID,
      Extract(Value(p),'/fi_GI_Summary_Validation/fi_code/text()') As FI_CODE,
      Extract(Value(p),'/fi_GI_Summary_Validation/trans_date/text()') As TRANS_DATE,
      Extract(Value(p),'/fi_GI_Summary_Validation/is_involved_party/text()') As IS_INVOLVED_PARTY,
      Extract(Value(p),'/fi_GI_Summary_Validation/is_acc_id/text()') As IS_ACC_ID,
      Extract(Value(p),'/fi_GI_Summary_Validation/involved_party_id/text()') As INVOLVED_PARTY_ID,
      Extract(Value(p),'/fi_GI_Summary_Validation/involved_party_id_type/text()') As INVOLVED_PARTY_ID_TYPE,
      Extract(Value(p),'/fi_GI_Summary_Validation/nat_cd/text()') As NAT_CODE,
      Extract(Value(p),'/fi_GI_Summary_Validation/acc_qry/text()') As ACC_QRY,
      Extract(Value(p),'/fi_GI_Summary_Validation/is_iban/text()') As IS_IBAN,
      Extract(Value(p),'/fi_GI_Summary_Validation/involved_party_type/text()') As INVOLVED_PARTY_TYPE
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/InsertFISummaryValidation/fi_GI_Summary_Validation'))) p)

      LOOP
   begin
    INSERT INTO FI_GI_SUMMARY_VALIDATION 
    (
      MSG_UID,
      FI_CODE,
      TRANS_DATE,
      IS_INVOLVED_PARTY,
      IS_ACC_ID,
      INVOLVED_PARTY_ID,
      INVOLVED_PARTY_ID_TYPE,
      NAT_CD,
      ACC_QRY,
      IS_IBAN,
      INVOLVED_PARTY_TYPE
    )
    VALUES
    (
      r.MSG_UID,
      r.FI_CODE,
      to_date(r.TRANS_DATE,'YYYY-MM-DD HH24:MI:SS'),
      r.IS_INVOLVED_PARTY,
      r.IS_ACC_ID,
      r.INVOLVED_PARTY_ID,
      r.INVOLVED_PARTY_ID_TYPE,
      r.NAT_CODE,
      r.ACC_QRY,
      r.IS_IBAN,
      r.INVOLVED_PARTY_TYPE
    )RETURNING FI_GI_SUMMARY_VALIDATION_ID INTO FI_GI_SUM_VALID_ID_OUT;

  end;
  END LOOP;



 EXCEPTION
  WHEN OTHERs THEN
      Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 


END INSERT_FI_GI_SUM_VALID_SP;