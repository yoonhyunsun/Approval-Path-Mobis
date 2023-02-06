import { updateRecord } from "lightning/uiRecordApi";
import QUICK_ACTION_STAGE from "@salesforce/schema/Opportunity.Quick_Action_Stage__c";
import ID_FIELD from "@salesforce/schema/Opportunity.Id";

export const updateOpportunity = async (recordId, processStatus) => {
  const fields = {};
  fields[ID_FIELD.fieldApiName] = recordId;
  fields[QUICK_ACTION_STAGE.fieldApiName] = processStatus;

  await updateRecord({ fields });
};