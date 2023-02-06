/**
 * Created by hyodongmin on 2022/08/18.
 */

public with sharing class IF_OutboundRequesterResult {
    public final String raw;
    public final Object body;
    public IF_OutboundRequesterResult(String aRaw, Object aBody) {
        raw = aRaw;
        body = aBody;
    }
}