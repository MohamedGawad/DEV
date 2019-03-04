create or replace PROCEDURE INSERT_BLOCK_RQST_SP(INPUT_VAL IN XMLTYPE, AGCY_SRVC_RQST_ID_INPUT IN VARCHAR2) AS 
BEGIN

/*
 <block_Exec_Reqst>
  <dcsn_num>4321</dcsn_num> 
  <dcsn_date>2018-05-15</dcsn_date>
  <dbt_type>1</dbt_type>
  <amt_val>1000.0</amt_val> 
  <amt_cur>usd</amt_cur>
  <bai_num>654</bai_num>
  <bai_iban>4444</bai_iban>
  <bai_bic>555</bai_bic>
  <benf_iban>555</benf_iban>
  <benf_bic>66</benf_bic>
  <benf_name>2</benf_name>
</block_Exec_Reqst>
  <block_exec_reqst>
    <dcsn_num>767575675</dcsn_num>
    <dcsn_date>2018-06-09</dcsn_date>
    <dbt_type>01</dbt_type>
    <amt_val>10000</amt_val>
    <amt_cur>SAR</amt_cur>
    <benf_iban>SA2345986754324589603333</benf_iban>
    <benf_bic>90005</benf_bic>
    <benf_name>Ahmed Samir</benf_name>
  </block_exec_reqst>444
*/

DBMS_OUTPUT.PUT_LINE('Block Rqst Ens  1>>>______________________________________>' );

 FOR r IN
      (SELECT ExtractValue(Value(p),'/block_Exec_Reqst/dcsn_num/text()') AS DECISION_NUMBER ,
      Extract(Value(p),'/block_Exec_Reqst/dcsn_date/text()') As DECISION_DATE,
      Extract(Value(p),'/block_Exec_Reqst/dbt_type/text()') As DBT_TYPE,
      Extract(Value(p),'/block_Exec_Reqst/amt_val/text()').getnumberval() As AMMOUNT_VALUE,
      Extract(Value(p),'/block_Exec_Reqst/amt_cur/text()') As AMMOUNT_CUR,
      Extract(Value(p),'/block_Exec_Reqst/bai_num/text()') As BAI_NUMBER,
      Extract(Value(p),'/block_Exec_Reqst/bai_iban/text()') As BAI_IBAN,
      Extract(Value(p),'/block_Exec_Reqst/bai_bic/text()') As BAI_BIC,
      Extract(Value(p),'/block_Exec_Reqst/benf_iban/text()') As BENF_IBAN,
      Extract(Value(p),'/block_Exec_Reqst/benf_bic/text()') As BENF_BIC,
      Extract(Value(p),'/block_Exec_Reqst/benf_name/text()') As BENF_NAME,
      Extract(Value(p),'/block_Exec_Reqst/acc_flag/text()') As ACC_FLAG,
      Extract(Value(p),'/block_Exec_Reqst/depost_flag/text()') As DEPOST_FLAG,
      Extract(Value(p),'/block_Exec_Reqst/safs_flag/text()') As SAFS_FLAG,
      Extract(Value(p),'/block_Exec_Reqst/auto_xfer/text()') As AUTO_XFER
      
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/RPRqstDetailsInput/block_Exec_Reqst'))) p
      WHERE EXISTSNODE(INPUT_VAL,'/RPRqstDetailsInput/block_Exec_Reqst/dcsn_num') =1
      )


      LOOP
   begin
   DBMS_OUTPUT.PUT_LINE('Block Rqst Ens  1>>>______________________________________>' );
    INSERT INTO BLOCK_EXEC_REQST
  (
    AGCY_SRVC_REQST_ID,
    DCSN_NUM,
    DCSN_DATE,
    DBT_TYPE,
    AMT_VAL,
    AMT_CUR,
    BAI_NUM,
    BAI_IBAN,
    BAI_BIC,
    BENF_IBAN,
    BENF_BIC,
    BENF_NAME,
    ACC_FLAG,
    DEPOST_FLAG,
    SAFS_FLAG,
    AUTO_XFER
  )
  VALUES
  (
    AGCY_SRVC_RQST_ID_INPUT,
    r.DECISION_NUMBER,
    to_date(r.DECISION_DATE,'YYYY-MM-DD'),
    r.DBT_TYPE,
    r.AMMOUNT_VALUE,
    r.AMMOUNT_CUR,
    r.BAI_NUMBER,
    r.BAI_IBAN,
    r.BAI_BIC,
    r.BENF_IBAN,
    r.BENF_BIC,
    r.BENF_NAME,
    r.ACC_FLAG,
    r.DEPOST_FLAG,
    r.SAFS_FLAG,
    r.AUTO_XFER
  );
    DBMS_OUTPUT.PUT_LINE('Block Rqst Ens  >>>______________________________________>' );
  end;
  END LOOP;


EXCEPTION
  WHEN OTHERs THEN
      Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM); 

DBMS_OUTPUT.PUT_LINE('Block Rqst Ens  4>>>______________________________________>' );
END INSERT_BLOCK_RQST_SP;