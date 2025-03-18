
# **📘 Stock News LWC Setup Guide**  

This guide walks you through the setup of the **Stock News LWC**, including retrieving the code, configuring named credentials, securing the API key, and adding the component to an Account record page.  

---

## **1️⃣ Get the Code from GitHub**  
Before you can use the LWC, you need to clone the repository from GitHub.  

### **📥 Clone the Repository**  
1. Open your terminal (Mac: `Command + Space` → search for "Terminal").  
2. Navigate to your Salesforce project directory:  
   ```bash
   cd path/to/your/sfdx/project
   ```
3. Clone the repository:  
   ```bash
   git clone https://github.com/jlanks/StockNewsLWC.git
   ```
4. Navigate into the project folder:  
   ```bash
   cd StockNewsLWC
   ```
5. Deploy the LWC to Salesforce:  
   ```bash
   sfdx force:source:push
   ```

---

## **2️⃣ Set Up Named Credentials and External Credential**  
Since the LWC makes an external API call to AlphaVantage, you need to configure **Named Credentials** to securely store and manage API requests.  

### **🔹 Create an External Credential**  
1. Go to **Setup** → Search for **External Credentials**.  
2. Click **New** and enter:  
   - **Label**: `AlphaVantageCredential`  
   - **Name**: `AlphaVantageCredential`  
   - **Authentication Protocol**: `API Key`  
   - **Principal Type**: `Named Principal`  
3. Click **Save**.  

### **🔹 Set Up Named Credentials**  
1. Go to **Setup** → Search for **Named Credentials**.  
2. Click **New** and enter:  
   - **Label**: `alphavantage`  
   - **Name**: `alphavantage`  
   - **URL**: `https://www.alphavantage.co`  
   - **External Credential**: Select `AlphaVantageCredential`  
3. Click **Save**.  

---

## **3️⃣ Store API Key Securely in Custom Metadata**  
To avoid hardcoding the API key in Apex, store it in **Custom Metadata**.  

### **🔹 Create a Custom Metadata Type**  
1. Go to **Setup** → Search for **Custom Metadata Types**.  
2. Click **New Custom Metadata Type**.  
   - **Label**: `API_Keys`  
   - **Object Name**: `API_Keys`  
3. Click **Save**.  

### **🔹 Add a Field for the API Key**  
1. In the **API_Keys** metadata record, go to **Fields & Relationships** → **New**.  
2. Choose **Text**, click **Next**.  
3. Field Name: `AlphaVantage_API_Key`  
4. Click **Save**.  

### **🔹 Add the API Key**  
1. Go back to **Custom Metadata Types** → Click **Manage Records** for `API_Keys`.  
2. Click **New**.  
   - **Label**: `AlphaVantage`  
   - **AlphaVantage_API_Key**: `YOUR_API_KEY_HERE`  
3. Click **Save**.  

---

## **4️⃣ Deploy and Verify the LWC**  
### **🔹 Deploy Apex Class & LWC**  
If you haven't already, deploy the code to your Salesforce org:  
```bash
sfdx force:source:push
```

### **🔹 Assign the Apex Class Permission**  
1. Go to **Setup** → **Profiles**.  
2. Select the profile of users who should access the component.  
3. Under **Apex Class Access**, click **Edit**.  
4. Add `NewsSentimentService`.  
5. Click **Save**.  

---

## **5️⃣ Add the LWC to the Account Record Page**  
### **🔹 Steps to Add Component**  
1. Go to **App Launcher** (`🔎` in top-left).  
2. Open any **Account Record**.  
3. Click the **⚙️ Setup Icon** → Select **Edit Page**.  
4. Drag the **Stock News** LWC onto the page.  
5. Click **Save**, then **Activate**.  

---

## **6️⃣ Test the LWC**  
1. Open any **Account Record Page** where the LWC was added.  
2. Enter a **Stock Ticker Symbol** (e.g., `AAPL`).  
3. Click **Search**.  
4. If everything is configured correctly, you should see **stock-related news articles** displayed.  

---

## **💡 Troubleshooting Tips**  
### **⚠️ No Data Showing in LWC?**  
- Make sure the **API Key** is correctly stored in **Custom Metadata**.  
- Check the **Named Credential** setup in **Setup > Named Credentials**.  

### **⚠️ Apex Callout Exception?**  
- Go to **Setup > Debug Logs** to check for API call failures.  
- Ensure the **Named Credential URL** is `https://www.alphavantage.co`.  

### **⚠️ Git Push Rejected?**  
If you get `! [rejected] main -> main (fetch first)`, resolve it with:  
```bash
git pull origin main --rebase
git push origin main
```

---

## **🎉 You're All Set!**  
You’ve successfully set up the **Stock News LWC** to display news based on stock tickers. 🚀 Now you can enjoy real-time financial news directly in Salesforce! 🎯  

Need help? Drop a comment! 💬