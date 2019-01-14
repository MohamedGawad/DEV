create or replace PROCEDURE INSERT_EXEC_SUMMARY_SP(
    INPUT_VAL IN XMLTYPE)
AS
  xml_EXEC_RUNNING_TOTAL XMLTYPE ;
  exec_Summary_Id_Val       NUMBER;
  exec_Running_total_Id_Val NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('INSERT_EXEC_SUMMARY_SP starts');
  /*
  <InsertExecSummary>
  <exec_Summary>
  <agcy_srvc_reqst_id></agcy_srvc_reqst_id>
  <srvc_reqst_srn></srvc_reqst_srn>
  <reqstr_cd></reqstr_cd>
  <post_action_srn></post_action_srn>
  <status></status>
  <lst_update_date></lst_update_date>
  <available_amt></available_amt>
  <pending_amt></pending_amt>
  </exec_Summary>
  <exec_Running_Totals>
  <exec_summary_id></exec_summary_id>
  <fin_inst_cd></fin_inst_cd>
  <acc_num></acc_num>
  <acc_currency></acc_currency>
  <available_amt></available_amt>
  <creation_date></creation_date>
  </exec_Running_Totals>
  </InsertExecSummary>
  */
  FOR r IN
  (SELECT ExtractValue(Value(p),'/InsertExecSummary/exec_Summary/srvc_reqst_srn/text()')         AS SRVC_RQST_SRN,
    Extract(Value(p),'/InsertExecSummary/exec_Summary/agcy_srvc_reqst_id/text()').getnumberval() AS AGCY_SRVC_RQST_ID,
    Extract(Value(p),'/InsertExecSummary/exec_Summary/reqstr_cd/text()')                         AS REQSTR_CD,
    Extract(Value(p),'/InsertExecSummary/exec_Summary/post_action_srn/text()')                   AS POST_ACTION_SRN,
    Extract(Value(p),'/InsertExecSummary/exec_Summary/status/text()')                            AS STATUS,
    Extract(Value(p),'/InsertExecSummary/exec_Summary/lst_update_date/text()')                   AS LST_UPDATE_DATE,
    Extract(Value(p),'/InsertExecSummary/exec_Summary/available_amt/text()').getnumberval()      AS AVAILABLE_AMT,
    Extract(Value(p),'/InsertExecSummary/exec_Summary/pending_amt/text()').getnumberval()        AS PENDING_AMT
    --      Extract(Value(p),'/InsertExecSummary/exec_Running_Totals').getClobVal() As EXEC_RUNNING_TOTAL
  FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/InsertExecSummary'))) p
  )
  LOOP
    BEGIN
      INSERT
      INTO EXEC_SUMMARY
        (
          AGCY_SRVC_REQST_ID,
          SRVC_REQST_SRN,
          REQSTR_CD,
          POST_ACTION_SRN,
          STATUS,
          LST_UPDATE_DATE,
          AVAILABLE_AMT,
          PENDING_AMT
        )
        VALUES
        (
          r.AGCY_SRVC_RQST_ID,
          r.SRVC_RQST_SRN,
          r.REQSTR_CD,
          r.POST_ACTION_SRN,
          r.STATUS,
          to_date(r.LST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS'),
          r.AVAILABLE_AMT ,
          r.PENDING_AMT
        )
      RETURNING EXEC_SUMMARY_ID
      INTO exec_Summary_Id_Val;
      DBMS_OUTPUT.PUT_LINE('===================exec_Summary_Id_Val : ' ||exec_Summary_Id_Val);
      --r.EXEC_RUNNING_TOTAL := CONCAT('<exec_Running_Totals_Root>',r.EXEC_RUNNING_TOTAL );
      --r.EXEC_RUNNING_TOTAL := CONCAT(r.EXEC_RUNNING_TOTAL, '</exec_Running_Totals_Root>' );
      --xml_EXEC_RUNNING_TOTAL := new XMLTYPE(r.EXEC_RUNNING_TOTAL);
    END;
  END LOOP;
  ---
  DBMS_OUTPUT.PUT_LINE('===================#### 1 ####===========');
  FOR h IN
  (SELECT Extract(Value(N),'/exec_Running_Totals/fin_inst_cd/text()')              AS FIN_INST_CD,
      Extract(Value(N),'/exec_Running_Totals/acc_num/text()')                      AS ACC_NUM,
      Extract(Value(N),'/exec_Running_Totals/acc_currency/text()')                 AS ACC_CURRENCY,
      Extract(Value(N),'/exec_Running_Totals/available_amt/text()').getnumberval() AS AVAILABLE_AMT
--      Extract(Value(N),'/exec_Running_Totals/creation_date/text()')                AS CREATION_DATE
    FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/InsertExecSummary/exec_Running_Totals'))) N
  )
  LOOP
    BEGIN
      DBMS_OUTPUT.PUT_LINE('===================#### 2 ####===========');
      INSERT
      INTO EXEC_RUNNING_TOTALS
        (
          EXEC_SUMMARY_ID,
          FIN_INST_CD,
          ACC_NUM,
          ACC_CURRENCY,
          AVAILABLE_AMT
--          CREATION_DATE
        )
        VALUES
        (
          exec_Summary_Id_Val,
          h.FIN_INST_CD,
          h.ACC_NUM,
          h.ACC_CURRENCY,
          h.AVAILABLE_AMT
--          to_date(h.CREATION_DATE,'YYYY-MM-DD HH24:MI:SS')
        )
      RETURNING EXEC_RUNNING_TOTALS_ID
      INTO exec_Running_total_Id_Val;
      DBMS_OUTPUT.PUT_LINE('===================exec_Summary_Running_total_Id_Val : ' ||exec_Running_total_Id_Val);
    END;
  END LOOP;
  ---
  DBMS_OUTPUT.PUT_LINE('INSERT_EXEC_SUMMARY_SP ends');
  --EXCEPTION
  --  WHEN OTHERs THEN
  --      Raise_application_error(-20322, 'UNKNOWN ERROR>>'|| SQLERRM);
END INSERT_EXEC_SUMMARY_SP;