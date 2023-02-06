/**
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_sc implements Schedulable{
    /*
    String sch = '0 0 1 * * ?'; // every day at 1 AM
    String jobID = System.schedule('Migration Batch (every 1:00 am)', sch, new EXEC_sc());
    */
    public void execute(SchedulableContext ctx) {
        // Class 를 직접 기술하면 스케줄이 등록되어있는 동안 관련된 파일들을 수정하지 못한다.
        // 이를 우회하기 위해 interface 를 이용한다.

        System.Type kScheduleLauncherType = Type.forName('EXEC_ScheduleLauncher_sc');
        Schedulable kScheduleLauncher = (Schedulable)kScheduleLauncherType.newInstance();
        kScheduleLauncher.execute(ctx);
    }
}