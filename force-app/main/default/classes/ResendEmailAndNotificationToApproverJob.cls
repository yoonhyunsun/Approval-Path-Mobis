public class ResendEmailAndNotificationToApproverJob implements Schedulable {

    public void execute(SchedulableContext ctx) {
        System.Type resendScheduleLauncherType = Type.forName('ResendJobLauncher');

        Schedulable resendScheduleLauncher = (Schedulable)resendScheduleLauncherType.newInstance();

        resendScheduleLauncher.execute(ctx);
    }
}