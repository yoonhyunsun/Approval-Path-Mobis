/**
 * Created by hyodongmin on 2022/08/09.
 */

@IsTest
private class IF_FACTORY_ts {
    @IsTest
    static void testGetInboundIf() {
        System.assertEquals(null, IF_FACTORY.getInterfaceInbound(null));
        System.assertEquals(null, IF_FACTORY.getInterfaceInbound(''));
        System.assertEquals(null, IF_FACTORY.getInterfaceInbound(' '));
        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_IM_SFDC_HRMASTER) instanceof IF_IM_SFDC_HRMASTER);
        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_IM_SFDC_ORGMASTER) instanceof IF_IM_SFDC_ORGMASTER);
        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_ERP_SFDC_SALES) instanceof IF_ERP_SFDC_SALES);
        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_ERP_SFDC_OUTPRICE) instanceof IF_ERP_SFDC_OUTPRICE);
        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_ERP_SFDC_EXCHANGE_RATE) instanceof IF_ERP_SFDC_EXCHANGE_RATE);
        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_BATCH_START) instanceof IF_BATCH_START);
//        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_PMS_SFDC_PROJECT) instanceof IF_PMS_SFDC_PROJECT);
//        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_PMS_SFDC_OPPORTUNITY) instanceof IF_PMS_SFDC_OPPORTUNITY);
//        System.assertEquals(true, IF_FACTORY.getInterfaceInbound(IF_FACTORY.IF_MSIS_SFDC_EXCHANGE_RATE1) instanceof IF_MSIS_SFDC_EXCHANGE_RATE1);
    }
}