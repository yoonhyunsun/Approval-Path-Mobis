/**
 * EXEC_IChain 을 구현한 객체에서 필요한 기능 수행과 데이터 제공을 대행하는 클래스
 *
 * Created by hyodongmin on 2022/08/23.
 */

public virtual with sharing class EXEC_Delegate {

    /**
     * @param aChainName EXEC_Manager 정의된 체인 이름
     *
     * @return EXEC_Manager.IChainCallout 구현 객체
     */
    public virtual EXEC_Manager.IChainCallout getWebCallout(String aChainName) {
        return EXEC_Factory.getWebCallout(aChainName);
    }

    /**
     * @param aChainName EXEC_Manager 정의된 체인 이름
     *
     * @return Database.Batchable<SObject> 구현 객체
     */
    public virtual Database.Batchable<SObject> getBatch(String aChainName) {
        return EXEC_Factory.getBatch(aChainName);
    }

    /**
     * @param aChainName EXEC_Manager 정의된 체인 이름
     *
     * @return EXEC_Manager.IChainLog 구현 객체
     */
    public virtual EXEC_Manager.ChainLog getLog(String aChainName) {
        return EXEC_Factory.getLog(aChainName);
    }

    /**
     * @param aChains 체인 실행 순서대로 나열된 이름 배열, EXEC_Manager.getChains() 를 이용하면 된다.
     * @param aCurrentChainName 현재 실행 중인 체인 이름, 다음 체인을 추출하기위해 제공.
     *
     * @return 다음 실행할 EXEC_IChain 객체
     */
    public virtual EXEC_IChain nextChain(List<String> aChains, String aCurrentChainName) {
        return EXEC_Manager.nextChain(aChains, aCurrentChainName);
    }

    /**
     * System.enqueueJob(aQueueable);
     *
     * @param aQueueable Queueable
     *
     * @return Job Id
     */
    public virtual Id enqueueJob(Queueable aQueueable) {
        if (IF_Static.isChainEnabled()) {
            return System.enqueueJob(aQueueable);
        }
        logChainStop();
        return null;
    }

    private static void logChainStop() {
        System.debug('Custom settings "chain_enabled" == false. Stop chain job.');
    }

    /**
     * Database.executeBatch(batchable);
     *
     * @param batchable Database.Batchable<SObject>
     *
     * @return Job Id
     */
    public virtual Id executeBatch(Database.Batchable<SObject> batchable) {
        if (IF_Static.isChainEnabled()) {
            return Database.executeBatch(batchable, 1000);
        }
        logChainStop();
        return null;
    }

    /**
     * System.enqueueJob(aQueueable);
     *
     * @param aQueueable Queueable
     *
     * @return Job Id
     */
    public virtual Id repeat(Queueable aQueueable) {
        if (IF_Static.isChainEnabled()) {
            return System.enqueueJob(aQueueable);
        }
        logChainStop();
        return null;
    }
}