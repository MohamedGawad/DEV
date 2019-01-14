CREATE OR REPLACE PROCEDURE INSERT_FI_BAN_SUM_VALID_SP(INPUT_VAL IN XMLTYPE , FI_BAN_SUM_VALID_ID_OUT OUT VARCHAR2) AS 
BEGIN
  /*

  <Fi_Ban_Summary_Validation>
	<msg_uid> </msg_uid>
	<fi_code></fi_code>
	<trans_date></trans_date>
	<is_involved_party> </is_involved_party>
	<is_acc_id></is_acc_id>
	<involved_party_id> </involved_party_id>
	<involved_party_id_type> </involved_party_id_type>
	<nat_cd></nat_cd>
</Fi_Ban_Summary_Validation>

*/



FOR r IN
      (SELECT ExtractValue(Value(p),'/fi_Ban_Summary_Validation/msg_uid/text()') AS  MSG_UID,
      Extract(Value(p),'/fi_Ban_Summary_Validation/fi_code/text()') As FI_CODE,
      Extract(Value(p),'/fi_Ban_Summary_Validation/trans_date/text()') As TRANS_DATE,
--      Extract(Value(p),'/fi_Ban_Summary_Validation/is_involved_party/text()') As IS_INVOLVED_PARTY,
--      Extract(Value(p),'/fi_Ban_Summary_Validation/is_acc_id/text()') As IS_ACC_ID,
      Extract(Value(p),'/fi_Ban_Summary_Validation/involved_party_id/text()') As INVOLVED_PARTY_ID,
      Extract(Value(p),'/fi_Ban_Summary_Validation/involved_party_id_type/text()') As INVOLVED_PARTY_ID_TYPE,
      Extract(Value(p),'/fi_Ban_Summary_Validation/nat_cd/text()') As NAT_CODE
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/InsertFISummaryValidation/fi_Ban_Summary_Validation'))) p)

      LOOP
   begin
    INSERT INTO FI_BAN_SUMMARY_VALIDATION 
    (
      MSG_UID,
      FI_CODE,
      TRANS_DATE,
--      IS_INVOLVED_PARTY,
--      IS_ACC_ID,
      INVOLVED_PARTY_ID,
      INVOLVED_PARTY_ID_TYPE,
      NAT_CD
    )
    VALUES
    (
      r.MSG_UID,
      r.FI_CODE,
      to_date(r.TRANS_DATE,'YYYY-MM-DD HH24:MI:SS'),
--      r.IS_INVOLVED_PARTY,
--      r.IS_ACC_ID,
      r.INVOLVED_PARTY_ID,
      r.INVOLVED_PARTY_ID_TYPE,
      r.NAT_CODE
    )RETURNING FI_BAN_SUMMARY_VALIDATION_ID INTO FI_BAN_SUM_VALID_ID_OUT;

  end;
  END LOOP;



END INSERT_FI_BAN_SUM_VALID_SP;