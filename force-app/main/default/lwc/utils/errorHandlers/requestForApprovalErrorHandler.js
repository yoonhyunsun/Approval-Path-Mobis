import getOpportunityRecordAccess from "@salesforce/apex/OpportunityController.getOpportunityRecordAccess";
import opportunityHasInProgressApprovalProcess from "@salesforce/apex/OpportunityController.opportunityHasInProgressApprovalProcess";
import opportunityRfqSectionFilled from "@salesforce/apex/OpportunityController.opportunityRfqSectionFilled";
import getUserProfile from "@salesforce/apex/OpportunityController.getUserProfile"
import { errorToast, translations } from "c/utils";

export const requestForApprovalErrorHandler = async (component) => {
  const access = await getOpportunityRecordAccess({
    opportunityId: component.recordId
  });

  if (!access.HasEditAccess) {
    component.dispatchEvent(errorToast(translations.ERR_PERMITION_EDIT));

    return true;
  }

  const hasInProgressApprovalProcess =
    await opportunityHasInProgressApprovalProcess({
      opportunityId: component.recordId
    });

  if (hasInProgressApprovalProcess) {
    component.dispatchEvent(errorToast(translations.ERR_IN_PROGRESS_APPROVAL));

    return true;
  }

  const rfqSectionFilled = await opportunityRfqSectionFilled({
    opportunityId: component.recordId
  });

  const profileName = await getUserProfile({
    opportunityId: component.recordId
  });

  console.profile('유저 프로필 : ' + profileName);
  if (!rfqSectionFilled && (profileName != 'System Administrator' && profileName != 'System Admin')) {
    component.dispatchEvent(
      errorToast(translations.ERR_RFQ_SECTION_NOT_FILLED)
    );

    return true;
  }

  return false;
};