public Parameters inquireTakeOutwCustRecvBeNotYetProcessPresentState(Parameters inParams) {
        Parameters outParams = ParametersFactory.createParameters(inParams);
 
        // 지시 일자별 기준
        outParams.setFrameOneDataset("ds_date",
                getSqlManager().queryForFrameOneDataset(inParams, "orderDetail.inquireTakeOutwCustRecvBeNotYetProcessPresentStateWbCrtDt"));
        // 배송 예정일자별 기준
        outParams.setFrameOneDataset("ds_delivery",
                getSqlManager().queryForFrameOneDataset(inParams, "orderDetail.inquireTakeOutwCustRecvBeNotYetProcessPresentStateDelivPlanDt"));
 
        outParams.setStatusMessage("MSG_COM_SUC_011");
 
        return outParams;
    }


    