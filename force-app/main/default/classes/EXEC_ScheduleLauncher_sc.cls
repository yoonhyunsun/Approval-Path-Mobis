/**
 * 구현 객체를 직접 Schedule 에 등록하면 관련된 class 를 deploy 할 수 없다.
 * 이를 우회하기위해 구현 객체를 Interface 로 감싸고 System.Type.newInstance() 를 이용해서 생성한다.
 *
 * Created by hyodongmin on 2022/08/23.
 */

public with sharing class EXEC_ScheduleLauncher_sc implements Schedulable {

    public void execute(SchedulableContext ctx) {
        // 스케줄 작업 시작
        EXEC_ChainContext kContext = new EXEC_ChainContext();
        kContext.enableEmailSending = true;
        EXEC_Manager.first().startChain(kContext);
    }
}