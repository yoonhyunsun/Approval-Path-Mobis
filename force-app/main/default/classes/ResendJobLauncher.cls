public class ResendJobLauncher implements Schedulable{

    public void execute(SchedulableContext sc) {
        ResendEmailAndNotificationToApprovers job = new ResendEmailAndNotificationToApprovers();
        CronTrigger ct = [Select Id, CronJobDetail.Name FROM CronTrigger WHERE Id = :sc.getTriggerId()];

        String appId = ct.CronJobDetail.Name.removeStartIgnoreCase('Resend Email To APP ');

        job.resendEmailAndNotification(appId);
    }
}