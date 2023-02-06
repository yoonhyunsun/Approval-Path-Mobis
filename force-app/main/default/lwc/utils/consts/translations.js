import AP_CHANGE_APPROVER from "@salesforce/label/c.AP_CHANGE_APPROVER";
import COM_BTN_CANCEL from "@salesforce/label/c.COM_BTN_CANCEL";
import COM_BTN_SAVE from "@salesforce/label/c.COM_BTN_SAVE";
import COM_BTN_REFRESH from "@salesforce/label/c.COM_BTN_REFRESH";
import COM_BTN_OK from "@salesforce/label/c.COM_BTN_OK";
import AP_DEPARTMENT from "@salesforce/label/c.AP_DEPARTMENT";
import AP_NAME from "@salesforce/label/c.AP_NAME";
import AP_SAVE_AS_FAVORITE from "@salesforce/label/c.AP_SAVE_AS_FAVORITE";
import AP_SELECT_FROM_FAVORITE from "@salesforce/label/c.AP_SELECT_FROM_FAVORITE";
import COM_BTN_SEARCH from "@salesforce/label/c.COM_BTN_SEARCH";
import AP_POSITION from "@salesforce/label/c.AP_POSITION";
import AP_SELECTED_EMPLOYEE from "@salesforce/label/c.AP_SELECTED_EMPLOYEE";
import AP_APPROVAL_TYPE from "@salesforce/label/c.AP_APPROVAL_TYPE";
import ERR_IN_PROGRESS_APPROVAL from "@salesforce/label/c.ERR_IN_PROGRESS_APPROVAL";
import ERR_PERMITION_EDIT from "@salesforce/label/c.ERR_PERMITION_EDIT";
import SUCC_SAVE_RECORD from "@salesforce/label/c.SUCC_SAVE_RECORD";
import ERR_ENTER_S_CODE from "@salesforce/label/c.ERR_ENTER_S_CODE";
import ERR_UPDATE_PML from "@salesforce/label/c.ERR_UPDATE_PML";
import LOAD_QUIP_DOC from "@salesforce/label/c.LOAD_QUIP_DOC";
import AP_SUBMIT_APPROVAL from "@salesforce/label/c.AP_SUBMIT_APPROVAL";
import AP_REQUEST_REPORT from "@salesforce/label/c.AP_REQUEST_REPORT";
import AP_PROCESS_PATH from "@salesforce/label/c.AP_PROCESS_PATH";
import AP_PROCESS_PATHS from "@salesforce/label/c.AP_PROCESS_PATHS";
import AP_COMMENT from "@salesforce/label/c.AP_COMMENT";
import AP_RULE_DOCUMENT from "@salesforce/label/c.AP_RULE_DOCUMENT";
import ERR_CANT_APPROVE_YET from "@salesforce/label/c.ERR_CANT_APPROVE_YET";
import ERR_NOT_APPROVER from "@salesforce/label/c.ERR_NOT_APPROVER";
import ERR_PROCESSED_APPROVAL from "@salesforce/label/c.ERR_PROCESSED_APPROVAL";
import SUCC_APPROVE from "@salesforce/label/c.SUCC_APPROVE";
import SUCC_REJECT from "@salesforce/label/c.SUCC_REJECT";
import AP_APPROVAL_PROCESSES from "@salesforce/label/c.AP_APPROVAL_PROCESSES";
import HELPER_TEXT_CANCELLED from "@salesforce/label/c.HELPER_TEXT_CANCELLED";
import HELPER_TEXT_CLOSED_LOST from "@salesforce/label/c.HELPER_TEXT_CLOSED_LOST";
import HELPER_TEXT_CLOSED_WON from "@salesforce/label/c.HELPER_TEXT_CLOSED_WON";
import ERR_RFQ_SECTION_NOT_FILLED from "@salesforce/label/c.ERR_RFQ_SECTION_NOT_FILLED";
import ERR_APPROVAL_CANCELLED from "@salesforce/label/c.ERR_APPROVAL_CANCELLED";
import ZOOM_IN from "@salesforce/label/c.ZOOM_IN";
import ZOOM_OUT from "@salesforce/label/c.ZOOM_OUT";
import OPEN_MODAL from "@salesforce/label/c.OPEN_MODAL";

const COM_BTN = {
  COM_BTN_SAVE,
  COM_BTN_CANCEL,
  COM_BTN_SEARCH,
  COM_BTN_REFRESH,
  COM_BTN_OK
};

const APPROVAL_PROCESS = {
  AP_CHANGE_APPROVER,
  AP_DEPARTMENT,
  AP_NAME,
  AP_SAVE_AS_FAVORITE,
  AP_SELECT_FROM_FAVORITE,
  AP_POSITION,
  AP_SELECTED_EMPLOYEE,
  AP_APPROVAL_TYPE,
  AP_SUBMIT_APPROVAL,
  AP_REQUEST_REPORT,
  AP_PROCESS_PATH,
  AP_PROCESS_PATHS,
  AP_COMMENT,
  AP_RULE_DOCUMENT,
  AP_APPROVAL_PROCESSES
};

const ERR_MESSAGES = {
  ERR_IN_PROGRESS_APPROVAL,
  ERR_PERMITION_EDIT,
  ERR_ENTER_S_CODE,
  ERR_UPDATE_PML,
  ERR_CANT_APPROVE_YET,
  ERR_NOT_APPROVER,
  ERR_PROCESSED_APPROVAL,
  ERR_RFQ_SECTION_NOT_FILLED,
  ERR_APPROVAL_CANCELLED
};

const SUCC_MESSAGES = {
  SUCC_SAVE_RECORD,
  SUCC_APPROVE,
  SUCC_REJECT
};

const LOADING_MESSAGES = {
  LOAD_QUIP_DOC
};

const HELPERT_TEXT = {
  HELPER_TEXT_CANCELLED,
  HELPER_TEXT_CLOSED_LOST,
  HELPER_TEXT_CLOSED_WON
};

const PDF_VIEW = {
  ZOOM_IN,
  ZOOM_OUT,
  OPEN_MODAL
};

export const translations = {
  ...COM_BTN,
  ...APPROVAL_PROCESS,
  ...ERR_MESSAGES,
  ...SUCC_MESSAGES,
  ...LOADING_MESSAGES,
  ...HELPERT_TEXT,
  ...PDF_VIEW
};