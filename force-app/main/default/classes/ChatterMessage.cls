/**
 * @description       : 
 * @author            : Bekhzod Ubaydullaev
 * @group             : 
 * @last modified on  : 09-13-2022
 * @last modified by  : Bekhzod Ubaydullaev
**/
public class ChatterMessage {
    ConnectApi.FeedItemInput feedItemInput;
    ConnectApi.MessageBodyInput messageBodyInput;
    ConnectApi.TextSegmentInput textSegmentInput;
    ConnectApi.MentionSegmentInput mentionSegmentInput;

    public ChatterMessage() {
        this.feedItemInput = new ConnectApi.FeedItemInput();
        this.messageBodyInput = new ConnectApi.MessageBodyInput();
        this.textSegmentInput = new ConnectApi.TextSegmentInput();
        this.mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        this.messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    }

    public void sendMessage(ChatterType enumType, String targetId, String params ){
        messageSetup(enumType, params);
        sendTo(targetId);
    }

    public void sendMessageWithMention(ChatterType enumType, String targetId, String params, String mentionUserId){   
        this.mentionSegmentInput.id = mentionUserId;
        this.messageBodyInput.messageSegments.add(this.mentionSegmentInput);

        messageSetup(enumType, params);
        sendTo(targetId);
    }

    private void messageSetup(ChatterType enumType, String params){
        String textMessage = textByType(enumType, params);
        this.textSegmentInput.text = textMessage;
        this.messageBodyInput.messageSegments.add(this.textSegmentInput);
    }   

    private String textByType(ChatterType enumType, String params){
        return 'Some text based on enumType';
    }

    private void sendTo(String targetId){
        this.feedItemInput.body = this.messageBodyInput;
        this.feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        this.feedItemInput.subjectId = targetId;
        try{
            ConnectApi.ChatterFeeds.postFeedElement(null, this.feedItemInput);
        }catch(Exception e){
            System.debug(e);
        }
    }
}