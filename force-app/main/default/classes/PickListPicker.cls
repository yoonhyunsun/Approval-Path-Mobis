/**
 * @description       :
 * @author            : https://github.com/Eldor901
 * @group             :
 * @last modified on  : 09-16-2022
 * @last modified by  : https://github.com/Eldor901
 **/
public class PickListPicker {
  private static List<PicklistDTO> pickListToMap(
    List<Schema.PicklistEntry> picklists
  ) {
    List<PicklistDTO> picklistObjects = new List<PicklistDTO>();

    for (Schema.PicklistEntry pickListVal : picklists) {
      PicklistDTO picklistObject = new PicklistDTO();
      picklistObject.label = pickListVal.getLabel();
      picklistObject.value = pickListVal.getValue();

      picklistObjects.add(picklistObject);
    }

    return picklistObjects;
  }
}