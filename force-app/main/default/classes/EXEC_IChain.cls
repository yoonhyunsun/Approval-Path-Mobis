/**
 * Queue 와 Batch 를 일련의 과정으로 묶도록 Interface 를 정의
 *
 * Created by hyodongmin on 2022/08/23.
 */

public interface EXEC_IChain {
    /**
     * 해당 작업 실행
     *
     * @param aContext EXEC_ChainContext
     * @return Id
     */
    Id startChain(EXEC_ChainContext aContext);

    /**
     * 체인 이름 반환
     *
     * @return 체인 이름
     */
    String getChainName();
}