/**
 * Created by hyodongmin on 2022/08/23.
 */

@IsTest
private class EXEC_sc_ts {

    @IsTest
    private static void testExecute() { // NOPMD for coverage
        // 실제 체인이 실행되는 것을 막기위해 null 로 설정한다.
        EXEC_Manager.replaceChains(new List<String>{ null });
        Schedulable schedulable = new EXEC_sc();
        schedulable.execute(null);  // for coverage
    }

    @IsTest
    private static void testInstance() { // NOPMD for coverage
        System.Type kScheduleLauncherType = Type.forName('EXEC_sc');
        Schedulable kScheduleLauncher = (Schedulable)kScheduleLauncherType.newInstance();
        System.assert(kScheduleLauncher instanceof EXEC_sc);
    }
}