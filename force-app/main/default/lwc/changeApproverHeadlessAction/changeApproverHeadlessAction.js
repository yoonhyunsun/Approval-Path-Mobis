/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
import getOpportunityRecordAccess from "@salesforce/apex/OpportunityController.getOpportunityRecordAccess";
import opportunityRfqSectionFilled from "@salesforce/apex/OpportunityController.opportunityRfqSectionFilled";
import getGeneralApprovalUser from "@salesforce/apex/OpportunityController.getGeneralApprovalUser";
import getUserProfile from "@salesforce/apex/OpportunityController.getUserProfile";
import ChangeApproverModal from "c/changeApproverModal";
import { errorToast, translations } from "c/utils";
import { api, LightningElement } from "lwc";

export default class ChangeApproverHeadlessAction extends LightningElement {
  @api recordId;

  @api async invoke() {
    const access = await getOpportunityRecordAccess({
      opportunityId: this.recordId
    });

    const generalApprovalType = await getGeneralApprovalUser({
      opportunityId: this.recordId
    });
    
    console.log('generalApprovalType : '+ generalApprovalType);

    if (!access.HasEditAccess && generalApprovalType == false) {
      this.dispatchEvent(errorToast(translations.ERR_PERMITION_EDIT));

      return;
    }

    const rfqSectionFilled = await opportunityRfqSectionFilled({
      opportunityId: this.recordId
    });

    const profileName = await getUserProfile({
      opportunityId: this.recordId
    });

    console.profile('유저 프로필 : ' + profileName);
    if (!rfqSectionFilled && (profileName != 'System Administrator' && profileName != 'System Admin')) {
      this.dispatchEvent(errorToast(translations.ERR_RFQ_SECTION_NOT_FILLED));

      return;
    }

    await ChangeApproverModal.open({
      label: "Modal Header",
      recordId: this.recordId,
      size: "large"
    });
  }
}