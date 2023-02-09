/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 02-07-2023
 * @last modified by  : Bekhzod Ubaydullaev
 **/
public without sharing class QuipAPI {
  @SuppressWarnings('PMD.ApexCRUDViolation')
  @future(callout=true)
  public static void lockThread(String quipUrl, Boolean lock) {
    lockThreadSynchronous(quipUrl, lock);
  }

  @SuppressWarnings('PMD.ApexCRUDViolation')
  public static void lockThreadSynchronous(String quipUrl, Boolean lock) {
    String threadId = idFromUrl(quipUrl);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:quip_secured/1/threads/lock-edits?thread_id=' +
      threadId +
      '&edits_disabled=' +
      lock
    );
    request.setMethod('POST');
    HttpResponse response = http.send(request);
  }

  @SuppressWarnings('PMD.ApexCRUDViolation')
  public static QuipDTO checkDocUpdate(QuipDTO quipDto) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:quip_secured/2/threads/' + quipDto.threadId);
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    return checkResponseBody(quipDto, response.getBody());
  }

  @SuppressWarnings('PMD.ApexCRUDViolation')
  public static QuipDTO createPdfRequest(QuipDTO quipDto, String opptyId) {
    String params = setPostQueryParameters(opptyId);

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:quip_secured/1/threads/' +
      quipDto.threadId +
      '/export/pdf/async' +
      params
    );
    request.setMethod('POST');
    HttpResponse response = http.send(request);

    return checkResponseBody(quipDto, response.getBody());
  }

  @SuppressWarnings('PMD.ApexCRUDViolation')
  public static QuipDTO retrievePDF(QuipDTO quipDto) {
    String params = setGetQueryParameters(quipDto.requestId);

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:quip_secured/1/threads/' +
      quipDto.threadId +
      '/export/pdf/async' +
      params
    );
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    return checkResponseBody(quipDto, response.getBody());
  }

  public static String idFromUrl(String quipUrl) {
    String[] arr = quipUrl.split('/');
    return arr[arr.size() - 1];
  }

  private static String setPostQueryParameters(String opptyId) {
    return '?salesforce_org_id=' +
      UserInfo.getOrganizationId() +
      '&salesforce_record_id=' +
      opptyId +
      '&apply_print_options=true';
  }

  private static String setGetQueryParameters(String requestId) {
    return '?request_id=' + requestId;
  }

  public static QuipDTO checkResponseBody(QuipDTO quipDto, String jsonString) {
    if (jsonString == null) {
      quipDto.error = 'JSON Response is empty';
      return quipDto;
    }

    Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(
      jsonString
    );

    if (resp.containsKey('thread')) {
      Map<String, Object> threadInfo = (Map<String, Object>) resp.get('thread');
      if (threadInfo.containsKey('updated_usec')) {
        quipDto.lastUpdated = String.valueOf(threadInfo.get('updated_usec'));
        return quipDto;
      }
      quipDto.lastUpdated = String.valueOf(threadInfo.get('created_usec'));
      return quipDto;
    }

    if (resp.containsKey('request_id')) {
      quipDto.requestId = String.valueOf(resp.get('request_id'));
      return quipDto;
    }
    if (resp.containsKey('status')) {
      quipDto.exportPdfStatus = String.valueOf(resp.get('status'));
      return quipDto;
    }

    quipDto.error = String.valueOf(resp.get('error'));
    return quipDto;
  }

  @SuppressWarnings('PMD.ApexCRUDViolation')
  public static void addMembers(String quipUrl, Set<String> quipIds) {
    String threadId = idFromUrl(quipUrl);
    String memberIds = String.join(new List<String>(quipIds), ',').trim();
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:quip_secured/1/threads/add-members?thread_id=' +
      threadId +
      '&member_ids=' +
      memberIds
    );
    request.setMethod('POST');
    HttpResponse response = http.send(request);
  }

  @SuppressWarnings('PMD.ApexCRUDViolation')
  public static void removeMembers(String quipUrl, Set<String> quipIds) {
    String threadId = idFromUrl(quipUrl);
    String memberIds = String.join(new List<String>(quipIds), ',').trim();
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:quip_secured/1/threads/remove-members?thread_id=' +
      threadId +
      '&member_ids=' +
      memberIds
    );
    request.setMethod('POST');
    HttpResponse response = http.send(request);
  }

  @SuppressWarnings('PMD.ApexCRUDViolation') //   USER ID, EMAIL
  public static Map<String, String> getQuipId(Map<String, String> teamUserMap) {
    String emails = String.join(teamUserMap.values(), ',').trim();
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:quip_secured/1/users/?ids=' + emails);
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    return parseUserIds(response.getBody(), teamUserMap);
  }

  public static Map<String, String> parseUserIds(
    String jsonString,
    Map<String, String> teamUserMap
  ) {
    if (String.isBlank(jsonString)) {
      Map<String, String> errormap = new Map<String, String>();
      errormap.put('ERROR', 'JSON reponse with quip Ids is empty');
      return errormap;
    }
    Map<String, String> result = new Map<String, String>();
    Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(
      jsonString
    );

    for (String userId : teamUserMap.keySet()) {
      if (resp.containsKey(teamUserMap.get(userId))) {
        Map<String, Object> respInfo = (Map<String, Object>) resp.get(
          teamUserMap.get(userId)
        );
        if (respInfo.containsKey('id')) {
          result.put(userId, String.valueOf(respInfo.get('id')));
        }
      }
    }
    return result;
  }

  public static void addApproversWithAccessNumber(
    String quipUrl,
    Map<Integer, List<String>> accessQuipIdMap
  ) {
    String threadId = idFromUrl(quipUrl);

    List<String> result = new List<String>();
    for (Integer key : accessQuipIdMap.keySet()) {
      List<String> replaced = new List<String>();
      for (String value : accessQuipIdMap.get(key)) {
        replaced.add('"' + value + '"');
      }
      accessQuipIdMap.put(key, replaced);
      String access =
        '{"access_level":' +
        key +
        ',"member_ids":[' +
        String.join(accessQuipIdMap.get(key), ',') +
        ']}';
      result.add(access);
    }
    String js = '[' + String.join(result, ',') + ']';

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('threadId', threadId);
    gen.writeStringField('member_ids_by_access_level', js);
    gen.writeEndObject();
    String body = gen.getAsString();

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:quip_secured/1/threads/add-members?thread_id=' + threadId
    );
    request.setHeader('Content-Type', 'application/json');
    request.setMethod('POST');
    request.setBody(body);
    HttpResponse response = http.send(request);
    System.debug(response.getBody());
  }
}