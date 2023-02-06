/**
 * 인터페이스 팩토리
 *
 * Created by hyodongmin on 2022/08/08.
 */

public with sharing class IF_FACTORY {

    // inbound
    public static final String IF_IM_SFDC_HRMASTER = 'IF_IM_SFDC_HRMASTER';
    public static final String IF_IM_SFDC_ORGMASTER = 'IF_IM_SFDC_ORGMASTER';
    public static final String IF_IM_SFDC_HRMASTER2 = 'IF_IM_SFDC_HRMASTER2';
    public static final String IF_IM_SFDC_ORGMASTER2 = 'IF_IM_SFDC_ORGMASTER2';
    public static final String IF_ERP_SFDC_SALES = 'IF_ERP_SFDC_SALES';
    public static final String IF_ERP_SFDC_OUTPRICE = 'IF_ERP_SFDC_OUTPRICE';
    public static final String IF_ERP_SFDC_EXCHANGE_RATE = 'IF_ERP_SFDC_EXCHANGE_RATE';

    public static final String IF_BATCH_START = 'IF_BATCH_START';

    // outbound
    public static final String IF_SFDC_ONE_APPROVAL = 'IF_SFDC_ONE_APPROVAL';

    /**
     * 인터페이스 처리 객체를 반환한다.
     *
     * @param aIfId Interface ID
     *
     * @return IF_Inbound
     */
    public static IF_Inbound getInterfaceInbound(String aIfId) {
        IF_Inbound kInbound = null;
        if (IF_IM_SFDC_HRMASTER.equals(aIfId)) {
            kInbound = new IF_IM_SFDC_HRMASTER();
        } else if (IF_IM_SFDC_ORGMASTER.equals(aIfId)) {
            kInbound = new IF_IM_SFDC_ORGMASTER();
        } else if (IF_IM_SFDC_HRMASTER2.equals(aIfId)) {
            kInbound = new IF_IM_SFDC_HRMASTER2();
        } else if (IF_IM_SFDC_ORGMASTER2.equals(aIfId)) {
            kInbound = new IF_IM_SFDC_ORGMASTER2();
        } else if (IF_ERP_SFDC_SALES.equals(aIfId)) {
            kInbound = new IF_ERP_SFDC_SALES();
        } else if (IF_ERP_SFDC_OUTPRICE.equals(aIfId)) {
            kInbound = new IF_ERP_SFDC_OUTPRICE();
        } else if (IF_ERP_SFDC_EXCHANGE_RATE.equals(aIfId)) {
            kInbound = new IF_ERP_SFDC_EXCHANGE_RATE();
        } else if (IF_BATCH_START.equals(aIfId)) {
            kInbound = new IF_BATCH_START();
        }
        return kInbound;
    }
}