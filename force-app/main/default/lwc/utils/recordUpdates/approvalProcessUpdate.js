import { updateRecord } from "lightning/uiRecordApi";
import ApprovalStatus from "@salesforce/schema/ApprovalProcess__c.ApprovalStatus__c";
import ID_FIELD from "@salesforce/schema/ApprovalProcess__c.Id";

export const updateApprovalProcess = async (recordId, processStatus) => {
  const fields = {};
  fields[ID_FIELD.fieldApiName] = recordId;
  fields[ApprovalStatus.fieldApiName] = processStatus;

  await updateRecord({ fields });
};