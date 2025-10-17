<select id="inquireTakeOutwCustRecvBeNotYetProcessPresentStateWbCrtDt" resultClass="HMap">
        <isEqual property="CLS_GUBUN" compareValue="10">
        <![CDATA[
        /***********************************************/
        /* 지시일자별 미출고일때 cls_cd = '1' start */
        /***********************************************/
        SELECT /* [출고/고객인수미처리현황][orderDetail.sqlx][OrderManagerService.inquireTakeOutwCustRecvBeNotYetProcessPresentState][2014.2.13][hyun_ah] */
               (DECODE(DELIV_CLS_CD, '20', 3, '30', 1, '40', 2, '35', 4)) AS NO, /* 직택배2추가 2009.09.03 gsYu */
               DELIV_CLS_CD AS DELIV_CD,
               TO_CHAR(SUM(D00QTY) + SUM(D01QTY) + SUM(D02QTY) + SUM(D03QTY) +
                       SUM(D04QTY) + SUM(D05QTY) + SUM(D06QTY) + SUM(D07QTY) +
                       SUM(D08QTY) + SUM(D09QTY) + SUM(D10QTY) + SUM(D11QTY) +
                       SUM(D12QTY) + SUM(D13QTY) + SUM(D15QTY) + SUM(D31QTY)) AS TOT_QTY,
               TO_CHAR(SUM(D00AMT) + SUM(D01AMT) + SUM(D02AMT) + SUM(D03AMT) +
                       SUM(D04AMT) + SUM(D05AMT) + SUM(D06AMT) + SUM(D07AMT) +
                       SUM(D08AMT) + SUM(D09AMT) + SUM(D10AMT) + SUM(D11AMT) +
                       SUM(D12AMT) + SUM(D13AMT) + SUM(D15AMT) + SUM(D31AMT)) AS TOT_AMT,
               TO_CHAR(SUM(D31QTY)) AS D31QTY,
               TO_CHAR(SUM(D31AMT)) AS D31AMT,
               TO_CHAR(SUM(D15QTY)) AS D15QTY,
               TO_CHAR(SUM(D15AMT)) AS D15AMT,
               TO_CHAR(SUM(D13QTY)) AS D13QTY,
               TO_CHAR(SUM(D13AMT)) AS D13AMT,
               TO_CHAR(SUM(D12QTY)) AS D12QTY,
               TO_CHAR(SUM(D12AMT)) AS D12AMT,
               TO_CHAR(SUM(D11QTY)) AS D11QTY,
               TO_CHAR(SUM(D11AMT)) AS D11AMT,
               TO_CHAR(SUM(D10QTY)) AS D10QTY,
               TO_CHAR(SUM(D10AMT)) AS D10AMT,
               TO_CHAR(SUM(D09QTY)) AS D09QTY,
               TO_CHAR(SUM(D09AMT)) AS D09AMT,
               TO_CHAR(SUM(D08QTY)) AS D08QTY,
               TO_CHAR(SUM(D08AMT)) AS D08AMT,
               TO_CHAR(SUM(D07QTY)) AS D07QTY,
               TO_CHAR(SUM(D07AMT)) AS D07AMT,
               TO_CHAR(SUM(D06QTY)) AS D06QTY,
               TO_CHAR(SUM(D06AMT)) AS D06AMT,
               TO_CHAR(SUM(D05QTY)) AS D05QTY,
               TO_CHAR(SUM(D05AMT)) AS D05AMT,
               TO_CHAR(SUM(D04QTY)) AS D04QTY,
               TO_CHAR(SUM(D04AMT)) AS D04AMT,
               TO_CHAR(SUM(D03QTY)) AS D03QTY,
               TO_CHAR(SUM(D03AMT)) AS D03AMT,
               TO_CHAR(SUM(D02QTY)) AS D02QTY,
               TO_CHAR(SUM(D02AMT)) AS D02AMT,
               TO_CHAR(SUM(D01QTY)) AS D01QTY,
               TO_CHAR(SUM(D01AMT)) AS D01AMT,
               TO_CHAR(SUM(D00QTY)) AS D00QTY,
               TO_CHAR(SUM(D15AMT)) AS D00AMT
          FROM (
                /* 메인 집계테이블기준(sysdate-1) */
                SELECT  DELIV_CLS_CD,
                        0 AS TOT_QTY,
                        0 AS TOT_AMT,
                        (CASE WHEN STD_DT <= TRUNC(SYSDATE - 31) THEN OUTW_QTY ELSE 0 END) D31QTY,
                        (CASE WHEN STD_DT <= TRUNC(SYSDATE - 31) THEN OUTW_AMT ELSE 0 END) D31AMT,
                        (CASE WHEN (STD_DT <= TRUNC(SYSDATE - 14) AND STD_DT >= TRUNC(SYSDATE - 30)) THEN OUTW_QTY ELSE 0 END) D15QTY,                       
                        (CASE WHEN (STD_DT <= TRUNC(SYSDATE - 14) AND STD_DT >= TRUNC(SYSDATE - 30)) THEN OUTW_AMT ELSE 0 END) D15AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 13) THEN OUTW_QTY ELSE 0 END) D13QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 13) THEN OUTW_AMT ELSE 0 END) D13AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 12) THEN OUTW_QTY ELSE 0 END) D12QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 12) THEN OUTW_AMT ELSE 0 END) D12AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 11) THEN OUTW_QTY ELSE 0 END) D11QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 11) THEN OUTW_AMT ELSE 0 END) D11AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 10) THEN OUTW_QTY ELSE 0 END) D10QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 10) THEN OUTW_AMT ELSE 0 END) D10AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 09) THEN OUTW_QTY ELSE 0 END) D09QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 09) THEN OUTW_AMT ELSE 0 END) D09AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 08) THEN OUTW_QTY ELSE 0 END) D08QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 08) THEN OUTW_AMT ELSE 0 END) D08AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 07) THEN OUTW_QTY ELSE 0 END) D07QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 07) THEN OUTW_AMT ELSE 0 END) D07AMT,                      
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 06) THEN OUTW_QTY ELSE 0 END) D06QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 06) THEN OUTW_AMT ELSE 0 END) D06AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 05) THEN OUTW_QTY ELSE 0 END) D05QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 05) THEN OUTW_AMT ELSE 0 END) D05AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 04) THEN OUTW_QTY ELSE 0 END) D04QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 04) THEN OUTW_AMT ELSE 0 END) D04AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 03) THEN OUTW_QTY ELSE 0 END) D03QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 03) THEN OUTW_AMT ELSE 0 END) D03AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 02) THEN OUTW_QTY ELSE 0 END) D02QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 02) THEN OUTW_AMT ELSE 0 END) D02AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 01) THEN OUTW_QTY ELSE 0 END) D01QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 01) THEN OUTW_AMT ELSE 0 END) D01AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 00) THEN OUTW_QTY ELSE 0 END) D00QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 00) THEN OUTW_AMT ELSE 0 END) D00AMT
                  FROM TNOTCLOSESUM
                 WHERE INS_DTM =
                       (SELECT MAX(INS_DTM)
                          FROM TNOTCLOSESUM
                         WHERE VEN_CD IN
                               (SELECT VEN_CD
                                  FROM TABLE(FGET_VANTRANSFER('1', #svenCd#))))
                   AND VEN_CD IN
                       (SELECT VEN_CD
                          FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                   AND WB_FLG_CD = '1'          /* 운송장구분 (1:출고,2:회수)        */
                   AND CLS_CD = '1'             /* 구분코드 (1:미출고,2:미배송)   */
                   AND CLS_DTL_CD = '1'         /* 상세구분(1:지시일,2:예정일)    */
                   AND DELIV_CLS_CD <> '10'       /* 센터배송은 제외                 */
                   AND STD_DT < TO_DATE('20991231', 'yyyymmdd')
 
                UNION ALL
 
                /* (+)오늘전체지시(출하지시/확정/배송완료)*/
                SELECT /*+ ordered use_nl(m d) index(m itwbill10) */
                        DECODE(M.DELIV_METH_CD, '40', '20', M.DELIV_CLS_CD) AS DELIV_CD,
                        0 AS TOT_QTY,
                        0 AS TOT_AMT,
                        0 AS D31QTY,
                        0 AS D31AMT,
                        0 AS D15QTY,
                        0 AS D15AMT,
                        0 AS D13QTY,
                        0 AS D13AMT,
                        0 AS D12QTY,
                        0 AS D12AMT,
                        0 AS D11QTY,
                        0 AS D11AMT,
                        0 AS D10QTY,
                        0 AS D10AMT,
                        0 AS D09QTY,
                        0 AS D09AMT,
                        0 AS D08QTY,
                        0 AS D08AMT,
                        0 AS D07QTY,
                        0 AS D07AMT,
                        0 AS D06QTY,
                        0 AS D06AMT,
                        0 AS D05QTY,
                        0 AS D05AMT,
                        0 AS D04QTY,
                        0 AS D04AMT,
                        0 AS D03QTY,
                        0 AS D03AMT,
                        0 AS D02QTY,
                        0 AS D02AMT,
                        0 AS D01QTY,
                        0 AS D01AMT,
                        SUM(OUTW_QTY) AS D00QTY,
                        SUM(OUTW_AMT) AS D00AMT
                  FROM  TWBILL      M,
                        TWBILLDTL   D
                 WHERE  M.VEN_CD    IN
                        (SELECT     VEN_CD
                           FROM     TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                   AND  M.WB_CRT_DT = TRUNC(SYSDATE)
                   AND  M.WB_FLG_CD = '1'
                   AND  M.WB_PROG_CD < '40'
                   AND  M.WB_CLS_CD IN ('101', '102', '103', '104')
                   AND  M.WB_ID_NO = D.WB_ID_NO
                   AND  (M.DELIV_METH_CD = '40' OR
                        M.DELIV_CLS_CD IN ('20', '30', '40', '35')) /* 직택배2추가 2009.09.03 gsYu */
                 GROUP BY DECODE(M.DELIV_METH_CD, '40', '20', M.DELIV_CLS_CD)
 
                UNION ALL
 
                /* (-)과거지시 중 금일출고 또는 배송완료건 */
                SELECT  /*+ ordered use_nl(m d) index(m itwbill01) */
                        DECODE(M.DELIV_METH_CD, '40', '20', M.DELIV_CLS_CD) AS DELIV_CD,
                        0 AS TOT_QTY,
                        0 AS TOT_AMT,
                        (CASE WHEN M.WB_CRT_DT <= TRUNC(SYSDATE - 31) THEN D.OUTW_QTY * (-1) ELSE 0 END) D31QTY,
                        (CASE WHEN M.WB_CRT_DT <= TRUNC(SYSDATE - 31) THEN D.OUTW_AMT * (-1) ELSE 0 END) D31AMT,
                        (CASE WHEN (M.WB_CRT_DT <= TRUNC(SYSDATE - 14) AND                        M.WB_CRT_DT >= TRUNC(SYSDATE - 30)) THEN D.OUTW_QTY * (-1) ELSE 0 END) D15QTY,
                        (CASE WHEN (M.WB_CRT_DT <= TRUNC(SYSDATE - 14) AND                        M.WB_CRT_DT >= TRUNC(SYSDATE - 30)) THEN D.OUTW_AMT * (-1) ELSE 0 END) D15AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 13) THEN D.OUTW_QTY * (-1) ELSE 0 END) D13QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 13) THEN D.OUTW_AMT * (-1) ELSE 0 END) D13AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 12) THEN D.OUTW_QTY * (-1)             ELSE                     0               END) D12QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 12) THEN D.OUTW_AMT * (-1) ELSE 0 END) D12AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 11) THEN D.OUTW_QTY * (-1) ELSE 0 END) D11QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 11) THEN D.OUTW_AMT * (-1) ELSE 0 END) D11AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 10) THEN D.OUTW_QTY * (-1) ELSE 0 END) D10QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 10) THEN D.OUTW_AMT * (-1) ELSE 0 END) D10AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 09) THEN D.OUTW_QTY * (-1) ELSE 0 END) D09QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 09) THEN D.OUTW_AMT * (-1) ELSE 0 END) D09AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 08) THEN D.OUTW_QTY * (-1) ELSE 0 END) D08QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 08) THEN D.OUTW_AMT * (-1) ELSE 0 END) D08AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 07) THEN D.OUTW_QTY * (-1) ELSE 0 END) D07QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 07) THEN D.OUTW_AMT * (-1) ELSE 0 END) D07AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 06) THEN D.OUTW_QTY * (-1) ELSE 0 END) D06QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 06) THEN D.OUTW_AMT * (-1) ELSE 0 END) D06AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 05) THEN D.OUTW_QTY * (-1) ELSE 0 END) D05QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 05) THEN D.OUTW_AMT * (-1) ELSE 0 END) D05AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 04) THEN D.OUTW_QTY * (-1) ELSE 0 END) D04QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 04) THEN D.OUTW_AMT * (-1) ELSE 0 END) D04AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 03) THEN D.OUTW_QTY * (-1) ELSE 0 END) D03QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 03) THEN D.OUTW_AMT * (-1) ELSE 0 END) D03AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 02) THEN D.OUTW_QTY * (-1) ELSE 0 END) D02QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 02) THEN D.OUTW_AMT * (-1) ELSE 0 END) D02AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 01) THEN D.OUTW_QTY * (-1) ELSE 0 END) D01QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 01) THEN D.OUTW_AMT * (-1) ELSE 0 END) D01AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 00) THEN D.OUTW_QTY * (-1) ELSE 0 END) D00QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 00) THEN D.OUTW_AMT * (-1) ELSE 0 END) D00AMT
                  FROM  ADM.TWBILL  M,
                        TWBILLDTL   D
                 WHERE  M.VEN_CD    IN
                        (SELECT     VEN_CD
                           FROM     TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                   AND  M.OUTW_CONF_DT = TRUNC(SYSDATE)
                /* and  m.wb_prog_cd  = '40'(배송완료건도 있기 때문에 prog_cd생략) */
                   AND  M.WB_CRT_DT < TRUNC(SYSDATE)
                   AND  M.WB_FLG_CD = '1'
                   AND  M.WB_CLS_CD IN ('101', '102', '103', '104')
                   AND  M.WB_ID_NO = D.WB_ID_NO
                   AND  (M.DELIV_METH_CD = '40' OR
                        M.DELIV_CLS_CD IN ('20', '30', '40', '35')) /* 직택배2추가 2009.09.03 gsYu */
                
                UNION ALL
 
                /* (-)과거지시 중 오늘취소 */
                SELECT  /*+ ordered use_nl(m d) index(m itwbill_log1) */
                        DECODE(M.DELIV_METH_CD, '40', '20', M.DELIV_CLS_CD) AS DELIV_CD,
                        0 AS TOT_QTY,
                        0 AS TOT_AMT,
                        (CASE WHEN M.WB_CRT_DT <= TRUNC(SYSDATE - 31) THEN D.OUTW_QTY * (-1) ELSE 0 END) D31QTY,
                        (CASE WHEN M.WB_CRT_DT <= TRUNC(SYSDATE - 31) THEN D.OUTW_AMT * (-1) ELSE 0 END) D31AMT,
                        (CASE WHEN (M.WB_CRT_DT <= TRUNC(SYSDATE - 14) AND M.WB_CRT_DT >= TRUNC(SYSDATE - 30)) THEN D.OUTW_QTY * (-1) ELSE 0 END) D15QTY,
                        (CASE WHEN (M.WB_CRT_DT <= TRUNC(SYSDATE - 14) AND M.WB_CRT_DT >= TRUNC(SYSDATE - 30)) THEN D.OUTW_AMT * (-1) ELSE 0 END) D15AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 13) THEN D.OUTW_QTY * (-1) ELSE 0 END) D13QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 13) THEN D.OUTW_AMT * (-1) ELSE 0 END) D13AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 12) THEN D.OUTW_QTY * (-1) ELSE 0 END) D12QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 12) THEN D.OUTW_AMT * (-1) ELSE 0 END) D12AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 11) THEN D.OUTW_QTY * (-1) ELSE 0 END) D11QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 11) THEN D.OUTW_AMT * (-1) ELSE 0 END) D11AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 10) THEN D.OUTW_QTY * (-1) ELSE 0 END) D10QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 10) THEN D.OUTW_AMT * (-1) ELSE 0 END) D10AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 09) THEN D.OUTW_QTY * (-1) ELSE 0 END) D09QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 09) THEN D.OUTW_AMT * (-1) ELSE 0 END) D09AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 08) THEN D.OUTW_QTY * (-1) ELSE 0 END) D08QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 08) THEN D.OUTW_AMT * (-1) ELSE 0 END) D08AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 07) THEN D.OUTW_QTY * (-1) ELSE 0 END) D07QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 07) THEN D.OUTW_AMT * (-1) ELSE 0 END) D07AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 06) THEN D.OUTW_QTY * (-1) ELSE 0 END) D06QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 06) THEN D.OUTW_AMT * (-1) ELSE 0 END) D06AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 05) THEN D.OUTW_QTY * (-1) ELSE 0 END) D05QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 05) THEN D.OUTW_AMT * (-1) ELSE 0 END) D05AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 04) THEN D.OUTW_QTY * (-1) ELSE 0 END) D04QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 04) THEN D.OUTW_AMT * (-1) ELSE 0 END) D04AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 03) THEN D.OUTW_QTY * (-1) ELSE 0 END) D03QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 03) THEN D.OUTW_AMT * (-1) ELSE 0 END) D03AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 02) THEN D.OUTW_QTY * (-1) ELSE 0 END) D02QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 02) THEN D.OUTW_AMT * (-1) ELSE 0 END) D02AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 01) THEN D.OUTW_QTY * (-1) ELSE 0 END) D01QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 01) THEN D.OUTW_AMT * (-1) ELSE 0 END) D01AMT,
                        0 AS D00QTY,    /* 이미 오늘 취소는 오늘지시에서 빠져있음 */
                        0 AS D00AMT /* 이미 오늘 취소는 오늘지시에서 빠져있음 */
                  FROM  ADM.TWBILL_LOG M,
                        TWBILLDTL_LOG  D
                 WHERE  M.VEN_CD IN
                        (SELECT VEN_CD
                          FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                   AND  M.CNCL_INS_DTM >= TRUNC(SYSDATE)
                   AND  M.WB_CRT_DT < TRUNC(SYSDATE)
                   AND  M.WB_FLG_CD = '1'
                   AND  M.WB_CLS_CD IN ('101', '102', '103', '104')
                   AND  M.WB_ID_NO = D.WB_ID_NO
                   AND  M.CNCL_RSN_CD <> '99'
                   AND  (M.DELIV_METH_CD = '40' OR
                        M.DELIV_CLS_CD IN ('20', '30', '40', '35')) /* 직택배2추가 2009.09.03 gsYu */
                 
                UNION ALL
 
                SELECT '20' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL
                 
                UNION ALL
                 
                SELECT '30' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL
                
                UNION ALL
                 
                SELECT '40' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL
                 
                UNION ALL /* 직택배2추가 2009.09.03 gsYu */
                 
                SELECT '35' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL)
 
         GROUP BY DELIV_CLS_CD
         ORDER BY NO
        ]]>
        </isEqual>
 
        <isEqual property="CLS_GUBUN" compareValue="20">
        <![CDATA[
        /***********************************************/
        /* 지시일자별 미배송일때 cls_cd = '2' start */
        /***********************************************/
        SELECT (DECODE(DELIV_CLS_CD, '20', 3, '30', 1, '40', 2, '35', 4)) AS NO, /* 직택배2추가 2009.09.03 gsYu */
               DELIV_CLS_CD AS DELIV_CD,
               TO_CHAR(SUM(D00QTY) + SUM(D01QTY) + SUM(D02QTY) + SUM(D03QTY) +
                       SUM(D04QTY) + SUM(D05QTY) + SUM(D06QTY) + SUM(D07QTY) +
                       SUM(D08QTY) + SUM(D09QTY) + SUM(D10QTY) + SUM(D11QTY) +
                       SUM(D12QTY) + SUM(D13QTY) + SUM(D15QTY) + SUM(D31QTY)) AS TOT_QTY,
               TO_CHAR(SUM(D00AMT) + SUM(D01AMT) + SUM(D02AMT) + SUM(D03AMT) +
                       SUM(D04AMT) + SUM(D05AMT) + SUM(D06AMT) + SUM(D07AMT) +
                       SUM(D08AMT) + SUM(D09AMT) + SUM(D10AMT) + SUM(D11AMT) +
                       SUM(D12AMT) + SUM(D13AMT) + SUM(D15AMT) + SUM(D31AMT)) AS TOT_AMT,
               TO_CHAR(SUM(D31QTY)) AS D31QTY,
               TO_CHAR(SUM(D31AMT)) AS D31AMT,
               TO_CHAR(SUM(D15QTY)) AS D15QTY,
               TO_CHAR(SUM(D15AMT)) AS D15AMT,
               TO_CHAR(SUM(D13QTY)) AS D13QTY,
               TO_CHAR(SUM(D13AMT)) AS D13AMT,
               TO_CHAR(SUM(D12QTY)) AS D12QTY,
               TO_CHAR(SUM(D12AMT)) AS D12AMT,
               TO_CHAR(SUM(D11QTY)) AS D11QTY,
               TO_CHAR(SUM(D11AMT)) AS D11AMT,
               TO_CHAR(SUM(D10QTY)) AS D10QTY,
               TO_CHAR(SUM(D10AMT)) AS D10AMT,
               TO_CHAR(SUM(D09QTY)) AS D09QTY,
               TO_CHAR(SUM(D09AMT)) AS D09AMT,
               TO_CHAR(SUM(D08QTY)) AS D08QTY,
               TO_CHAR(SUM(D08AMT)) AS D08AMT,
               TO_CHAR(SUM(D07QTY)) AS D07QTY,
               TO_CHAR(SUM(D07AMT)) AS D07AMT,
               TO_CHAR(SUM(D06QTY)) AS D06QTY,
               TO_CHAR(SUM(D06AMT)) AS D06AMT,
               TO_CHAR(SUM(D05QTY)) AS D05QTY,
               TO_CHAR(SUM(D05AMT)) AS D05AMT,
               TO_CHAR(SUM(D04QTY)) AS D04QTY,
               TO_CHAR(SUM(D04AMT)) AS D04AMT,
               TO_CHAR(SUM(D03QTY)) AS D03QTY,
               TO_CHAR(SUM(D03AMT)) AS D03AMT,
               TO_CHAR(SUM(D02QTY)) AS D02QTY,
               TO_CHAR(SUM(D02AMT)) AS D02AMT,
               TO_CHAR(SUM(D01QTY)) AS D01QTY,
               TO_CHAR(SUM(D01AMT)) AS D01AMT,
               TO_CHAR(SUM(D00QTY)) AS D00QTY,
               TO_CHAR(SUM(D00AMT)) AS D00AMT
          FROM (
                /*메인 집계테이블기준(sysdate-1) */
                SELECT DELIV_CLS_CD,
                        0 AS TOT_QTY,
                        0 AS TOT_AMT,
                        (CASE WHEN STD_DT <= TRUNC(SYSDATE - 31) THEN OUTW_QTY ELSE 0 END) D31QTY,
                        (CASE WHEN STD_DT <= TRUNC(SYSDATE - 31) THEN OUTW_AMT ELSE 0 END) D31AMT,
                        (CASE WHEN (STD_DT <= TRUNC(SYSDATE - 14) AND STD_DT >= TRUNC(SYSDATE - 30)) THEN OUTW_QTY ELSE 0 END) D15QTY,
                        (CASE WHEN (STD_DT <= TRUNC(SYSDATE - 14) AND STD_DT >= TRUNC(SYSDATE - 30)) THEN OUTW_AMT ELSE 0 END) D15AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 13) THEN OUTW_QTY ELSE 0 END) D13QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 13) THEN OUTW_AMT ELSE 0 END) D13AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 12) THEN OUTW_QTY ELSE 0 END) D12QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 12) THEN OUTW_AMT ELSE 0 END) D12AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 11) THEN OUTW_QTY ELSE 0 END) D11QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 11) THEN OUTW_AMT ELSE 0 END) D11AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 10) THEN OUTW_QTY ELSE 0 END) D10QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 10) THEN OUTW_AMT ELSE 0 END) D10AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 09) THEN OUTW_QTY ELSE 0 END) D09QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 09) THEN OUTW_AMT ELSE 0 END) D09AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 08) THEN OUTW_QTY ELSE 0 END) D08QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 08) THEN OUTW_AMT ELSE 0 END) D08AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 07) THEN OUTW_QTY ELSE 0 END) D07QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 07) THEN OUTW_AMT ELSE 0 END) D07AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 06) THEN OUTW_QTY ELSE 0 END) D06QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 06) THEN OUTW_AMT ELSE 0 END) D06AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 05) THEN OUTW_QTY ELSE 0 END) D05QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 05) THEN OUTW_AMT ELSE 0 END) D05AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 04) THEN OUTW_QTY ELSE 0 END) D04QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 04) THEN OUTW_AMT ELSE 0 END) D04AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 03) THEN OUTW_QTY ELSE 0 END) D03QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 03) THEN OUTW_AMT ELSE 0 END) D03AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 02) THEN OUTW_QTY ELSE 0 END) D02QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 02) THEN OUTW_AMT ELSE 0 END) D02AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 01) THEN OUTW_QTY ELSE 0 END) D01QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 01) THEN OUTW_AMT ELSE 0 END) D01AMT,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 00) THEN OUTW_QTY ELSE 0 END) D00QTY,
                        (CASE WHEN STD_DT = TRUNC(SYSDATE - 00) THEN OUTW_AMT ELSE 0 END) D00AMT
                  FROM TNOTCLOSESUM
                 WHERE INS_DTM =
                       (SELECT MAX(INS_DTM)
                          FROM TNOTCLOSESUM
                         WHERE VEN_CD IN
                               (SELECT VEN_CD
                                  FROM TABLE(FGET_VANTRANSFER('1', #svenCd#))))
                   AND VEN_CD IN
                       (SELECT VEN_CD
                          FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                   AND WB_FLG_CD = '1'          /* 운송장구분(1:출고,2:회수)     */
                   AND CLS_CD = '2'             /* 구분코드(1:미출고,2:미배송)    */
                   AND CLS_DTL_CD = '1'         /* 상세구분(1:지시일,2:예정일)    */
                   AND DELIV_CLS_CD <> '10'   /* 센터배송은 제외                 */
                   AND STD_DT < TO_DATE('20991231', 'yyyymmdd')
                UNION ALL
                /* (+)오늘출하지시 && (출고확정) */
                SELECT  /*+ ordered use_nl(m d) index(m itwbill10) */
                        DECODE(M.DELIV_METH_CD, '40', '20', M.DELIV_CLS_CD) AS DELIV_CD,
                        0 AS TOT_QTY,
                        0 AS TOT_AMT,
                        0 AS D31QTY,
                        0 AS D31AMT,
                        0 AS D15QTY,
                        0 AS D15AMT,
                        0 AS D13QTY,
                        0 AS D13AMT,
                        0 AS D12QTY,
                        0 AS D12AMT,
                        0 AS D11QTY,
                        0 AS D11AMT,
                        0 AS D10QTY,
                        0 AS D10AMT,
                        0 AS D09QTY,
                        0 AS D09AMT,
                        0 AS D08QTY,
                        0 AS D08AMT,
                        0 AS D07QTY,
                        0 AS D07AMT,
                        0 AS D06QTY,
                        0 AS D06AMT,
                        0 AS D05QTY,
                        0 AS D05AMT,
                        0 AS D04QTY,
                        0 AS D04AMT,
                        0 AS D03QTY,
                        0 AS D03AMT,
                        0 AS D02QTY,
                        0 AS D02AMT,
                        0 AS D01QTY,
                        0 AS D01AMT,
                        SUM(OUTW_QTY) AS D00QTY,
                        SUM(OUTW_AMT) AS D00AMT
                  FROM  TWBILL    M,
                        TWBILLDTL D
                 WHERE  M.VEN_CD IN
                        (SELECT VEN_CD
                           FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                   AND  M.WB_CRT_DT = TRUNC(SYSDATE)
                   AND  M.WB_FLG_CD = '1'
                   AND  M.WB_PROG_CD = '40'
                   AND  M.WB_CLS_CD IN ('101', '102', '103', '104')
                   AND  M.WB_ID_NO = D.WB_ID_NO
                   AND  (M.DELIV_METH_CD = '40' OR
                        M.DELIV_CLS_CD IN ('20', '30', '40', '35')) /* 직택배2추가 2009.09.03 gsYu */
                 GROUP BY DECODE(M.DELIV_METH_CD, '40', '20', M.DELIV_CLS_CD)
                 
                UNION ALL
 
                /* (-)과거지시 중 금일배송완료건 */
                SELECT  /*+ ordered use_nl(m d) index(m itwbill01) */
                        DECODE(M.DELIV_METH_CD, '40', '20', M.DELIV_CLS_CD) AS DELIV_CD,
                        0 AS TOT_QTY,
                        0 AS TOT_AMT,
                        (CASE WHEN M.WB_CRT_DT <= TRUNC(SYSDATE - 31) THEN D.OUTW_QTY * (-1) ELSE 0 END) D31QTY,
                        (CASE WHEN M.WB_CRT_DT <= TRUNC(SYSDATE - 31) THEN D.OUTW_AMT * (-1) ELSE 0 END) D31AMT,
                        (CASE WHEN (M.WB_CRT_DT <= TRUNC(SYSDATE - 14) AND M.WB_CRT_DT >= TRUNC(SYSDATE - 30)) THEN D.OUTW_QTY * (-1) ELSE 0 END) D15QTY,
                        (CASE WHEN (M.WB_CRT_DT <= TRUNC(SYSDATE - 14) AND M.WB_CRT_DT >= TRUNC(SYSDATE - 30)) THEN D.OUTW_AMT * (-1) ELSE 0 END) D15AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 13) THEN D.OUTW_QTY * (-1) ELSE 0 END) D13QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 13) THEN D.OUTW_AMT * (-1) ELSE 0 END) D13AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 12) THEN D.OUTW_QTY * (-1) ELSE 0 END) D12QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 12) THEN D.OUTW_AMT * (-1) ELSE 0 END) D12AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 11) THEN D.OUTW_QTY * (-1) ELSE 0 END) D11QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 11) THEN D.OUTW_AMT * (-1) ELSE 0 END) D11AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 10) THEN D.OUTW_QTY * (-1) ELSE 0 END) D10QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 10) THEN D.OUTW_AMT * (-1) ELSE 0 END) D10AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 09) THEN D.OUTW_QTY * (-1) ELSE 0 END) D09QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 09) THEN D.OUTW_AMT * (-1) ELSE 0 END) D09AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 08) THEN D.OUTW_QTY * (-1) ELSE 0 END) D08QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 08) THEN D.OUTW_AMT * (-1) ELSE 0 END) D08AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 07) THEN D.OUTW_QTY * (-1) ELSE 0 END) D07QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 07) THEN D.OUTW_AMT * (-1) ELSE 0 END) D07AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 06) THEN D.OUTW_QTY * (-1) ELSE 0 END) D06QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 06) THEN D.OUTW_AMT * (-1) ELSE 0 END) D06AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 05) THEN D.OUTW_QTY * (-1) ELSE 0 END) D05QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 05) THEN D.OUTW_AMT * (-1) ELSE 0 END) D05AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 04) THEN D.OUTW_QTY * (-1) ELSE 0 END) D04QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 04) THEN D.OUTW_AMT * (-1) ELSE 0 END) D04AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 03) THEN D.OUTW_QTY * (-1) ELSE 0 END) D03QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 03) THEN D.OUTW_AMT * (-1) ELSE 0 END) D03AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 02) THEN D.OUTW_QTY * (-1) ELSE 0 END) D02QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 02) THEN D.OUTW_AMT * (-1) ELSE 0 END) D02AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 01) THEN D.OUTW_QTY * (-1) ELSE 0 END) D01QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 01) THEN D.OUTW_AMT * (-1) ELSE 0 END) D01AMT,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 00) THEN D.OUTW_QTY * (-1) ELSE 0 END) D00QTY,
                        (CASE WHEN M.WB_CRT_DT = TRUNC(SYSDATE - 00) THEN D.OUTW_AMT * (-1) ELSE 0 END) D00AMT
                  FROM  ADM.TWBILL M,
                        TWBILLDTL  D
                 WHERE  M.VEN_CD IN
                        (SELECT VEN_CD
                           FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                   AND  M.DELIV_DTM >= TRUNC(SYSDATE)
                   AND  M.WB_CRT_DT < TRUNC(SYSDATE)
                   AND  M.WB_FLG_CD = '1'
                   AND  M.WB_CLS_CD IN ('101', '102', '103', '104')
                   AND  M.WB_ID_NO = D.WB_ID_NO
                   AND  (M.DELIV_METH_CD = '40' OR
                        M.DELIV_CLS_CD IN ('20', '30', '40', '35')) /* 직택배2추가 2009.09.03 gsYu */
 
                UNION ALL
 
                SELECT '20' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL
 
                UNION ALL
 
                SELECT '30' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL
 
                UNION ALL
 
                SELECT '40' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL
 
                UNION ALL /* 직택배2추가 2009.09.03 gsYu */
 
                SELECT '35' AS DELIV_CD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  FROM DUAL)
         GROUP BY DELIV_CLS_CD
         ORDER BY NO
        ]]>
        </isEqual>
         
         
        <isEqual property="CLS_GUBUN" compareValue="1">
            <isEqual property="DELV_GUBUN" compareValue="1">
                <![CDATA[
                /***********************************************/
                /* 지시일자별 일반상품 미배송일때 1-8-1 start */
                /***********************************************/
                SELECT /* [출고/고객인수미처리현황][orderDetail.sqlx][OrderManagerService.inquireTakeOutwCustRecvBeNotYetProcessPresentState][2014.2.13][hyun_ah] */
                         (DECODE(DELIV_CD, '20', 3, '30', 1, '40', 2, '35', 4)) AS NO, /* 직택배2추가 2009.09.03 gsYu */
                           DELIV_CD AS DELIV_CD,
                           TO_CHAR(SUM(M00QTY) + SUM(M01QTY) + SUM(M02QTY) + SUM(M03QTY) +
                                   SUM(M04QTY) + SUM(M05QTY) + SUM(M06QTY) + SUM(M07QTY) +
                                   SUM(M08QTY) + SUM(M09QTY) + SUM(M10QTY) + SUM(M11QTY) +
                                   SUM(M12QTY) + SUM(M13QTY) + SUM(M14QTY) + SUM(M15QTY) +
                                   SUM(M16QTY) + SUM(M17QTY) + SUM(M18QTY) + SUM(M19QTY) +
                                   SUM(M20QTY) + SUM(M21QTY) + SUM(M22QTY) + SUM(M23QTY) + SUM(M24QTY)) AS TOT_QTY,
                           TO_CHAR(SUM(M00AMT) + SUM(M01AMT) + SUM(M02AMT) + SUM(M03AMT) +
                                   SUM(M04AMT) + SUM(M05AMT) + SUM(M06AMT) + SUM(M07AMT) +
                                   SUM(M08AMT) + SUM(M09AMT) + SUM(M10AMT) + SUM(M11AMT) +
                                   SUM(M12AMT) + SUM(M13AMT) + SUM(M14AMT) + SUM(M15AMT) +
                                   SUM(M16AMT) + SUM(M17AMT) + SUM(M18AMT) + SUM(M19AMT) +
                                   SUM(M20AMT) + SUM(M21AMT) + SUM(M22AMT) + SUM(M23AMT) + SUM(M24AMT)) AS TOT_AMT,
                          SUM(M01AMT) AS M01AMT,
                          SUM(M02AMT) AS M02AMT,
                          SUM(M03AMT) AS M03AMT,
                          SUM(M04AMT) AS M04AMT,
                          SUM(M05AMT) AS M05AMT,
                          SUM(M06AMT) AS M06AMT,
                          SUM(M07AMT) AS M07AMT,
                          SUM(M08AMT) AS M08AMT,
                          SUM(M09AMT) AS M09AMT,
                          SUM(M10AMT) AS M10AMT,
                          SUM(M11AMT) AS M11AMT,
                          SUM(M12AMT) AS M12AMT,
                          SUM(M13AMT) AS M13AMT,
                          SUM(M14AMT) AS M14AMT,
                          SUM(M15AMT) AS M15AMT,
                          SUM(M16AMT) AS M16AMT,
                          SUM(M17AMT) AS M17AMT,
                          SUM(M18AMT) AS M18AMT,
                          SUM(M19AMT) AS M19AMT,
                          SUM(M20AMT) AS M20AMT,
                          SUM(M21AMT) AS M21AMT,
                          SUM(M22AMT) AS M22AMT,
                          SUM(M23AMT) AS M23AMT,
                          SUM(M24AMT) AS M24AMT,
                          SUM(M00AMT) AS M00AMT,
                          SUM(M01QTY) AS M01QTY,
                          SUM(M02QTY) AS M02QTY,
                          SUM(M03QTY) AS M03QTY,
                          SUM(M04QTY) AS M04QTY,
                          SUM(M05QTY) AS M05QTY,
                          SUM(M06QTY) AS M06QTY,
                          SUM(M07QTY) AS M07QTY,
                          SUM(M08QTY) AS M08QTY,
                          SUM(M09QTY) AS M09QTY,
                          SUM(M10QTY) AS M10QTY,
                          SUM(M11QTY) AS M11QTY,
                          SUM(M12QTY) AS M12QTY,
                          SUM(M13QTY) AS M13QTY,
                          SUM(M14QTY) AS M14QTY,
                          SUM(M15QTY) AS M15QTY,
                          SUM(M16QTY) AS M16QTY,
                          SUM(M17QTY) AS M17QTY,
                          SUM(M18QTY) AS M18QTY,
                          SUM(M19QTY) AS M19QTY,
                          SUM(M20QTY) AS M20QTY,
                          SUM(M21QTY) AS M21QTY,
                          SUM(M22QTY) AS M22QTY,
                          SUM(M23QTY) AS M23QTY,
                          SUM(M24QTY) AS M24QTY,
                          SUM(M00QTY) AS M00QTY                      
                          FROM (
                                   select DELIV_CLS_CD as DELIV_CD, 
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_qty) else 0 end as M00QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_qty) else 0 end as M24QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_qty) else 0 end as M23QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_qty) else 0 end as M22QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_qty) else 0 end as M21QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_qty) else 0 end as M20QTY,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_qty) else 0 end as M19QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_qty) else 0 end as M18QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_qty) else 0 end as M17QTY,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_qty) else 0 end as M16QTY,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_qty) else 0 end as M15QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_qty) else 0 end as M14QTY,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_qty) else 0 end as M13QTY,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_qty) else 0 end as M12QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_qty) else 0 end as M11QTY,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_qty) else 0 end as M10QTY,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_qty) else 0 end as M09QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_qty) else 0 end as M08QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_qty) else 0 end as M07QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_qty) else 0 end as M06QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_qty) else 0 end as M05QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_qty) else 0 end as M04QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_qty) else 0 end as M03QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_qty) else 0 end as M02QTY,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_qty) else 0 end as M01QTY,
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_amt) else 0 end as M00AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_amt) else 0 end as M24AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_amt) else 0 end as M23AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_amt) else 0 end as M22AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_amt) else 0 end as M21AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_amt) else 0 end as M20AMT,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_amt) else 0 end as M19AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_amt) else 0 end as M18AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_amt) else 0 end as M17AMT,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_amt) else 0 end as M16AMT,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_amt) else 0 end as M15AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_amt) else 0 end as M14AMT,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_amt) else 0 end as M13AMT,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_amt) else 0 end as M12AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_amt) else 0 end as M11AMT,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_amt) else 0 end as M10AMT,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_amt) else 0 end as M09AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_amt) else 0 end as M08AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_amt) else 0 end as M07AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_amt) else 0 end as M06AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_amt) else 0 end as M05AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_amt) else 0 end as M04AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_amt) else 0 end as M03AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_amt) else 0 end as M02AMT,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_amt) else 0 end as M01AMT                                   
                                  FROM TNOTCLOSESUM A
                                 WHERE INS_DTM =
                                       (SELECT MAX(INS_DTM)
                                          FROM TNOTCLOSESUM
                                         WHERE VEN_CD IN
                                               (SELECT VEN_CD
                                                  FROM TABLE(FGET_VANTRANSFER('1', #svenCd#))))
                                   AND VEN_CD IN
                                       (SELECT VEN_CD
                                          FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                                   AND WB_FLG_CD = '1'          /* 운송장구분 (1:출고,2:회수)        */
                                   AND CLS_CD = '8'             /* 구분코드 (1:미출고,2:미배송)   */
                                   AND CLS_DTL_CD = '1'         /* 상세구분(1:지시일,2:예정일)    */
                                   AND DELIV_CLS_CD <> '10'       /* 센터배송은 제외                 */
                                   AND STD_DT < TO_DATE('20991231', 'yyyymmdd')
                                   group by DELIV_CLS_CD, TO_CHAR(a.STD_DT, 'yyyymm')
                                    
                                            UNION ALL
                             
                                            SELECT '20' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL
                                             
                                            SELECT '30' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                            
                                            UNION ALL
                                             
                                            SELECT '40' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL /* 직택배2추가 2009.09.03 gsYu */
                                             
                                            SELECT '35' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL)
                 
                         GROUP BY DELIV_CD
                         ORDER BY NO
                ]]>
            </isEqual>
        </isEqual>   
         
        <isEqual property="CLS_GUBUN" compareValue="1">
            <isEqual property="DELV_GUBUN" compareValue="2">
                <![CDATA[
                /***********************************************/
                /* 지시일자별 설치상품 미배송일때 1-8-2 start */
                /***********************************************/
                SELECT /* [출고/고객인수미처리현황][orderDetail.sqlx][OrderManagerService.inquireTakeOutwCustRecvBeNotYetProcessPresentState][2014.2.13][hyun_ah] */
                         (DECODE(DELIV_CD, '20', 3, '30', 1, '40', 2, '35', 4)) AS NO, /* 직택배2추가 2009.09.03 gsYu */
                           DELIV_CD AS DELIV_CD,
                           TO_CHAR(SUM(M00QTY) + SUM(M01QTY) + SUM(M02QTY) + SUM(M03QTY) +
                                   SUM(M04QTY) + SUM(M05QTY) + SUM(M06QTY) + SUM(M07QTY) +
                                   SUM(M08QTY) + SUM(M09QTY) + SUM(M10QTY) + SUM(M11QTY) +
                                   SUM(M12QTY) + SUM(M13QTY) + SUM(M14QTY) + SUM(M15QTY) +
                                   SUM(M16QTY) + SUM(M17QTY) + SUM(M18QTY) + SUM(M19QTY) +
                                   SUM(M20QTY) + SUM(M21QTY) + SUM(M22QTY) + SUM(M23QTY) + SUM(M24QTY)) AS TOT_QTY,
                           TO_CHAR(SUM(M00AMT) + SUM(M01AMT) + SUM(M02AMT) + SUM(M03AMT) +
                                   SUM(M04AMT) + SUM(M05AMT) + SUM(M06AMT) + SUM(M07AMT) +
                                   SUM(M08AMT) + SUM(M09AMT) + SUM(M10AMT) + SUM(M11AMT) +
                                   SUM(M12AMT) + SUM(M13AMT) + SUM(M14AMT) + SUM(M15AMT) +
                                   SUM(M16AMT) + SUM(M17AMT) + SUM(M18AMT) + SUM(M19AMT) +
                                   SUM(M20AMT) + SUM(M21AMT) + SUM(M22AMT) + SUM(M23AMT) + SUM(M24AMT)) AS TOT_AMT,
                          SUM(M01AMT) AS M01AMT,
                          SUM(M02AMT) AS M02AMT,
                          SUM(M03AMT) AS M03AMT,
                          SUM(M04AMT) AS M04AMT,
                          SUM(M05AMT) AS M05AMT,
                          SUM(M06AMT) AS M06AMT,
                          SUM(M07AMT) AS M07AMT,
                          SUM(M08AMT) AS M08AMT,
                          SUM(M09AMT) AS M09AMT,
                          SUM(M10AMT) AS M10AMT,
                          SUM(M11AMT) AS M11AMT,
                          SUM(M12AMT) AS M12AMT,
                          SUM(M13AMT) AS M13AMT,
                          SUM(M14AMT) AS M14AMT,
                          SUM(M15AMT) AS M15AMT,
                          SUM(M16AMT) AS M16AMT,
                          SUM(M17AMT) AS M17AMT,
                          SUM(M18AMT) AS M18AMT,
                          SUM(M19AMT) AS M19AMT,
                          SUM(M20AMT) AS M20AMT,
                          SUM(M21AMT) AS M21AMT,
                          SUM(M22AMT) AS M22AMT,
                          SUM(M23AMT) AS M23AMT,
                          SUM(M24AMT) AS M24AMT,
                          SUM(M00AMT) AS M00AMT,
                          SUM(M01QTY) AS M01QTY,
                          SUM(M02QTY) AS M02QTY,
                          SUM(M03QTY) AS M03QTY,
                          SUM(M04QTY) AS M04QTY,
                          SUM(M05QTY) AS M05QTY,
                          SUM(M06QTY) AS M06QTY,
                          SUM(M07QTY) AS M07QTY,
                          SUM(M08QTY) AS M08QTY,
                          SUM(M09QTY) AS M09QTY,
                          SUM(M10QTY) AS M10QTY,
                          SUM(M11QTY) AS M11QTY,
                          SUM(M12QTY) AS M12QTY,
                          SUM(M13QTY) AS M13QTY,
                          SUM(M14QTY) AS M14QTY,
                          SUM(M15QTY) AS M15QTY,
                          SUM(M16QTY) AS M16QTY,
                          SUM(M17QTY) AS M17QTY,
                          SUM(M18QTY) AS M18QTY,
                          SUM(M19QTY) AS M19QTY,
                          SUM(M20QTY) AS M20QTY,
                          SUM(M21QTY) AS M21QTY,
                          SUM(M22QTY) AS M22QTY,
                          SUM(M23QTY) AS M23QTY,
                          SUM(M24QTY) AS M24QTY,
                          SUM(M00QTY) AS M00QTY                      
                          FROM (
                                   select DELIV_CLS_CD as DELIV_CD, 
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_qty) else 0 end as M00QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_qty) else 0 end as M24QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_qty) else 0 end as M23QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_qty) else 0 end as M22QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_qty) else 0 end as M21QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_qty) else 0 end as M20QTY,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_qty) else 0 end as M19QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_qty) else 0 end as M18QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_qty) else 0 end as M17QTY,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_qty) else 0 end as M16QTY,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_qty) else 0 end as M15QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_qty) else 0 end as M14QTY,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_qty) else 0 end as M13QTY,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_qty) else 0 end as M12QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_qty) else 0 end as M11QTY,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_qty) else 0 end as M10QTY,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_qty) else 0 end as M09QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_qty) else 0 end as M08QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_qty) else 0 end as M07QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_qty) else 0 end as M06QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_qty) else 0 end as M05QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_qty) else 0 end as M04QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_qty) else 0 end as M03QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_qty) else 0 end as M02QTY,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_qty) else 0 end as M01QTY,
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_amt) else 0 end as M00AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_amt) else 0 end as M24AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_amt) else 0 end as M23AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_amt) else 0 end as M22AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_amt) else 0 end as M21AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_amt) else 0 end as M20AMT,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_amt) else 0 end as M19AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_amt) else 0 end as M18AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_amt) else 0 end as M17AMT,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_amt) else 0 end as M16AMT,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_amt) else 0 end as M15AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_amt) else 0 end as M14AMT,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_amt) else 0 end as M13AMT,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_amt) else 0 end as M12AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_amt) else 0 end as M11AMT,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_amt) else 0 end as M10AMT,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_amt) else 0 end as M09AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_amt) else 0 end as M08AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_amt) else 0 end as M07AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_amt) else 0 end as M06AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_amt) else 0 end as M05AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_amt) else 0 end as M04AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_amt) else 0 end as M03AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_amt) else 0 end as M02AMT,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_amt) else 0 end as M01AMT
                                  FROM TNOTCLOSESUM A
                                 WHERE INS_DTM =
                                       (SELECT MAX(INS_DTM)
                                          FROM TNOTCLOSESUM
                                         WHERE VEN_CD IN
                                               (SELECT VEN_CD
                                                  FROM TABLE(FGET_VANTRANSFER('1', #svenCd#))))
                                   AND VEN_CD IN
                                       (SELECT VEN_CD
                                          FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                                   AND WB_FLG_CD = '1'          /* 운송장구분 (1:출고,2:회수)        */
                                   AND CLS_CD = '8'             /* 구분코드 (1:미출고,2:미배송)   */
                                   AND CLS_DTL_CD = '2'         /* 상세구분(1:지시일,2:예정일)    */
                                   AND DELIV_CLS_CD <> '10'       /* 센터배송은 제외                 */
                                   AND STD_DT < TO_DATE('20991231', 'yyyymmdd')
                                   group by DELIV_CLS_CD, TO_CHAR(a.STD_DT, 'yyyymm')
                                    
                                            UNION ALL
                             
                                            SELECT '20' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL
                                             
                                            SELECT '30' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                            
                                            UNION ALL
                                             
                                            SELECT '40' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL /* 직택배2추가 2009.09.03 gsYu */
                                             
                                            SELECT '35' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL)
                 
                         GROUP BY DELIV_CD
                         ORDER BY NO
                ]]>
            </isEqual>
        </isEqual>
         
        <isEqual property="CLS_GUBUN" compareValue="2">
            <isEqual property="DELV_GUBUN" compareValue="1">
                <![CDATA[
                /***********************************************/
                /* 지시일자별 일반상품 고객미인수일때 1-8-3 start */
                /***********************************************/
                SELECT /* [출고/고객인수미처리현황][orderDetail.sqlx][OrderManagerService.inquireTakeOutwCustRecvBeNotYetProcessPresentState][2014.2.13][hyun_ah] */
                         (DECODE(DELIV_CD, '20', 3, '30', 1, '40', 2, '35', 4)) AS NO, /* 직택배2추가 2009.09.03 gsYu */
                           DELIV_CD AS DELIV_CD,
                           TO_CHAR(SUM(M00QTY) + SUM(M01QTY) + SUM(M02QTY) + SUM(M03QTY) +
                                   SUM(M04QTY) + SUM(M05QTY) + SUM(M06QTY) + SUM(M07QTY) +
                                   SUM(M08QTY) + SUM(M09QTY) + SUM(M10QTY) + SUM(M11QTY) +
                                   SUM(M12QTY) + SUM(M13QTY) + SUM(M14QTY) + SUM(M15QTY) +
                                   SUM(M16QTY) + SUM(M17QTY) + SUM(M18QTY) + SUM(M19QTY) +
                                   SUM(M20QTY) + SUM(M21QTY) + SUM(M22QTY) + SUM(M23QTY) + SUM(M24QTY)) AS TOT_QTY,
                           TO_CHAR(SUM(M00AMT) + SUM(M01AMT) + SUM(M02AMT) + SUM(M03AMT) +
                                   SUM(M04AMT) + SUM(M05AMT) + SUM(M06AMT) + SUM(M07AMT) +
                                   SUM(M08AMT) + SUM(M09AMT) + SUM(M10AMT) + SUM(M11AMT) +
                                   SUM(M12AMT) + SUM(M13AMT) + SUM(M14AMT) + SUM(M15AMT) +
                                   SUM(M16AMT) + SUM(M17AMT) + SUM(M18AMT) + SUM(M19AMT) +
                                   SUM(M20AMT) + SUM(M21AMT) + SUM(M22AMT) + SUM(M23AMT) + SUM(M24AMT)) AS TOT_AMT,
                          SUM(M01AMT) AS M01AMT,
                          SUM(M02AMT) AS M02AMT,
                          SUM(M03AMT) AS M03AMT,
                          SUM(M04AMT) AS M04AMT,
                          SUM(M05AMT) AS M05AMT,
                          SUM(M06AMT) AS M06AMT,
                          SUM(M07AMT) AS M07AMT,
                          SUM(M08AMT) AS M08AMT,
                          SUM(M09AMT) AS M09AMT,
                          SUM(M10AMT) AS M10AMT,
                          SUM(M11AMT) AS M11AMT,
                          SUM(M12AMT) AS M12AMT,
                          SUM(M13AMT) AS M13AMT,
                          SUM(M14AMT) AS M14AMT,
                          SUM(M15AMT) AS M15AMT,
                          SUM(M16AMT) AS M16AMT,
                          SUM(M17AMT) AS M17AMT,
                          SUM(M18AMT) AS M18AMT,
                          SUM(M19AMT) AS M19AMT,
                          SUM(M20AMT) AS M20AMT,
                          SUM(M21AMT) AS M21AMT,
                          SUM(M22AMT) AS M22AMT,
                          SUM(M23AMT) AS M23AMT,
                          SUM(M24AMT) AS M24AMT,
                          SUM(M00AMT) AS M00AMT,
                          SUM(M01QTY) AS M01QTY,
                          SUM(M02QTY) AS M02QTY,
                          SUM(M03QTY) AS M03QTY,
                          SUM(M04QTY) AS M04QTY,
                          SUM(M05QTY) AS M05QTY,
                          SUM(M06QTY) AS M06QTY,
                          SUM(M07QTY) AS M07QTY,
                          SUM(M08QTY) AS M08QTY,
                          SUM(M09QTY) AS M09QTY,
                          SUM(M10QTY) AS M10QTY,
                          SUM(M11QTY) AS M11QTY,
                          SUM(M12QTY) AS M12QTY,
                          SUM(M13QTY) AS M13QTY,
                          SUM(M14QTY) AS M14QTY,
                          SUM(M15QTY) AS M15QTY,
                          SUM(M16QTY) AS M16QTY,
                          SUM(M17QTY) AS M17QTY,
                          SUM(M18QTY) AS M18QTY,
                          SUM(M19QTY) AS M19QTY,
                          SUM(M20QTY) AS M20QTY,
                          SUM(M21QTY) AS M21QTY,
                          SUM(M22QTY) AS M22QTY,
                          SUM(M23QTY) AS M23QTY,
                          SUM(M24QTY) AS M24QTY,
                          SUM(M00QTY) AS M00QTY                      
                          FROM (
                                   select DELIV_CLS_CD as DELIV_CD, 
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_qty) else 0 end as M00QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_qty) else 0 end as M24QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_qty) else 0 end as M23QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_qty) else 0 end as M22QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_qty) else 0 end as M21QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_qty) else 0 end as M20QTY,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_qty) else 0 end as M19QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_qty) else 0 end as M18QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_qty) else 0 end as M17QTY,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_qty) else 0 end as M16QTY,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_qty) else 0 end as M15QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_qty) else 0 end as M14QTY,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_qty) else 0 end as M13QTY,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_qty) else 0 end as M12QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_qty) else 0 end as M11QTY,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_qty) else 0 end as M10QTY,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_qty) else 0 end as M09QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_qty) else 0 end as M08QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_qty) else 0 end as M07QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_qty) else 0 end as M06QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_qty) else 0 end as M05QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_qty) else 0 end as M04QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_qty) else 0 end as M03QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_qty) else 0 end as M02QTY,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_qty) else 0 end as M01QTY,
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_amt) else 0 end as M00AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_amt) else 0 end as M24AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_amt) else 0 end as M23AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_amt) else 0 end as M22AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_amt) else 0 end as M21AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_amt) else 0 end as M20AMT,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_amt) else 0 end as M19AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_amt) else 0 end as M18AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_amt) else 0 end as M17AMT,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_amt) else 0 end as M16AMT,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_amt) else 0 end as M15AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_amt) else 0 end as M14AMT,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_amt) else 0 end as M13AMT,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_amt) else 0 end as M12AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_amt) else 0 end as M11AMT,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_amt) else 0 end as M10AMT,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_amt) else 0 end as M09AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_amt) else 0 end as M08AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_amt) else 0 end as M07AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_amt) else 0 end as M06AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_amt) else 0 end as M05AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_amt) else 0 end as M04AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_amt) else 0 end as M03AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_amt) else 0 end as M02AMT,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_amt) else 0 end as M01AMT
                                  FROM TNOTCLOSESUM A
                                 WHERE INS_DTM =
                                       (SELECT MAX(INS_DTM)
                                          FROM TNOTCLOSESUM
                                         WHERE VEN_CD IN
                                               (SELECT VEN_CD
                                                  FROM TABLE(FGET_VANTRANSFER('1', #svenCd#))))
                                   AND VEN_CD IN
                                       (SELECT VEN_CD
                                          FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                                   AND WB_FLG_CD = '1'          /* 운송장구분 (1:출고,2:회수)        */
                                   AND CLS_CD = '8'             /* 구분코드 (1:미출고,2:미배송)   */
                                   AND CLS_DTL_CD = '3'         /* 상세구분(1:지시일,2:예정일)    */
                                   AND DELIV_CLS_CD <> '10'       /* 센터배송은 제외                 */
                                   AND STD_DT < TO_DATE('20991231', 'yyyymmdd')
                                   group by DELIV_CLS_CD, TO_CHAR(a.STD_DT, 'yyyymm')
                                    
                                            UNION ALL
                             
                                            SELECT '20' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL
                                             
                                            SELECT '30' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                            
                                            UNION ALL
                                             
                                            SELECT '40' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL /* 직택배2추가 2009.09.03 gsYu */
                                             
                                            SELECT '35' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL)
                 
                         GROUP BY DELIV_CD
                         ORDER BY NO
                ]]>
            </isEqual>
        </isEqual>   
         
        <isEqual property="CLS_GUBUN" compareValue="2">
            <isEqual property="DELV_GUBUN" compareValue="2">
                <![CDATA[
                /***********************************************/
                /* 지시일자별 설치상품 고객미인수일때 1-8-4 start */
                /***********************************************/
                SELECT /* [출고/고객인수미처리현황][orderDetail.sqlx][OrderManagerService.inquireTakeOutwCustRecvBeNotYetProcessPresentState][2014.2.13][hyun_ah] */
                         (DECODE(DELIV_CD, '20', 3, '30', 1, '40', 2, '35', 4)) AS NO, /* 직택배2추가 2009.09.03 gsYu */
                           DELIV_CD AS DELIV_CD,
                           TO_CHAR(SUM(M00QTY) + SUM(M01QTY) + SUM(M02QTY) + SUM(M03QTY) +
                                   SUM(M04QTY) + SUM(M05QTY) + SUM(M06QTY) + SUM(M07QTY) +
                                   SUM(M08QTY) + SUM(M09QTY) + SUM(M10QTY) + SUM(M11QTY) +
                                   SUM(M12QTY) + SUM(M13QTY) + SUM(M14QTY) + SUM(M15QTY) +
                                   SUM(M16QTY) + SUM(M17QTY) + SUM(M18QTY) + SUM(M19QTY) +
                                   SUM(M20QTY) + SUM(M21QTY) + SUM(M22QTY) + SUM(M23QTY) + SUM(M24QTY)) AS TOT_QTY,
                           TO_CHAR(SUM(M00AMT) + SUM(M01AMT) + SUM(M02AMT) + SUM(M03AMT) +
                                   SUM(M04AMT) + SUM(M05AMT) + SUM(M06AMT) + SUM(M07AMT) +
                                   SUM(M08AMT) + SUM(M09AMT) + SUM(M10AMT) + SUM(M11AMT) +
                                   SUM(M12AMT) + SUM(M13AMT) + SUM(M14AMT) + SUM(M15AMT) +
                                   SUM(M16AMT) + SUM(M17AMT) + SUM(M18AMT) + SUM(M19AMT) +
                                   SUM(M20AMT) + SUM(M21AMT) + SUM(M22AMT) + SUM(M23AMT) + SUM(M24AMT)) AS TOT_AMT,
                          SUM(M01AMT) AS M01AMT,
                          SUM(M02AMT) AS M02AMT,
                          SUM(M03AMT) AS M03AMT,
                          SUM(M04AMT) AS M04AMT,
                          SUM(M05AMT) AS M05AMT,
                          SUM(M06AMT) AS M06AMT,
                          SUM(M07AMT) AS M07AMT,
                          SUM(M08AMT) AS M08AMT,
                          SUM(M09AMT) AS M09AMT,
                          SUM(M10AMT) AS M10AMT,
                          SUM(M11AMT) AS M11AMT,
                          SUM(M12AMT) AS M12AMT,
                          SUM(M13AMT) AS M13AMT,
                          SUM(M14AMT) AS M14AMT,
                          SUM(M15AMT) AS M15AMT,
                          SUM(M16AMT) AS M16AMT,
                          SUM(M17AMT) AS M17AMT,
                          SUM(M18AMT) AS M18AMT,
                          SUM(M19AMT) AS M19AMT,
                          SUM(M20AMT) AS M20AMT,
                          SUM(M21AMT) AS M21AMT,
                          SUM(M22AMT) AS M22AMT,
                          SUM(M23AMT) AS M23AMT,
                          SUM(M24AMT) AS M24AMT,
                          SUM(M00AMT) AS M00AMT,
                          SUM(M01QTY) AS M01QTY,
                          SUM(M02QTY) AS M02QTY,
                          SUM(M03QTY) AS M03QTY,
                          SUM(M04QTY) AS M04QTY,
                          SUM(M05QTY) AS M05QTY,
                          SUM(M06QTY) AS M06QTY,
                          SUM(M07QTY) AS M07QTY,
                          SUM(M08QTY) AS M08QTY,
                          SUM(M09QTY) AS M09QTY,
                          SUM(M10QTY) AS M10QTY,
                          SUM(M11QTY) AS M11QTY,
                          SUM(M12QTY) AS M12QTY,
                          SUM(M13QTY) AS M13QTY,
                          SUM(M14QTY) AS M14QTY,
                          SUM(M15QTY) AS M15QTY,
                          SUM(M16QTY) AS M16QTY,
                          SUM(M17QTY) AS M17QTY,
                          SUM(M18QTY) AS M18QTY,
                          SUM(M19QTY) AS M19QTY,
                          SUM(M20QTY) AS M20QTY,
                          SUM(M21QTY) AS M21QTY,
                          SUM(M22QTY) AS M22QTY,
                          SUM(M23QTY) AS M23QTY,
                          SUM(M24QTY) AS M24QTY,
                          SUM(M00QTY) AS M00QTY                      
                          FROM (
                                   select DELIV_CLS_CD as DELIV_CD, 
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_qty) else 0 end as M00QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_qty) else 0 end as M24QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_qty) else 0 end as M23QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_qty) else 0 end as M22QTY,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_qty) else 0 end as M21QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_qty) else 0 end as M20QTY,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_qty) else 0 end as M19QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_qty) else 0 end as M18QTY,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_qty) else 0 end as M17QTY,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_qty) else 0 end as M16QTY,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_qty) else 0 end as M15QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_qty) else 0 end as M14QTY,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_qty) else 0 end as M13QTY,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_qty) else 0 end as M12QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_qty) else 0 end as M11QTY,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_qty) else 0 end as M10QTY,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_qty) else 0 end as M09QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_qty) else 0 end as M08QTY,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_qty) else 0 end as M07QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_qty) else 0 end as M06QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_qty) else 0 end as M05QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_qty) else 0 end as M04QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_qty) else 0 end as M03QTY,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_qty) else 0 end as M02QTY,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_qty) else 0 end as M01QTY,
                                    case when to_char(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, 0), 'YYYYMM') then sum(a.outw_amt) else 0 end as M00AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -24), 'YYYYMM') then sum(a.outw_amt) else 0 end as M24AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -23), 'YYYYMM') then sum(a.outw_amt) else 0 end as M23AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -22), 'YYYYMM') then sum(a.outw_amt) else 0 end as M22AMT,
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -21), 'YYYYMM') then sum(a.outw_amt) else 0 end as M21AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -20), 'YYYYMM') then sum(a.outw_amt) else 0 end as M20AMT,   
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -19), 'YYYYMM') then sum(a.outw_amt) else 0 end as M19AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -18), 'YYYYMM') then sum(a.outw_amt) else 0 end as M18AMT,     
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -17), 'YYYYMM') then sum(a.outw_amt) else 0 end as M17AMT,    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -16), 'YYYYMM') then sum(a.outw_amt) else 0 end as M16AMT,         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -15), 'YYYYMM') then sum(a.outw_amt) else 0 end as M15AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -14), 'YYYYMM') then sum(a.outw_amt) else 0 end as M14AMT,       
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -13), 'YYYYMM') then sum(a.outw_amt) else 0 end as M13AMT,      
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -12), 'YYYYMM') then sum(a.outw_amt) else 0 end as M12AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -11), 'YYYYMM') then sum(a.outw_amt) else 0 end as M11AMT,          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -10), 'YYYYMM') then sum(a.outw_amt) else 0 end as M10AMT,                          
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -9), 'YYYYMM') then sum(a.outw_amt) else 0 end as M09AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -8), 'YYYYMM') then sum(a.outw_amt) else 0 end as M08AMT,                         
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -7), 'YYYYMM') then sum(a.outw_amt) else 0 end as M07AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -6), 'YYYYMM') then sum(a.outw_amt) else 0 end as M06AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -5), 'YYYYMM') then sum(a.outw_amt) else 0 end as M05AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'YYYYMM') then sum(a.outw_amt) else 0 end as M04AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -3), 'YYYYMM') then sum(a.outw_amt) else 0 end as M03AMT,        
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -2), 'YYYYMM') then sum(a.outw_amt) else 0 end as M02AMT,                                                                                    
                                    case when TO_CHAR(a.STD_DT, 'yyyymm') = TO_CHAR(ADD_MONTHS(sysdate, -1), 'YYYYMM') then sum(a.outw_amt) else 0 end as M01AMT
                                  FROM TNOTCLOSESUM A
                                 WHERE INS_DTM =
                                       (SELECT MAX(INS_DTM)
                                          FROM TNOTCLOSESUM
                                         WHERE VEN_CD IN
                                               (SELECT VEN_CD
                                                  FROM TABLE(FGET_VANTRANSFER('1', #svenCd#))))
                                   AND VEN_CD IN
                                       (SELECT VEN_CD
                                          FROM TABLE(FGET_VANTRANSFER('1', #svenCd#)))
                                   AND WB_FLG_CD = '1'          /* 운송장구분 (1:출고,2:회수)        */
                                   AND CLS_CD = '8'             /* 구분코드 (1:미출고,2:미배송)   */
                                   AND CLS_DTL_CD = '4'         /* 상세구분(1:지시일,2:예정일)    */
                                   AND DELIV_CLS_CD <> '10'       /* 센터배송은 제외                 */
                                   AND STD_DT < TO_DATE('20991231', 'yyyymmdd')
                                   group by DELIV_CLS_CD, TO_CHAR(a.STD_DT, 'yyyymm')
                                    
                                            UNION ALL
                             
                                            SELECT '20' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL
                                             
                                            SELECT '30' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                            
                                            UNION ALL
                                             
                                            SELECT '40' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL
                                             
                                            UNION ALL /* 직택배2추가 2009.09.03 gsYu */
                                             
                                            SELECT '35' AS DELIV_CD,    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                                              FROM DUAL)
                 
                         GROUP BY DELIV_CD
                         ORDER BY NO
                ]]>
            </isEqual>
        </isEqual>           
        /* P_TakeOutWCustRecvBeNotYetProcessPresentStateInquire_M :pa/OrderManager.inquireTakeOutwCustRecvBeNotYetProcessPresentStateWbCrtDt [출고/고객인수미처리현황-지시일자별 조회 ]*/
    </select>



    