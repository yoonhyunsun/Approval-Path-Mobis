const makeDisabled = (contacts) =>
  contacts.map((el) => ({ ...el, disabled: true }));

export const filterSubmittedContactsByGroup = (submittedContacts) => {
  if (submittedContacts.length === 0) return [];

  const previousGroup = submittedContacts.filter(
    (el) => el.ApprovalProcess__r.CurrentGroupNumber__c > el.NotifiedGroup__c
  );

  const currentGroup = submittedContacts.filter(
    (el) => el.ApprovalProcess__r.CurrentGroupNumber__c === el.NotifiedGroup__c
  );

  const nextGroup = submittedContacts.filter(
    (el) => el.ApprovalProcess__r.CurrentGroupNumber__c < el.NotifiedGroup__c
  );

  const currentGroupApproved = currentGroup.filter(
    (el) =>
      el.ApprovalStatus__c === "Approved" ||
      (el.ApprovalType__c === "Reference" && el.ApprovalStatus__c === "Read")
  );

  const currentGroupNotApproved = currentGroup.filter(
    (el) =>
      (el.ApprovalType__c !== "Reference" &&
        el.ApprovalStatus__c !== "Approved") ||
      (el.ApprovalType__c === "Reference" && el.ApprovalStatus__c !== "Read")
  );

  return [
    ...makeDisabled(previousGroup),
    ...makeDisabled(currentGroupApproved),
    ...currentGroupNotApproved,
    ...nextGroup
  ];
};