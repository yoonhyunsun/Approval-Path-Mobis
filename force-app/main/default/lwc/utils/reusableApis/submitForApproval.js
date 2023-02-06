import submitApprovalProcess from "@salesforce/apex/ApprovalProcessController.submitApprovalProcess";
import {
  errorToast,
  successToast,
  enumerate,
  proxyToObj,
  updateOpportunity
} from "c/utils";
import PromptModal from "c/promptModal";
import createApprovalProcessPathes from "@salesforce/apex/ApprovalProcessPathController.createApprovalProcessPathes";

export const submitForApproval = async (component) => {
  const result = await PromptModal.open({
    size: "small",
    description: "Accessible description of modal's purpose",
    title: "Submit For Approval",
    content: "Are you requesting the approval?"
  });

  if (!result) {
    throw new Error("submit for approval closed");
  }

  try {
    await createApprovalProcessPathes({
      OpportunityId: component.recordId,
      Comment: component.comment,
      approvalProcessPathes: enumerate([
        ...proxyToObj(component.selectedContacts)
      ])
    });
  } catch (e) {
    component.dispatchEvent(errorToast(e.body.message));

    throw e;
  }

  try {
    let notallref = await submitApprovalProcess({
      OpportunityId: component.recordId
    });

    if (notallref) {
      await updateOpportunity(component.recordId, "Process Submitted");
    } else {
      await updateOpportunity(component.recordId, "Draft");
    }

    component.dispatchEvent(
      successToast("Approval process has been submitted successfully")
    );

    const selectedEvent = new CustomEvent("submitsuccess");
    component.dispatchEvent(selectedEvent);
  } catch (e) {
    component.dispatchEvent(errorToast(e.body.message));
  }
};