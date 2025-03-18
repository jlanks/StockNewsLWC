public with sharing class NewsSentimentService {
    private static final String NAMED_CREDENTIAL = 'alphavantage';

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getNewsSentiment(String ticker) {
        if (String.isEmpty(ticker)) {
            throw new IllegalArgumentException('Ticker cannot be null or empty');
        }

        // Construct API Call URL (Named Credentials automatically include base URL)
        String endpoint = 'callout:alphavantage/query?function=NEWS_SENTIMENT&tickers=' 
    + EncodingUtil.urlEncode(ticker, 'UTF-8') 
    + '&apikey=CAFYZK93EXXUW4CE';



        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);

        System.debug('🔎 RAW API RESPONSE: ' + res.getBody()); // ✅ Log full response

        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Map<String, String>> articles = new List<Map<String, String>>();

            // ✅ Check if 'feed' exists & is not null
            if (responseMap.containsKey('feed') && responseMap.get('feed') != null) {
                List<Object> feedList = (List<Object>) responseMap.get('feed');
                for (Object item : feedList) {
                    Map<String, Object> article = (Map<String, Object>) item;

                    // ✅ Check for missing fields (avoid null values)
                    String title = (String) article.get('title');
                    String summary = (String) article.get('summary');
                    String url = (String) article.get('url');
                    String imageUrl = (String) article.get('banner_image');

                    if (title != null && url != null) { // ✅ Ensure required fields exist
                        Map<String, String> formattedArticle = new Map<String, String>();
                        formattedArticle.put('title', title);
                        formattedArticle.put('summary', summary != null ? summary : 'No summary available');
                        formattedArticle.put('url', url);
                        formattedArticle.put('imageUrl', imageUrl != null ? imageUrl : ''); // Avoid null images

                        articles.add(formattedArticle);
                    }
                }
            } else {
                System.debug('⚠️ No feed found in API response.');
            }

            System.debug('🔎 Final Articles List: ' + articles);
            return articles;
        } else {
            throw new CalloutException('API Call failed: ' + res.getStatus());
        }
    }
}
