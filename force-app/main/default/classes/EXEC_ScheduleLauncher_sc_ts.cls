/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_ScheduleLauncher_sc_ts {
    @IsTest
    static void testBehavior() {
        // 실제 체인이 실행되는 것을 막기위해 null 로 설정한다.
        EXEC_Manager.replaceChains(new List<String>{ null });
        Schedulable schedulable = new EXEC_ScheduleLauncher_sc();
        schedulable.execute(null);  // for coverage
    }
}