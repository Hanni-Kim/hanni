SELECT  /* [주문상품정보조회][tbl-orditem][selectOrdItemInf][2021.10.18][[주문]박혜지]*/
                /*+ USE_NL(A I E C R) INDEX(A ITORDERITEM4) */
                A.ORD_NO                      ORD_NO              /** 주문번호    */
              , A.ORD_G_SEQ                   ORD_G_SEQ           /** 주문상품순번*/
              , CASE NVL ( (SELECT  TCPN.CPN_PUBLICCOMP_CD
                            FROM    ADM.TITEM_CPN_INFO TCPN
                            WHERE   TCPN.ITEM_CD=I.ITEM_CD
                            ),''
                        )
                WHEN '05'
                THEN ( CASE WHEN (SELECT COUNT(1) AS CNT  FROM ADM.TCODE WHERE TCODE.LGRP_CD='ORTI'   AND I.ITEM_TYPE_CD = TCODE.CD_SHRT_NM ) > 0
                        THEN 'LP'    /** 방송수강권 */
                        ELSE 'GP'     /** 방송이용권 */
                        END
                     )
                ELSE 'N'
                END TV_FORMLESS_YN      /** 방송무형상품여부    */
              , NVL((SELECT CPN_NO_SNDDELI_GB_CD FROM ADM.TORDER_CPN_PUBLIC CPN
                     WHERE CPN.ORD_NO=A.ORD_NO AND CPN.ORD_G_SEQ=A.ORD_G_SEQ AND ROWNUM=1), '0') AS CPN_NO_SNDDELI_GB_CD
              , A.CHN_CD                      CHN_CD              /** 채널코드    */
              , A.ORD_FRM_CD                    ORD_FRM_CD          /** 주문형태    */
              , I.ITEM_CD                     ITEM_CD             /** 판매코드    */
              , DECODE(I.ITEM_TYPE_CD, '90010101', A.CJMALL_ITEM_NM, I.ITEM_NM)
                                                ITEM_NM             /** 판매상품    */
              , NVL(A.DELAY_RWRD_YN,'0')        DELY_YN             /** 배송지연여부*/
              , ORD.F_GET_INTG_COST_AMT(A.ORD_NO, (SELECT   X.ITEM_CD
                                                   FROM ADM.TORDERDTL X
                                                   WHERE X.ORD_NO=A.ORD_NO
                                                   AND X.ORD_G_SEQ=A.ORD_G_SEQ
                                                   AND X.ORD_D_SEQ='001'
                                                   AND X.ORD_W_SEQ='001'
                                                   AND ROWNUM=1), '01')
                                                RTN_COST            /** 반품비    */
              , ORD.F_GET_INTG_COST_AMT(A.ORD_NO, (SELECT X.ITEM_CD
                                                   FROM ADM.TORDERDTL X
                                                   WHERE X.ORD_NO=A.ORD_NO
                                                   AND X.ORD_G_SEQ=A.ORD_G_SEQ
                                                   AND X.ORD_D_SEQ='001'
                                                   AND X.ORD_W_SEQ='001'
                                                   AND ROWNUM=1), '04')
                                                EXCH_COST           /** 교환비    */
              , ORD.FGET_COST_AMT(A.ITEM_CD, A.CHN_CD, '06', O.ORD_DTM, A.CUST_NO)
                                                INST_COST           /** 설치비    */
              , nvl((SELECT nvl(X.JEJU_ADD_COST,0)
                     FROM ADM.TDELIVCST X,ADM.TITEMADD Y
                     WHERE X.DELIV_COST_CD=Y.DELIV_COST_CD
                     AND Y.ITEM_CD = A.ITEM_CD
                     AND X.APPLY_DT = (SELECT MAX(APPLY_DT)
                                       FROM ADM.TDELIVCST
                                       WHERE DELIV_COST_CD = X.DELIV_COST_CD
                                       AND APPLY_DT <= TO_CHAR(A.ORD_DTM,'yyyymmddhh24')
                                       AND USE_YN='1')
                     AND USE_YN = '1'
                     AND ROWNUM = 1
                    ),0) AS JEJU_ADD_COST
              , nvl((SELECT nvl(X.ISLAND_ADD_COST,0)
                     FROM ADM.TDELIVCST X,ADM.TITEMADD Y
                     WHERE X.DELIV_COST_CD=Y.DELIV_COST_CD
                     AND Y.ITEM_CD = A.ITEM_CD
                     AND X.APPLY_DT = (SELECT MAX(APPLY_DT)
                                       FROM ADM.TDELIVCST
                                       WHERE DELIV_COST_CD = X.DELIV_COST_CD
                                       AND APPLY_DT <= TO_CHAR(A.ORD_DTM,'yyyymmddhh24')
                                       AND USE_YN='1')
                     AND USE_YN = '1'
                     AND ROWNUM = 1
                    ),0) AS ISLAND_ADD_COST
              , (SELECT NVL(SUM(DECODE(CT.PROC_CLS_CD, '00', CT.COST, CT.COST * -1)),0)
                 FROM ADM.TORDERCOST CT
                 WHERE CT.ORD_NO = A.ORD_NO
                 AND CT.ORD_G_SEQ = A.ORD_G_SEQ
                 AND CT.COST_CLS_CD != '02'
                 AND NVL(CT.CNCL_YN, '0') = '0'
                 ) DLV_COST /** 실배송+설치비 */
              , A.SL_PRC                        SL_PRC              /** 판매금액    */
              , (A.ORD_QTY-A.CNCL_QTY-A.RETURN_CONF_QTY)
                                                ORD_QTY             /** 주문수량    */
              , ((A.ORD_QTY-A.CNCL_QTY-A.RETURN_CONF_QTY)*A.SL_PRC)
                                                ORD_AMT             /** 주문금액    */
              , A.DC_RT                         DC_RT               /** 할인율 */
              , A.DC_AMT                        DC_AMT              /** 할인금액    */
              , (SELECT DECODE(CLS_CD, '076', 'OPT' || CONT1, CONT1)
                 FROM ADM.TORDERETC
                 WHERE ORD_NO    = DECODE(A.ORG_ORD_NO, NULL, A.ORD_NO, A.ORG_ORD_NO)  /* 기출하 고려 : 20111007 */
                 AND ORD_G_SEQ   = DECODE(A.ORG_ORD_G_SEQ, NULL, A.ORD_G_SEQ, A.ORG_ORD_G_SEQ)
                 AND CLS_CD  IN ('015', '076')
                 AND ITEM_CD = A.ITEM_CD
                 AND ROWNUM = 1) AS CNFM_NO /** 인증번호    */
              , DECODE(I.DELIV_TYPE_CD, '20', '1', '0')
                                                DRT_DLV_YN          /** 설치상품여부*/
              , NVL((SELECT SUM(REAL_DC_AMT)
                     FROM ADM.TORDERCOUPONDC
                     WHERE CUST_NO = A.CUST_NO
                     AND ORD_NO = A.ORD_NO
                     AND ORD_G_SEQ = A.ORD_G_SEQ
                     AND ORD_DTL_CLS_CD = '10'),NVL(CASE WHEN A.DC_AMT < (SELECT NVL(SUM(CASE WHEN MAX_DC_AMT < DECODE(CP.DC_CLS_CD,'2', TRUNC(A.SL_PRC * (CP.DC_RT/100),-1) , CP.DC_AMT) * A.ORD_QTY THEN MAX_DC_AMT
                                                                                                ELSE DECODE(CP.DC_CLS_CD,'2', TRUNC(A.SL_PRC * (CP.DC_RT/100),-1) , CP.DC_AMT) * A.ORD_QTY END )
                                                                                        ,0)
                                                                             FROM ADM.TCUSTDCCOUPON CP, ADM.TOFFER X
                                                                             WHERE CP.CUST_NO   = A.CUST_NO
                                                                             AND CP.ORD_NO    = A.ORD_NO
                                                                             AND CP.ORD_G_SEQ = A.ORD_G_SEQ
                                                                             AND CP.OFFER_CD = X.OFFER_CD
                                                                             ) THEN A.DC_AMT
                                                    ELSE (SELECT NVL(SUM(CASE WHEN MAX_DC_AMT < DECODE(CP.DC_CLS_CD,'2', TRUNC(A.SL_PRC * (CP.DC_RT/100),-1) , CP.DC_AMT) * A.ORD_QTY THEN MAX_DC_AMT
                                                                            ELSE DECODE(CP.DC_CLS_CD,'2', TRUNC(A.SL_PRC * (CP.DC_RT/100),-1) , CP.DC_AMT) * A.ORD_QTY END )
                                                                    ,0)
                                                          FROM ADM.TCUSTDCCOUPON CP,ADM.TOFFER X
                                                          WHERE CP.CUST_NO   = A.CUST_NO
                                                          AND CP.ORD_NO    = A.ORD_NO
                                                          AND CP.ORD_G_SEQ = A.ORD_G_SEQ
                                                          AND CP.OFFER_CD = X.OFFER_CD
                                                          )
                                                    END,0))
                        AS CP_DC_AMT
              , CNCL_QTY                      CNCL_QTY            /** 취소수량 */
              , RETURN_RCPT_QTY               RETURN_RCPT_QTY     /** 반품접수수량 */
              , RETURN_CONF_QTY               RETURN_CONF_QTY     /** 반품확정수량 */
              , RETURN_CNCL_QTY               RETURN_CNCL_QTY     /** 반품취소수량 */
              , EXCH_CNT                      EXCH_CNT            /** 교환횟수 */
              , AS_CNT                        AS_CNT              /** AS횟수 */
              , A.GIFT_PROM_NO                GIFT_PROM_NO        /** 경품프로모션번호      */
              , (SELECT NVL(COUNT(1),0)
                 FROM ADM.TORDERITEMPROMO P
                 WHERE P.ORD_NO = A.ORD_NO
                 AND P.ORD_G_SEQ = A.ORD_G_SEQ
                 AND P.OFFER_TYPE_CD = '07'
                 AND P.GIFT_YN = '1'
                 AND ROWNUM = 1)            NOREST_DC_YN        /* 무이자일시불할인여부-무*/
              , (SELECT NVL(COUNT(1),0)
                 FROM ADM.TORDERITEMPROMO P
                 WHERE P.ORD_NO = A.ORD_NO
                 AND P.ORD_G_SEQ = A.ORD_G_SEQ
                 AND P.OFFER_TYPE_CD = '03'
                 AND P.GIFT_YN = '1'
                 AND ROWNUM = 1)            SAVEAMT_DC_YN       /** 적립금할인여부-적     */
              , (SELECT NVL(COUNT(1),0)
                 FROM ADM.TORDERITEMPROMO P
                 WHERE P.ORD_NO = A.ORD_NO
                 AND P.ORD_G_SEQ = A.ORD_G_SEQ
                 AND P.OFFER_TYPE_CD = '14'
                 AND ROWNUM = 1)            ARS_DC_YN       /** ARS 할인여부-A*/
              , A.SMS_TRANS_YN                SMS_TRANS_YN        /** SMS 전송여부              */
              , NVL(I.TAX_YN, '1')            TAXT_PRMS_YN        /** 과세면세여부          */
              , A.CJMALL_COMP_ITEM_CD         COMP_ITM_CD         /** 업체상품코드          */
              , '0'                           RTN_COST_APLY_YN    /* 반품택비비적용여부     */
              , DECODE(R.RCPT_RSN_CD , '11',
                        DECODE(R.PROG_CD, '99', '1', '0' ), '0' )  RESTIRICT_CLS       /* 삭제주문 조회권한      */
              , O.ORD_REF                     ORD_REF             /** 주문참조*/
              , O.PRC_ORD_YN                  PRC_ORD_YN          /** 가주문여부*/
              , (SELECT NVL(DELIHOME_AMT_CLS_CD,0) FROM ADM.titemchnl WHERE item_cd = A.ITEM_CD AND chn_cd = A.CHN_CD AND rownum = 1) DELIHOME_AMT_CLS_CD
              , (SELECT DECODE(MAX(TOO.ORD_NO), NULL, '0', '1') FROM ADM.TORDERRORD TOO WHERE TOO.ORD_NO = A.ORD_NO AND TOO.ORD_G_SEQ = A.ORD_G_SEQ) AS RE_ORDER_YN
              , NVL((SELECT '1'
                     FROM ADM.TITEM X
                     WHERE 1=1  /* CARD_NOUSE_YN = '1' 상품권 결제 가맹점 추가로 불가 여부 제외 2013.07.08 gsYu */
                     AND ITEM_MGRP_CD IN ('8002', '1102')    /* 상품분류체계변경으로 인한 추가, 2022.09.21 */
                          
                     AND X.ITEM_CD = A.ITEM_CD
                     AND ROWNUM = 1), '0') GIFT_CERT_YN           /** 현금영수증 발급 - 상품권상품여부 */
              , (SELECT DECODE(COUNT(1),0,0,1)
                 FROM ADM.TORDERPRESENT
                 WHERE ORD_NO =A.ORD_NO
                 AND ORD_G_SEQ =A.ORD_G_SEQ ) AS PRESENT_YN  /** 선물배송여부**/
              , (SELECT CASE WHEN X.PRESENT_STATUS_CD='0' THEN DECODE(X.MSG_TP_CD,'KAKAOTALK','카카오톡으로 선물','문자로 선물')
                             WHEN X.PRESENT_STATUS_CD='1' THEN DECODE(X.MSG_TP_CD,'KAKAOTALK','카카오톡으로 선물','문자로 선물')|| CASE WHEN X.PRESENT_CHOICE_STAT_CD = 'CANCEL_READY' THEN ' / 취소 대기'
                                                                                                                                WHEN X.PRESENT_CHOICE_STAT_CD = 'CANCEL_OUT_BOUND' THEN ' / OB 처리 대기'
                                                                                                                                ELSE ' 수락'||CASE WHEN X.AGREE_DTM IS NOT NULL THEN ' '||TO_CHAR(X.AGREE_DTM,'YYYY/MM/DD') END
                                                                                                                                END
                             WHEN X.PRESENT_STATUS_CD='2' THEN DECODE(X.MSG_TP_CD,'KAKAOTALK','카카오톡으로 선물','문자로 선물')||' 거절'||CASE WHEN X.REFUSE_DTM IS NOT NULL THEN ' '||TO_CHAR(X.REFUSE_DTM,'YYYY/MM/DD') END
                             WHEN X.PRESENT_STATUS_CD='3' THEN DECODE(X.MSG_TP_CD,'KAKAOTALK','카카오톡으로 선물','문자로 선물')||' 주문자 취소'
                             WHEN X.PRESENT_STATUS_CD='4' THEN DECODE(X.MSG_TP_CD,'KAKAOTALK','카카오톡으로 선물','문자로 선물')||' 배송지미입력'
                             WHEN X.PRESENT_STATUS_CD='5' THEN '재고부족취소'
                             WHEN X.PRESENT_STATUS_CD='6' THEN '기타취소'
                             WHEN X.PRESENT_STATUS_CD='7' THEN DECODE(X.MSG_TP_CD,'KAKAOTALK','카카오톡으로 선물','문자로 선물')||' / 취소 완료'
                             END AS PRESENT_STATUS_CD
                FROM ADM.TORDERPRESENT X
                WHERE X.ORD_NO =A.ORD_NO
                AND X.ORD_G_SEQ =A.ORD_G_SEQ) AS PRESENT_STATE_CD  /** 선물배송상태코드**/
              , (CASE WHEN (SELECT decode(COUNT(1),SUM(NVL(income_ded_yn,0)),'1','0')
                            FROM ADM.TORDITEMDELIVCST X
                            WHERE ORD_NO =A.ORD_NO
                            AND ITEM_CD NOT IN (SELECT ITEM_CD FROM ADM.TITEM WHERE ITEM_CD = X.ITEM_CD AND NVL(PROMGIFT_YN, '0') = '1')
                            ) = '0' THEN '0'
                      WHEN (SELECT decode(COUNT(1),SUM(NVL(income_ded_yn,0)),'1','0')
                            FROM ADM.TORDITEMDELIVCST X
                            WHERE ORD_NO =A.ORD_NO
                            AND ITEM_CD NOT IN (SELECT ITEM_CD FROM ADM.TITEM WHERE ITEM_CD = X.ITEM_CD AND NVL(PROMGIFT_YN, '0') = '1')) ='1'
                            AND EXISTS (SELECT 1
                                        FROM ADM.tinamt
                                        WHERE ord_no=A.ord_no
                                        AND (( pam_meth_Cd IN (SELECT mgrp_Cd FROM ADM.Tcode WHERE lgrp_Cd='S308')) OR (pam_meth_Cd='01' AND card_dtl_bank_cd>=800 AND card_dtl_bank_Cd<900))
                                        AND PAM_TYPE_CD='00' AND nvl(cncl_cd,'0') <>'1' AND repay_poss_amt > 0
                                        ) THEN '1'
                      ELSE '0' END
                ) AS INCOME_DED_YN
              , (select Decode(deliv_tm_cls_cd,'70','1','0') from ADM.torderdtl where ord_no=A.ord_no and ord_g_Seq=A.ord_g_Seq and ord_D_Seq='001' and ord_w_Seq='001') as DAWN_DELIV_YN
              , (SELECT DELIV_TM_CLS_CD FROM ADM.TORDERDTL WHERE ORD_NO=A.ORD_NO AND ORD_G_SEQ=A.ORD_G_SEQ AND ORD_D_SEQ='001' AND ORD_W_SEQ='001' AND DELIV_TM_CLS_CD IN('25','30','80')) AS DELIV_TM_CLS_CD
              , (SELECT TA.RGLR_DELIV_YN
                 FROM ADM.TITEMADD TA
                 WHERE TA.ITEM_CD = A.ITEM_CD) AS RGLR_DELIV_YN
              , NVL((SELECT MAX(RO.ORD_SCHD_NO)
                     FROM ADM.TRGLR_PAY_ORD_SCHD RO
                     WHERE RO.ORD_NO = A.ORD_NO),0) AS ORD_SCHD_NO
              , CASE WHEN (SELECT 1 FROM ADM.TCBCODE X WHERE X.LGRP_CD='W210' AND X.MGRP_CD=I.ITEM_TYPE_CD AND ROWNUM=1)=1 AND
                                (SELECT 1 FROM MALLOWN.TORDER_VEN_KEY Y WHERE Y.CUST_NO=A.CUST_NO AND Y.CUST_VEN_CD='04' AND Y.USE_YN='1' AND Y.INS_DTM>=ADD_MONTHS(SYSDATE,-12) AND ROWNUM=1)=1
                     THEN (SELECT ORD.PKG_SECURITY.F_COMMON_DE(VEN_KEY_INFO1) FROM MALLOWN.TORDER_VEN_KEY Y WHERE Y.CUST_NO=A.CUST_NO AND Y.CUST_VEN_CD='04' AND Y.USE_YN='1' AND Y.INS_DTM>=ADD_MONTHS(SYSDATE,-12) AND ROWNUM=1)
                     ELSE (SELECT 'P*************' FROM ADM.TORDERETC Z WHERE Z.ORD_NO=A.ORD_NO AND Z.ORD_G_SEQ=A.ORD_G_SEQ AND Z.CLS_CD='080' AND ROWNUM=1)
                     END AS P_UNI_PASS
              , (SELECT AFTPROC_CNCL_YN
                 FROM ADM.TITEMADD X
                 WHERE X.ITEM_CD=I.ITEM_CD
                 AND ROWNUM=1) AS AFT_CNCL_YN
              , (SELECT X.AFTPROC_RST_CD
                 FROM ADM.TORDAFTCNCL X
                 WHERE X.ORD_NO=A.ORD_NO
                 AND X.ORD_G_SEQ=A.ORD_G_SEQ
                 AND X.AFTPROC_CNCL_DTL_SEQ=(SELECT MAX(Y.AFTPROC_CNCL_DTL_SEQ)
                                             FROM ADM.TORDAFTCNCL Y
                                             WHERE Y.ORD_NO=X.ORD_NO
                                             AND Y.ORD_G_SEQ=X.ORD_G_SEQ
                                             AND Y.ORD_D_SEQ=X.ORD_D_SEQ
                                             AND Y.ORD_W_SEQ=X.ORD_W_SEQ)
                 AND ROWNUM=1) AS AFT_CNCL_PROG
        FROM    ADM.TORDERITEM A
              , ADM.TITEM      I
              , ADM.TRESTRICTORDER R
              , ADM.TORDER     O
        WHERE   A.CUST_NO   = #{custNo}
        AND     A.ORD_DTM between TO_DATE(#{orDateFr} || ' 000000', 'YYYYMMDD HH24MISS') AND TO_DATE(#{orDateTo} || ' 235959', 'YYYYMMDD HH24MISS')
        AND     (  (#{itemCd} = '%' ) or (#{itemCd} != '%' and A.ITEM_CD = #{itemCd}) )
        AND     (  (#{ordNo}  = '%' ) or (#{ordNo}  != '%' and A.ORD_NO  = #{ordNo})  )
        AND     I.ITEM_NM like #{itemNm}
        AND     A.ITEM_CD   = I.ITEM_CD
        AND     A.CUST_NO   = R.CUST_NO (+)
        AND     A.ORD_NO    = R.ORD_NO (+)
        