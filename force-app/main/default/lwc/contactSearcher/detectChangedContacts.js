const isChanged = (newContact, submittedContact) => {
  if (!newContact || !submittedContact) return false;

  if (newContact?.ApprovalPathId === undefined) return false;

  if (
    newContact.ApprovalType === submittedContact.ApprovalType &&
    newContact?.ApprovalPathId === submittedContact?.ApprovalPathId
  )
    return false;

  return true;
};

export const detectChangedContacts = (newContacts, submittedContacts) => {
  for (let i = 0; i < newContacts.length; i++) {
    const contactIsChanged = isChanged(newContacts[i], submittedContacts[i]);
    newContacts[i].isChanged = contactIsChanged;
  }

  return newContacts;
};