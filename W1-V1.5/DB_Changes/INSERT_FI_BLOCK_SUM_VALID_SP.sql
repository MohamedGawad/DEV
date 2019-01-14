create or replace PROCEDURE INSERT_FI_BLOCK_SUM_VALID_SP (INPUT_VAL IN XMLTYPE , FI_BLOCK_SUM_VALID_ID_OUT OUT VARCHAR2) AS 
BEGIN


  /*

<InsertFISummaryValidation xmlns:ns0="http://BEA_Solution_Block_Module/ProcessLib/DispatchFIInput" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns0:InsertFISummaryValidation">
  <fi_Block_Summary_Validation>
    <msg_uid>1800100001040-S1211289600755230397</msg_uid>
    <msg_mode xsi:nil="true"/>
    <fi_code>90010</fi_code>
    <trans_date>2018-11-22 11:15:12.550</trans_date>
    <is_acc_id>0</is_acc_id>
    <involved_party_id>2834404758</involved_party_id>
    <involved_party_id_type>RID</involved_party_id_type>
    <nat_cd>MLI</nat_cd>
    <amt_val>10000.0</amt_val>
    <amt_cur>SAR</amt_cur>
  </fi_Block_Summary_Validation>
  <fi_Block_Summary_Validation>
    <msg_uid>1800100001040-S1211289618921989681</msg_uid>
    <msg_mode xsi:nil="true"/>
    <fi_code>90055</fi_code>
    <trans_date>2018-11-22 11:15:12.568</trans_date>
    <is_acc_id>0</is_acc_id>
    <involved_party_id>2834404758</involved_party_id>
    <involved_party_id_type>RID</involved_party_id_type>
    <nat_cd>MLI</nat_cd>
    <amt_val>10000.0</amt_val>
    <amt_cur>SAR</amt_cur>
  </fi_Block_Summary_Validation>
  <fi_Block_Summary_Validation>
    <msg_uid>1800100001040-S121128962570459940</msg_uid>
    <msg_mode xsi:nil="true"/>
    <fi_code>90030</fi_code>
    <trans_date>2018-11-22 11:15:12.574</trans_date>
    <is_acc_id>0</is_acc_id>
    <involved_party_id>2834404758</involved_party_id>
    <involved_party_id_type>RID</involved_party_id_type>
    <nat_cd>MLI</nat_cd>
    <amt_val>10000.0</amt_val>
    <amt_cur>SAR</amt_cur>
  </fi_Block_Summary_Validation>
</InsertFISummaryValidation>


  */



  FOR r IN
      (SELECT ExtractValue(Value(p),'/fi_Block_Summary_Validation/msg_uid/text()') AS  MSG_UID,
      Extract(Value(p),'/fi_Block_Summary_Validation/msg_mode/text()') As MSG_MODE,
      Extract(Value(p),'/fi_Block_Summary_Validation/fi_code/text()') As FI_CODE,
      Extract(Value(p),'/fi_Block_Summary_Validation/trans_date/text()') As TRANS_DATE,
--      Extract(Value(p),'/fi_Block_Summary_Validation/is_involved_party/text()') As IS_INVOLVED_PARTY,
      Extract(Value(p),'/fi_Block_Summary_Validation/is_acc_id/text()') As IS_ACC_ID,
      Extract(Value(p),'/fi_Block_Summary_Validation/involved_party_id/text()') As INVOLVED_PARTY_ID,
      Extract(Value(p),'/fi_Block_Summary_Validation/involved_party_id_type/text()') As INVOLVED_PARTY_ID_TYPE,
      Extract(Value(p),'/fi_Block_Summary_Validation/nat_cd/text()') As NAT_CODE,
      Extract(Value(p),'/fi_Block_Summary_Validation/amt_val/text()').getnumberval() As AMT_VAL,
      Extract(Value(p),'/fi_Block_Summary_Validation/amt_cur/text()') As AMT_CUR,
      Extract(Value(p),'/fi_Block_Summary_Validation/acc_num/text()') As ACC_NUM,
      Extract(Value(p),'/fi_Block_Summary_Validation/is_iban/text()') As IS_IBAN
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/InsertFISummaryValidation/fi_Block_Summary_Validation'))) p)

      LOOP
   begin
    INSERT INTO FI_BLOCK_SUMMARY_VALIDATION 
    (
      MSG_UID,
      MSG_MODE,
      FI_CODE,
      TRANS_DATE,
--      IS_INVOLVED_PARTY,
      IS_ACC_ID,
      INVOLVED_PARTY_ID,
      INVOLVED_PARTY_ID_TYPE,
      NAT_CD,
      AMT_VAL,
      AMT_CUR,
      ACC_NUM,
      IS_IBAN
    )
    VALUES
    (
      r.MSG_UID,
      r.MSG_MODE,
      r.FI_CODE,
      to_date(r.TRANS_DATE,'YYYY-MM-DD HH24:MI:SS'),
--      r.IS_INVOLVED_PARTY,
      r.IS_ACC_ID,
      r.INVOLVED_PARTY_ID,
      r.INVOLVED_PARTY_ID_TYPE,
      r.NAT_CODE,
      r.AMT_VAL,
      r.AMT_CUR,
      r.ACC_NUM,
      r.IS_IBAN
    )RETURNING FI_BLOCK_SUMMARY_VALIDATION_ID INTO FI_BLOCK_SUM_VALID_ID_OUT;

  end;
  END LOOP;


  EXCEPTION
  WHEN OTHERs THEN
      Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 





END INSERT_FI_BLOCK_SUM_VALID_SP;