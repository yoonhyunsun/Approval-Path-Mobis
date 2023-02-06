/****************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : lwcUfwTableFrame
 * Description  :
 * Copyright    : Copyright © 2022 I2max. All Rights Reserved.
 * Author       : I2MAX
 * Created Date : 2022-05-12
 ****************************************************************************************/
import { api, track, wire } from 'lwc';
import { LwcComBase } from 'c/lwcComBase';

export default class LwcUfwTableFrame extends LwcComBase {

    //==================================================================
    // 바로 사용하지 말고 항상 객체를 생성하여 사용할 것
    //==================================================================
    _reqData = this.ApexUtil.createSearchReqParams();

    @api pageNumber = this._reqData.pageNumber;
    @api pageSize   = this._reqData.pageSize;
    @api totalSize  = 0;
    @api recordSize = 0;
    @api scrollHeight;
    // 추가 송지훈
    @api isSimple;
    @api isNumber = false;
    pageView;

    get height() {
        return (this.PropertyUtil.isEmpty(this.scrollHeight)) ? '' : 'height:' + this.scrollHeight + 'px';
    }

    get fromOffSize() {
        return ((this.pageNumber-1)*this.pageSize) + (this.recordSize === 0 ? 0 : 1);
    }

    get toOffSize() {
        const offLen = (((this.pageNumber-1)*this.pageSize) + this.recordSize);
        return offLen >= this.totalSize ? this.totalSize : offLen;
    }

    /**
     * 페이지 길이(조회된 레코드 수)
     * @returns {number}
     */
    get pageLength() {
        return this.pageSize * this.pageNumber;
    }

    /**
     * 첫번째 페이지 여부
     * @returns {boolean}
     */
    get isFirstPage() {
        return this.pageNumber === 1;
    }

    /**
     * 마지막 페이지 여부
     * @returns {boolean}
     */
    get isLastPage() {
        return Math.ceil(this.totalSize / this.pageSize) <= this.pageNumber;
    }

    /**
     * @author jihoon
     * @returns {string}
     */
    get getVariant() {
        // TODO 어떻게 할지 생각...
        // console.log('getVariant querySelector ' + JSON.stringify(this.template.querySelector('lightning-input')?.value));
        // console.log('getVariant querySelector ' + JSON.stringify(this.template.querySelector('[data-id=pageBtn]')?.value));
        // console.log('getVariant querySelector ' + JSON.stringify(this.template.querySelectorAll('[data-id=pageBtn]')?.value));
        // this.template.querySelector(`c-lwc-ufw-dynamic-render.${clazz}`).handleRender({
        //     showComponentName, isQuickAction
        // });
        // console.log('getVariant pageView ' + this.pageView);
        // console.log('getVariant pageNumber ' + this.pageNumber);
        // return ( this.pageNumber === 1 || this.pageNumber === this.template.querySelector('[data-id=pageBtn]')?.label ) ? 'brand' : 'neutral'
        return 'brand'
    }

    /**
     * 이전 페이지 호출
     */
    handlePrevious() {
        this.pageNumber = this.pageNumber - 1;
        this.gfnComFireDispatch(this.PagingData.gComPagingEvent.prev, {
            [this.PagingData.gComReqDataParam.pageNumber]: this.pageNumber,
            [this.PagingData.gComReqDataParam.pageSize]: this.pageSize,
        });
    }

    /**
     * 다음 페이지 호출
     */
    handleNext() {
        this.pageNumber = this.pageNumber + 1;
        this.gfnComFireDispatch(this.PagingData.gComPagingEvent.next, {
            [this.PagingData.gComReqDataParam.pageNumber]: this.pageNumber,
            [this.PagingData.gComReqDataParam.pageSize]: this.pageSize,
        });
    }

    /**
     * 페이지 번호 선택
     * @author jihoon
     * @param event
     */
    handleMove(event) {
        // 선택 된 페이지
        this.pageNumber = event.target.value;
        this.gfnComFireDispatch('movepage', {
            [this.PagingData.gComReqDataParam.pageNumber]: this.pageNumber,
            [this.PagingData.gComReqDataParam.pageSize]: this.pageSize,
        });
    }

    /**
     * @author jihoon
     * @description Simple paging 일 때
     * @returns {*} e.g. Page 1 of 10 (Total 100)
     */
    get getPageInfo() {
        // 총 Page index
        let totalPage = Math.ceil(this.totalSize / this.pageSize);

        let totalSizeWithComma = this.totalSize.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

        return 'Page ' + this.pageNumber + ' of ' + totalPage + ' (Total ' + totalSizeWithComma + ')';

    }

    /**
     * @author jihoon
     * @returns {*[]} Number paging (e.g. 1 2 3 4 5)
     */
    get getPageView() {
        let pageView = [];

        // =====================================
        // 출력되어야 하는 페이지 수를 계산한다
        // =====================================
        let pages = Math.ceil(this.totalSize / this.pageSize);
        // let pages = Math.ceil(200 / this.pageSize);


        // 보이는 페이지
        // 데이터가 출력되어야하는 페이지 수보다 많은 경우, 출력되어야 하는 페이지만 출력
        let pageLength = 5; // default
        let temp = pages > pageLength ? pageLength : pages;

        // 초반 페이지
        let interval = Math.floor(temp / 2);        // 3

        let first = this.pageNumber - interval;
        let last = this.pageNumber + interval;

        let i;
        if(first > 0){
            // 페이지 변경이 필요한 경우
            if(last <= pages){
                for(i=0; i < temp; i++){
                    pageView.push({number:first+i});
                }
            }else{
                first = pages - temp + 1;
                for(i=0; i < temp; i++){
                    pageView.push({number:first+i});
                }
            }
        }else if(first <= 0){
            // 페이지 변경이 필요없는 경우
            for(i=0; i < temp; i++){
                pageView.push({number:i+1});
            }
        }

        const pageNum = this.pageNumber;
        pageView.forEach(function (page) {
            page.variant = page.number === pageNum ? 'brand' : 'neutral';
        });

        // this.pageView = pageView;

        return pageView;

    }

    /**
     * X Scroll
     *
     * @param event
     */
    doScrollX(event) {
        // TODO : 2021-02-16    기능 개발 필요.
        const sl = event.currentTarget.scrollLeft;
        const colArr = [];

        // th, td 추출.
        const ths = this.querySelectorAll('th');
        const tds = this.querySelectorAll('td');

        let left = 1;

        for(let i = 0; i < left; i++) {
            colArr.push(ths[i]);
            colArr.push(tds[i]);
        }

        if(colArr.length !== 0) {

        }
    }

    /**
     * Y Scroll
     *
     * @param event
     */
    doScrollY(event) {
        // TODO : 2021-02-16    x축 구현 후, 같이 작동 시 수정 필요.
        let el = event.currentTarget, st = el.scrollTop;

        this.querySelectorAll('th').forEach((th) => {
            th.style.background = this.PropertyUtil.isEmpty(th.style.background) || 'rgb(250, 250, 249)';

            th.style.top = st + 'px';
            th.style.zIndex = 20;
        });
    }

}