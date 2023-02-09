import { LightningElement, api } from "lwc";
import { subscribe, unsubscribe } from "lightning/empApi";
import currentUserId from "@salesforce/user/Id";
import checkIfIsLatestApproval from "@salesforce/apex/QuipController.checkIfIsLatestApproval";
import getOpptyCurrentStage from "@salesforce/apex/QuipController.getOpptyCurrentStage";
import getOwnerAndTeamMemberIds from "@salesforce/apex/QuipController.getOwnerAndTeamMemberIds";
import unlockQuip from "@salesforce/apex/QuipController.unlockQuip";
import checkIfNoCreatedOrInProgressApproval from "@salesforce/apex/QuipController.checkIfNoCreatedOrInProgressApproval";
import getLastReplayId from "@salesforce/apex/QuipController.getLastReplayId";
import { updateRecord } from "lightning/uiRecordApi";
import LAST_REPLAY_ID from "@salesforce/schema/Opportunity.LastReplayId__c";
import ID_FIELD from "@salesforce/schema/Opportunity.Id";

import { proxyToObj, updateOpportunity } from "c/utils";
export default class OpportunityEventListener extends LightningElement {
  @api recordId;

  channelName = "/event/Approval_Process__e";
  subscription = null;
  currStage;
  userList;
  latestApproval;
  noCreatedOrProgress;
  lastReplayId;
  alreadySubscribed = false;

  async updateOpportunityReplayId(recordId, lastReplay) {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = recordId;
    fields[LAST_REPLAY_ID.fieldApiName] = lastReplay;

    await updateRecord({ fields });
  }

  async connectedCallback() {
    this.lastReplayId =
      Math.floor(await getLastReplayId({ opportunityId: this.recordId })) - 1;
    await this.handleSubscribe();
    if (!this.alreadySubscribed) {
      await this.handleSubscribe2();
    }
  }

  disconnectedCallback() {
    this.handleUnsubscribe();
  }

  async handleSubscribe2() {
    const logicCallback = async (response) => {
      console.log("inside");
      let data = proxyToObj(response).data;

      this.currStage = await getOpptyCurrentStage({
        opportunityId: this.recordId
      });
      this.noCreatedOrProgress = await checkIfNoCreatedOrInProgressApproval({
        opportunityId: this.recordId
      });

      if (
        this.recordId === data.payload.opptyId__c &&
        this.currStage === data.payload.opptyStage__c &&
        currentUserId === data.payload.userId__c &&
        this.noCreatedOrProgress &&
        data.payload.type__c === "DRAFT"
      ) {
        console.log("before update");
        await updateOpportunity(data.payload.opptyId__c, "Draft");
      }
      console.log(data);
      console.log("curr user " + currentUserId);

      if (
        this.recordId === data.payload.opptyId__c &&
        data.payload.type__c === "REJECT"
      ) {
        this.userList = await getOwnerAndTeamMemberIds({
          approvalId: data.payload.approvalid__c
        });
        this.latestApproval = await checkIfIsLatestApproval({
          approvalId: data.payload.approvalid__c
        });

        if (
          this.currStage === data.payload.opptyStage__c &&
          this.userList.includes(currentUserId) &&
          this.latestApproval &&
          data.payload.quipDocUrl__c &&
          this.noCreatedOrProgress
        ) {
          try {
            console.log("before request");
            await unlockQuip({ quipUrl: data.payload.quipDocUrl__c });
          } catch (e) {
            console.log(e.getMessage());
          }
        }
      }
      if (data.event.replayId > this.lastReplayId + 1) {
        await this.updateOpportunityReplayId(
          this.recordId,
          data.event.replayId
        );
      }
    };
    this.subscription = await subscribe(
      this.channelName,
      this.lastReplayId,
      logicCallback
    );
  }

  async handleSubscribe() {
    const logicCallback = async (response) => {
      console.log("inside");
      let data = proxyToObj(response).data;

      if (this.lastReplayId + 1 <= data.event.replayId) {
        this.alreadySubscribed = true;
      }

      this.currStage = await getOpptyCurrentStage({
        opportunityId: this.recordId
      });
      this.noCreatedOrProgress = await checkIfNoCreatedOrInProgressApproval({
        opportunityId: this.recordId
      });

      if (
        this.recordId === data.payload.opptyId__c &&
        this.currStage === data.payload.opptyStage__c &&
        currentUserId === data.payload.userId__c &&
        this.noCreatedOrProgress &&
        data.payload.type__c === "DRAFT"
      ) {
        console.log("before update");
        await updateOpportunity(data.payload.opptyId__c, "Draft");
      }
      console.log(data);
      console.log("curr user " + currentUserId);

      if (
        this.recordId === data.payload.opptyId__c &&
        data.payload.type__c === "REJECT"
      ) {
        this.userList = await getOwnerAndTeamMemberIds({
          approvalId: data.payload.approvalid__c
        });
        this.latestApproval = await checkIfIsLatestApproval({
          approvalId: data.payload.approvalid__c
        });

        if (
          this.currStage === data.payload.opptyStage__c &&
          this.userList.includes(currentUserId) &&
          this.latestApproval &&
          data.payload.quipDocUrl__c &&
          this.noCreatedOrProgress
        ) {
          try {
            console.log("before request");
            await unlockQuip({ quipUrl: data.payload.quipDocUrl__c });
          } catch (e) {
            console.log(e.getMessage());
          }
        }
      }
      if (data.event.replayId > this.lastReplayId + 1) {
        await this.updateOpportunityReplayId(
          this.recordId,
          data.event.replayId
        );
      }
    };
    this.subscription = await subscribe(this.channelName, -1, logicCallback);
  }

  handleUnsubscribe() {
    unsubscribe(this.subscription, (response) => {
      console.log("Unsubscribe: ", JSON.stringify(response));
    });
  }
}