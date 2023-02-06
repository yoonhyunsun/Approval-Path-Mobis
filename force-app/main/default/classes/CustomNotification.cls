/**
 * @description       : 
 * @author            : Bekhzod Ubaydullaev
 * @group             : 
 * @last modified on  : 09-19-2022
 * @last modified by  : Bekhzod Ubaydullaev
**/
public class CustomNotification {
    private static Messaging.CustomNotification notification;
    static{
        notification = new Messaging.CustomNotification();
        try{
            CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Notify_User_Quip'];

            notification.setNotificationTypeId(notificationType.Id);
        }catch(Exception e){
            System.debug(e);
        }
    }
    private static String setCustomTitle(ChatterType enumType, String senderName){
        return senderName+ ' is requesting approval for approval process';
    }

    private static String setCustomBody(ChatterType enumType, String params){
        return 'Content based on params and enum';
    }

    private static void sendTo(Set<String> Ids){
        try {
            notification.send(Ids);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

    private static void setupNotification(ChatterType enumType, String senderName, String targetId, String params){
        String title = setCustomTitle(enumType, senderName);
        notification.setTitle(title);
        String body = setCustomBody(enumType, params);
        notification.setBody(body);
        notification.setTargetId(targetId);
    }

    public static void notifyUser(ChatterType enumType, Map<NotificationParameters, String> params, String receiverId){
        setupNotification(enumType, UserInfo.getName(),
            params.get(NotificationParameters.TARGET_ID),
            params.get(NotificationParameters.PARAMS));
        sendTo(new Set<String>{receiverId});
    }

    public static void notifyManyUsers(ChatterType enumType, Map<NotificationParameters, String> params, Set<String> receiverIds){
        setupNotification(enumType, UserInfo.getName(), 
            params.get(NotificationParameters.TARGET_ID), 
            params.get(NotificationParameters.PARAMS));
        sendTo(receiverIds);
    }
}