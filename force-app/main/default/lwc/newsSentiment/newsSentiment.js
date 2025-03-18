import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getNewsSentiment from '@salesforce/apex/NewsSentimentService.getNewsSentiment';

const ACCOUNT_TICKER = 'Account.TickerSymbol';

export default class NewsSentiment extends LightningElement {
    @api recordId;
    articles = [];
    error;
    ticker;

    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_TICKER] })
    wiredAccount({ error, data }) {
        if (data) {
            this.ticker = data.fields.TickerSymbol.value;
            console.log('📌 Ticker:', this.ticker); // ✅ Print ticker
            this.fetchNewsSentiment();
        } else if (error) {
            console.error('❌ Error fetching Account:', error);
        }
    }

    fetchNewsSentiment() {
        if (!this.ticker) {
            console.error('❌ No ticker found for this account');
            return;
        }

        getNewsSentiment({ ticker: this.ticker })
            .then(result => {
                console.log('🔎 API Data:', result); // ✅ Print the fetched data
                this.articles = result;
                this.error = undefined;
            })
            .catch(error => {
                console.error('❌ API Error:', error);
                this.error = error.body ? error.body.message : error;
                this.articles = [];
            });
    }
}
