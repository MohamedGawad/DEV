create or replace PROCEDURE INSERT_GI_RESP_SP(INPUT_VAL IN XMLTYPE) 
AS 
acc_INFO_RESP_PK ACC_INFO_RESP.ACC_INQ_RESP_ID%TYPE;
acc_BAL_RESP_PK ACC_BAL_INFO_RESP.ACC_BAL_INFO_RESP_ID%TYPE;
deposite_INFO_RESP_PK DEPOSIT_INFO_RESP.DEPOSIT_INFO_RESP_ID%TYPE;
safe_INFO_RESP_PK SAFE_INFO_RESP.SAFE_INFO_RESP_ID%TYPE;
liab_INFO_RESP_PK LIAB_INFO_RESP.LIAB_INFO_RESP_ID%TYPE;
NEW_INPUT XMLTYPE;
BEGIN

/*
<FIRespDetailsInput>
	<detail> 
		<acc_info_resp> 
			<acc_no>204000010006020302030</acc_no> 
			<iban>1</iban>
			<acc_type>CUR_ACCT</acc_type>
			<acc_status>03</acc_status>
			<exetr_srvc_task_id>4023</exetr_srvc_task_id>
			<acc_opening_date>2018-12-06 12:30:00</acc_opening_date>
			<acc_closing_date>2018-12-07 13:00:00</acc_closing_date>
			<inst>NAA</inst>
			<currency>LE</currency>
			<jnt_acc>n</jnt_acc>
		</acc_info_resp>
		<acc_info_resp_usr><!--[]-->
			<prd_type>03</prd_type>
			<prd_user_id>66554</prd_user_id>
			<prd_user_id_type>RID</prd_user_id_type>
			<prd_user_type>USR_T</prd_user_type>
			<prd_user_name>mramdan</prd_user_name>
		</acc_info_resp_usr>
		<acc_info_shrs><!--[]-->
			<prd_type>012</prd_type>
			<comp_name>IBM EGYPT</comp_name>
		</acc_info_shrs>
		<bal_info_resp>
			<acc_no>204000010006020302030</acc_no>
			<iban>SA2580000204608020302030</iban>
			<acc_status>03</acc_status>
			<available_bal>470000</available_bal>
			<currency>SAR</currency>
			<bal_date>2018-12-05 02:40:00</bal_date>
			<exetr_srvc_task_id>4023</exetr_srvc_task_id>
			<acc_type>CUR_ACCT</acc_type>
			<total_bal>480000</total_bal>
			<jnt_acc>n</jnt_acc>
			<inst>NAA</inst>
		</bal_info_resp>
		<bal_info_resp_usr><!--[]-->
			<prd_type>03</prd_type>
			<prd_user_id>66554</prd_user_id>
			<prd_user_id_type>RID</prd_user_id_type>
			<prd_user_type>USR_T</prd_user_type>
			<prd_user_name>mramdan</prd_user_name>
		</bal_info_resp_usr>
    <bal_info_shrs>
      <prd_type>012</prd_type>
			<comp_name>IBM EGYPT</comp_name>
    </bal_info_shrs>
		<deposit_info_resp>
			<deposit_no>DP0020302030</deposit_no>
			<deposit_currency>SAR</deposit_currency>
			<due_date>2018-12-05 02:40:00</due_date>
			<deposit_type>Direct Investment</deposit_type>
			<deposit_bal>480000</deposit_bal>
			<start_date>2018-12-05 02:40:00</start_date>
			<exetr_srvc_task_id>4023</exetr_srvc_task_id>
			<deposit_status>03</deposit_status>
			<jnt_acc>n</jnt_acc>
		</deposit_info_resp>
		<deposit_info_resp_usr><!--[]-->
			<prd_type>03</prd_type>
			<prd_user_id>66554</prd_user_id>
			<prd_user_id_type>RID</prd_user_id_type>
			<prd_user_type>USR_T</prd_user_type>
			<prd_user_name>mramdan</prd_user_name>
		</deposit_info_resp_usr>
		<safe_info_resp>
			<box_no>10</box_no>
			<exetr_srvc_task_id>4023</exetr_srvc_task_id>
			<box_opn_date>2018-12-05 02:40:00</box_opn_date>
			<safe_branch>11</safe_branch>
			<jnt_acc>n</jnt_acc>
		</safe_info_resp>
		<safe_info_resp_usr><!--[]-->
			<prd_type>03</prd_type>
			<prd_user_id>66554</prd_user_id>
			<prd_user_id_type>RID</prd_user_id_type>
			<prd_user_type>USR_T</prd_user_type>
			<prd_user_name>mramdan</prd_user_name>
		</safe_info_resp_usr>
		<liab_info_resp>
			<exetr_srvc_task_id>4023</exetr_srvc_task_id>
			<acc_no>68200019863000</acc_no>
			<iban>SA7505000068200020302030</iban>
			<total_liab_amt>470000</total_liab_amt>
			<type_of_liab>type1</type_of_liab>
			<remaining_liab_amt>48000</remaining_liab_amt>
			<no_of_instal>10</no_of_instal>
			<last_payment_date>2018-12-05 12:30:00</last_payment_date>
			<instal_amt>1000</instal_amt>
			<liab_due_date>2018-12-06 14:40:00</liab_due_date>
			<liab_currency>SAR</liab_currency>
			<instal_repeat>05</instal_repeat>
      <INSTAL_REPEAT_TIMES> </INSTAL_REPEAT_TIMES>
		</liab_info_resp>
		<liab_info_resp_usr><!--[]-->
			<prd_type>03</prd_type>
			<prd_user_id>66554</prd_user_id>
			<prd_user_id_type>RID</prd_user_id_type>
			<prd_user_type>USR_T</prd_user_type>
			<prd_user_name>mramdan</prd_user_name>
		</liab_info_resp_usr>
	</detail>
</FIRespDetailsInput>
*/






FOR z IN
      (SELECT Extract(Value(p),'/detail') AS  DETAILS
      FROM TABLE(XMLSequence(Extract(INPUT_VAL,'/FIRespDetailsInput/detail'))) p

      )

      LOOP
   begin

   NEW_INPUT:= NEW XMLTYPE(z.DETAILS.getCLOBVAL());
  --+--------------------+--------------+----------------+-----------+---------- 
   -- ========================= acc_info_resp starts ====================================================
DBMS_OUTPUT.PUT_LINE('acc_info_resp starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/acc_info_resp/acc_no/text()') AS  ACC_NO,
      Extract(Value(p),'/acc_info_resp/iban/text()') As IBAN,
      Extract(Value(p),'/acc_info_resp/acc_type/text()') As ACC_TYPE,
      Extract(Value(p),'/acc_info_resp/acc_status/text()') As ACC_STATUS,
      Extract(Value(p),'/acc_info_resp/exetr_srvc_task_id/text()').getnumberval() As EXETR_SRVC_TASK_ID,
      Extract(Value(p),'/acc_info_resp/acc_opening_date/text()') As ACC_OPENING_DATE,
      Extract(Value(p),'/acc_info_resp/acc_closing_date/text()') As ACC_CLOSING_DATE,
      Extract(Value(p),'/acc_info_resp/inst/text()') As INST,
      Extract(Value(p),'/acc_info_resp/currency/text()') As CURRENCY,
      Extract(Value(p),'/acc_info_resp/jnt_acc/text()') As JNT_ACC
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/acc_info_resp'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/acc_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO ACC_INFO_RESP
   (

      ACC_NO,
      IBAN,
      ACC_TYPE,
      ACC_STATUS,
      EXETR_SRVC_TASK_ID,
      ACC_OPENING_DATE,
      ACC_CLOSING_DATE,
      INST,
      CURRENCY,
      JNT_ACC
   )
   VALUES
   (

      r.ACC_NO,
      r.IBAN,
      r.ACC_TYPE,
      r.ACC_STATUS,
      r.EXETR_SRVC_TASK_ID,
      to_date(r.ACC_OPENING_DATE, 'YYYY-MM-DD HH24:MI:SS'),
      to_date(r.ACC_CLOSING_DATE, 'YYYY-MM-DD HH24:MI:SS'),
      r.INST,
      r.CURRENCY,
      r.JNT_ACC
   ) RETURNING ACC_INQ_RESP_ID INTO acc_INFO_RESP_PK;



  end;
  END LOOP;
DBMS_OUTPUT.PUT_LINE('acc_info_resp ends');
DBMS_OUTPUT.PUT_LINE('acc_INFO_RESP_PK ' || acc_INFO_RESP_PK);
-- ========================= acc_info_resp ends ====================================================

-- ========================= acc_info_resp_usr starts ==============================================
DBMS_OUTPUT.PUT_LINE('acc_info_resp_usr starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/acc_info_resp_usr/prd_type/text()') AS  PRD_TYPE,
      Extract(Value(p),'/acc_info_resp_usr/prd_user_id/text()') As PRD_USER_ID,
      Extract(Value(p),'/acc_info_resp_usr/prd_user_id_type/text()') As PRD_USER_ID_TYPE,
      Extract(Value(p),'/acc_info_resp_usr/prd_user_type/text()') As PRD_USER_TYPE,
      Extract(Value(p),'/acc_info_resp_usr/prd_user_name/text()') As PRD_USER_NAME
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/acc_info_resp_usr'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/acc_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO PRD_USR_LST
   (
      PRD_ID,
      PRD_TYPE,
      PRD_USER_ID,
      PRD_USER_ID_TYPE,
      PRD_USER_TYPE,
      PRD_USER_NAME
   )
   VALUES
   (
      acc_INFO_RESP_PK,
      r.PRD_TYPE,
      r.PRD_USER_ID,
      r.PRD_USER_ID_TYPE,
      r.PRD_USER_TYPE,
      r.PRD_USER_NAME
   );

  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('acc_info_resp_usr ends');
-- ========================= acc_info_resp_usr ends ================================================


-- ========================= acc_info_shrs Starts ==============================================
DBMS_OUTPUT.PUT_LINE('acc_info_shrs starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/acc_info_shrs/prd_type/text()') AS  PRD_TYPE,
      Extract(Value(p),'/acc_info_shrs/comp_name/text()') As COMP_NAME,
      Extract(Value(p),'/acc_info_shrs/prd_id/text()').getnumberval() As PRD_ID
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/acc_info_shrs'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/acc_info_shrs') = 1
      )

      LOOP
   begin
   INSERT INTO PRD_SHRS
   (
      PRD_ID,
      PRD_TYPE,
      COMP_NAME
   )
   VALUES
   (
      r.PRD_ID,
      r.PRD_TYPE,
      r.COMP_NAME
   );

  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('acc_info_shrs ends');
-- ========================= acc_info_shrs ends ================================================


-- ========================= bal_info_resp startss =============================================
DBMS_OUTPUT.PUT_LINE('bal_info_resp starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/bal_info_resp/acc_no/text()') AS  ACC_NO,
      Extract(Value(p),'/bal_info_resp/iban/text()') As IBAN,
      Extract(Value(p),'/bal_info_resp/acc_status/text()') As ACC_STATUS,
      Extract(Value(p),'/bal_info_resp/available_bal/text()').getnumberval() As AVAILABLE_BAL,
      Extract(Value(p),'/bal_info_resp/currency/text()') As CURRENCY,
      Extract(Value(p),'/bal_info_resp/bal_date/text()') As BAL_DATE,
      Extract(Value(p),'/bal_info_resp/exetr_srvc_task_id/text()').getnumberval() As EXETR_SRVC_TASK_ID,
      Extract(Value(p),'/bal_info_resp/acc_type/text()') As ACC_TYPE,
      Extract(Value(p),'/bal_info_resp/total_bal/text()').getnumberval() As TOTAL_BAL,
      Extract(Value(p),'/bal_info_resp/jnt_acc/text()') As JNT_ACC,
      Extract(Value(p),'/bal_info_resp/inst/text()') As INST
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/bal_info_resp'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/bal_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO ACC_BAL_INFO_RESP
   (

      ACC_NO,
      IBAN,
      ACC_STATUS,
      AVAILABLE_BAL,
      CURRENCY,
      BAL_DATE,
      EXETR_SRVC_TASK_ID,
      ACC_TYPE,
      TOTAL_BAL,
      JNT_ACC,
      INST
   )
   VALUES
   (

      r.ACC_NO,
      r.IBAN,
      r.ACC_STATUS,
      r.AVAILABLE_BAL,
      r.CURRENCY,
      to_date(r.BAL_DATE,'YYYY-MM-DD HH24:MI:SS'),
      r.EXETR_SRVC_TASK_ID,
      r.ACC_TYPE,
      r.TOTAL_BAL,
      r.JNT_ACC,
      r.INST  
   )RETURNING ACC_BAL_INFO_RESP_ID INTO  acc_BAL_RESP_PK;


  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('bal_info_resp ends');
-- ========================= bal_info_resp ends ================================================


-- ========================= bal_info_resp_usr starts ============================================
DBMS_OUTPUT.PUT_LINE('bal_info_resp_usr starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/bal_info_resp_usr/prd_type/text()') AS  PRD_TYPE,
      Extract(Value(p),'/bal_info_resp_usr/prd_user_id/text()') As PRD_USER_ID,
      Extract(Value(p),'/bal_info_resp_usr/prd_user_id_type/text()') As PRD_USER_ID_TYPE,
      Extract(Value(p),'/bal_info_resp_usr/prd_user_type/text()') As PRD_USER_TYPE,
      Extract(Value(p),'/bal_info_resp_usr/prd_user_name/text()') As PRD_USER_NAME
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/bal_info_resp_usr'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/bal_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO PRD_USR_LST
   (
      PRD_ID,
      PRD_TYPE,
      PRD_USER_ID,
      PRD_USER_ID_TYPE,
      PRD_USER_TYPE,
      PRD_USER_NAME
   )
   VALUES
   (
      acc_BAL_RESP_PK,
      r.PRD_TYPE,
      r.PRD_USER_ID,
      r.PRD_USER_ID_TYPE,
      r.PRD_USER_TYPE,
      r.PRD_USER_NAME
   );

  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('bal_info_resp_usr ends');
-- ========================= bal_info_resp_usr ends ==============================================


-- ========================= bal_info_shrs Starts ==============================================
DBMS_OUTPUT.PUT_LINE('bal_info_shrs starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/bal_info_shrs/prd_type/text()') AS  PRD_TYPE,
      Extract(Value(p),'/bal_info_shrs/comp_name/text()') As COMP_NAME,
      Extract(Value(p),'/bal_info_shrs/prd_id/text()').getnumberval() As PRD_ID
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/bal_info_shrs'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/bal_info_shrs') = 1
      )

      LOOP
   begin
   INSERT INTO PRD_SHRS
   (
      PRD_ID,
      PRD_TYPE,
      COMP_NAME
   )
   VALUES
   (
      r.PRD_ID,
      r.PRD_TYPE,
      r.COMP_NAME
   );

  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('bal_info_shrs ends');
-- ========================= bal_info_shrs ends ================================================


-- ========================= deposit_info_resp starts ==============================================
DBMS_OUTPUT.PUT_LINE(' deposit_info_resp start');
FOR r IN
      (SELECT ExtractValue(Value(p),'/deposit_info_resp/deposit_no/text()') AS  DEPOSITE_NO,
      Extract(Value(p),'/deposit_info_resp/deposit_currency/text()') As DEPOSITE_CURRENCY,
      Extract(Value(p),'/deposit_info_resp/due_date/text()') As DUE_DATE,
      Extract(Value(p),'/deposit_info_resp/deposit_type/text()') As DEPOSITE_TYPE,
      Extract(Value(p),'/deposit_info_resp/deposit_bal/text()').getnumberval() As DEPOSITE_BAL,
      Extract(Value(p),'/deposit_info_resp/start_date/text()') As START_DATE,
      Extract(Value(p),'/deposit_info_resp/exetr_srvc_task_id/text()').getnumberval() As EXETR_SRVC_TASK_ID,
      Extract(Value(p),'/deposit_info_resp/deposit_status/text()') As DEPOSITE_STATUS,
      Extract(Value(p),'/deposit_info_resp/jnt_acc/text()') As JNT_ACC
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/deposit_info_resp'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/deposit_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO DEPOSIT_INFO_RESP
   (

      DEPOSIT_NO,
      DEPOSIT_CURRENCY,
      DUE_DATE,
      DEPOSIT_TYPE,
      DEPOSIT_BAL,
      START_DATE,
      EXETR_SRVC_TASK_ID,
      DEPOSIT_STATUS,
      JNT_ACC      
   )
   VALUES
   (

      r.DEPOSITE_NO,
      r.DEPOSITE_CURRENCY,
      to_date(r.DUE_DATE,'YYYY-MM-DD HH24:MI:SS'),
      r.DEPOSITE_TYPE,
      r.DEPOSITE_BAL,
      to_date(r.START_DATE,'YYYY-MM-DD HH24:MI:SS'),
      r.EXETR_SRVC_TASK_ID,
      r.DEPOSITE_STATUS,
      r.JNT_ACC
   )RETURNING DEPOSIT_INFO_RESP_ID INTO  deposite_INFO_RESP_PK;



  end;
  END LOOP;
DBMS_OUTPUT.PUT_LINE(' deposit_info_resp ends');
-- ========================= deposit_info_resp ends ==============================================


-- ========================= deposit_info_resp_usr starts ==============================================
DBMS_OUTPUT.PUT_LINE('deposit_info_resp_usr starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/deposit_info_resp_usr/prd_type/text()') AS  PRD_TYPE,
      Extract(Value(p),'/deposit_info_resp_usr/prd_user_id/text()') As PRD_USER_ID,
      Extract(Value(p),'/deposit_info_resp_usr/prd_user_id_type/text()') As PRD_USER_ID_TYPE,
      Extract(Value(p),'/deposit_info_resp_usr/prd_user_type/text()') As PRD_USER_TYPE,
      Extract(Value(p),'/deposit_info_resp_usr/prd_user_name/text()') As PRD_USER_NAME
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/deposit_info_resp_usr'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/deposit_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO PRD_USR_LST
   (
      PRD_ID,
      PRD_TYPE,
      PRD_USER_ID,
      PRD_USER_ID_TYPE,
      PRD_USER_TYPE,
      PRD_USER_NAME
   )
   VALUES
   (
      deposite_INFO_RESP_PK,
      r.PRD_TYPE,
      r.PRD_USER_ID,
      r.PRD_USER_ID_TYPE,
      r.PRD_USER_TYPE,
      r.PRD_USER_NAME
   );


  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('deposit_info_resp_usr ends');
-- ========================= deposit_info_resp_usr ends ==============================================


-- ========================= safe_info_resp starts ==============================================
DBMS_OUTPUT.PUT_LINE('safe_info_resp starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/safe_info_resp/box_no/text()') AS  BOX_NO,
      Extract(Value(p),'/safe_info_resp/exetr_srvc_task_id/text()').getnumberval() As EXETR_SRVC_TASK_ID,
      Extract(Value(p),'/safe_info_resp/box_opn_date/text()') As BOX_OPN_DATE,
      Extract(Value(p),'/safe_info_resp/safe_branch/text()') As SAFE_BRANCH,
      Extract(Value(p),'/safe_info_resp/jnt_acc/text()') As JNT_ACC
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/safe_info_resp'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/safe_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO SAFE_INFO_RESP
   (

      BOX_NO,
      EXETR_SRVC_TASK_ID,
      BOX_OPN_DATE,
      SAFE_BRANCH,
      JNT_ACC 
   )
   VALUES
   (

      r.BOX_NO,
      r.EXETR_SRVC_TASK_ID,
      to_date(r.BOX_OPN_DATE,'YYYY-MM-DD HH24:MI:SS'),
      r.SAFE_BRANCH,
      r.JNT_ACC
   )RETURNING SAFE_INFO_RESP_ID INTO  safe_INFO_RESP_PK;



  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('safe_info_resp ends');
-- ========================= safe_info_resp ends ==============================================



-- ========================= safe_info_resp_usr starts ==============================================
DBMS_OUTPUT.PUT_LINE('safe_info_resp_usr starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/safe_info_resp_usr/prd_type/text()') AS  PRD_TYPE,
      Extract(Value(p),'/safe_info_resp_usr/prd_user_id/text()') As PRD_USER_ID,
      Extract(Value(p),'/safe_info_resp_usr/prd_user_id_type/text()') As PRD_USER_ID_TYPE,
      Extract(Value(p),'/safe_info_resp_usr/prd_user_type/text()') As PRD_USER_TYPE,
      Extract(Value(p),'/safe_info_resp_usr/prd_user_name/text()') As PRD_USER_NAME
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/safe_info_resp_usr'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/safe_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO PRD_USR_LST
   (
      PRD_ID,
      PRD_TYPE,
      PRD_USER_ID,
      PRD_USER_ID_TYPE,
      PRD_USER_TYPE,
      PRD_USER_NAME
   )
   VALUES
   (
      safe_INFO_RESP_PK,
      r.PRD_TYPE,
      r.PRD_USER_ID,
      r.PRD_USER_ID_TYPE,
      r.PRD_USER_TYPE,
      r.PRD_USER_NAME
   );

  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('safe_info_resp_usr ends');
-- ========================= safe_info_resp_usr ends ==============================================



-- ========================= liab_info_resp starts ==============================================
DBMS_OUTPUT.PUT_LINE('liab_info_resp starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/liab_info_resp/acc_no/text()') AS  ACC_NO,
      Extract(Value(p),'/liab_info_resp/exetr_srvc_task_id/text()').getnumberval() As EXETR_SRVC_TASK_ID,
      Extract(Value(p),'/liab_info_resp/iban/text()') As IBAN,
      Extract(Value(p),'/liab_info_resp/total_liab_amt/text()').getnumberval() As TOTAL_LIAB_AMT,
      Extract(Value(p),'/liab_info_resp/type_of_liab/text()') As TYPE_OF_LIAB,
      Extract(Value(p),'/liab_info_resp/remaining_liab_amt/text()').getnumberval() As REMAINING_LIAB_AMT,
      Extract(Value(p),'/liab_info_resp/no_of_instal/text()').getnumberval() As NO_OF_INSTAL,
      Extract(Value(p),'/liab_info_resp/last_payment_date/text()') As LAST_PAYMENT_DATE,
      Extract(Value(p),'/liab_info_resp/instal_amt/text()').getnumberval() As INSTAL_AMT,
      Extract(Value(p),'/liab_info_resp/liab_due_date/text()') As LIAB_DUE_DATE,
      Extract(Value(p),'/liab_info_resp/liab_currency/text()') As LIAB_CURRENCY,
      Extract(Value(p),'/liab_info_resp/instal_repeat/text()') As INSTAL_REPEAT,
      Extract(Value(p),'/liab_info_resp/instal_repeat_times/text()').getnumberval() As INSTAL_REPEAT_TIMES
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/liab_info_resp'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/liab_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO LIAB_INFO_RESP
   (

      EXETR_SRVC_TASK_ID,
      ACC_NO,
      IBAN,
      TOTAL_LIAB_AMT,
      TYPE_OF_LIAB,
      REMAINING_LIAB_AMT,
      NO_OF_INSTAL,
      LAST_PAYMENT_DATE,
      INSTAL_AMT,
      LIAB_DUE_DATE,
      LIAB_CURRENCY,
      INSTAL_REPEAT,
      INSTAL_REPEAT_TIMES
   )
   VALUES
   (

      r.EXETR_SRVC_TASK_ID,
      r.ACC_NO,
      r.IBAN,
      r.TOTAL_LIAB_AMT,
      r.TYPE_OF_LIAB,
      r.REMAINING_LIAB_AMT,
      r.NO_OF_INSTAL,
      to_date(r.LAST_PAYMENT_DATE,'YYYY-MM-DD HH24:MI:SS'),
      r.INSTAL_AMT,
      to_date(r.LIAB_DUE_DATE,'YYYY-MM-DD HH24:MI:SS'),
      r.LIAB_CURRENCY,
      r.INSTAL_REPEAT,
      r.INSTAL_REPEAT_TIMES
   )RETURNING LIAB_INFO_RESP_ID INTO  liab_INFO_RESP_PK;

  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('liab_info_resp ends');
-- ========================= liab_info_resp ends ==============================================



-- ========================= liab_info_resp_usr starts ==============================================
DBMS_OUTPUT.PUT_LINE('liab_info_resp_usr starts');
FOR r IN
      (SELECT ExtractValue(Value(p),'/liab_info_resp_usr/prd_type/text()') AS  PRD_TYPE,
      Extract(Value(p),'/liab_info_resp_usr/prd_user_id/text()') As PRD_USER_ID,
      Extract(Value(p),'/liab_info_resp_usr/prd_user_id_type/text()') As PRD_USER_ID_TYPE,
      Extract(Value(p),'/liab_info_resp_usr/prd_user_type/text()') As PRD_USER_TYPE,
      Extract(Value(p),'/liab_info_resp_usr/prd_user_name/text()') As PRD_USER_NAME
      FROM TABLE(XMLSequence(Extract(NEW_INPUT,'/detail/liab_info_resp_usr'))) p
      WHERE EXISTSNODE(NEW_INPUT,'/detail/liab_info_resp') = 1
      )

      LOOP
   begin
   INSERT INTO PRD_USR_LST
   (
      PRD_ID,
      PRD_TYPE,
      PRD_USER_ID,
      PRD_USER_ID_TYPE,
      PRD_USER_TYPE,
      PRD_USER_NAME
   )
   VALUES
   (
      liab_INFO_RESP_PK,
      r.PRD_TYPE,
      r.PRD_USER_ID,
      r.PRD_USER_ID_TYPE,
      r.PRD_USER_TYPE,
      r.PRD_USER_NAME
   );

  end;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('liab_info_resp_usr ends');
-- ========================= liab_info_resp_usr ends ==============================================


   --+--------------------+--------------+----------------+-----------+---------- 
  end;
  END LOOP;



DBMS_OUTPUT.PUT_LINE('INSERT_GI_RESP_SP ENDS');

END INSERT_GI_RESP_SP;