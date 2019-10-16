// Project: Convert Assets from Product Info.
// Created by: Comity Designs [Developer: Rashi Girdhar]
// Class: ProductsToAssets.cls      
// Description: Custom controller
// Other Package Classes: AssetWrapper.cls
// VisualForce Page: ProductsToAssets.page
// Date: 8/3/2009

/**
 ** Class: ProductsToAssets
**/
public with sharing class ProductsToAssets {

    //Variables
    // The toggleFlag changes from true to false to true, all depending on the user toggling the various
    ///quantity asset view on the VF page. This flag needs to be set to false as the initial load value.
    private Boolean toggleFlag = false;

    // The section Header variables define the heading for the top/editable page block's section header 
    private String sectionHeader;
    private final String sectionHeaderSingle = 'Single Quantity Asset View';
    private final String sectionHeaderMultiple = 'Multiple Quantity Asset View';
    
    // The toggle Button variables define the button label, as the user toggles between the single asset quantity view
    ///and the multiple asset quantity view.
    private String toggleButtonHeader;
    private final String toggleButtonHeaderSingle = 'View Single Quantity Assets';
    private final String toggleButtonHeaderMultiple = 'View Multiple Quantity Assets';

    // SObject variables and Lists
    private Opportunity opportunity;
    private Account account;
    
    // List of Opportunity Line Items [Retreived via DB Query]
    private List <OpportunityLineItem> olis;
    
    // Stores final list of assets to be upserted into SFDC
    public List<Asset> assets;
    
    // List of Converted Assets [Retreived via DB Query]
    public List<Asset> convertedAssets;
    
    // Asset object for setting mass status on all entries from VF page.
    private Asset assetStatus = new Asset();
    
    // AssetWrapper lists - aid in defining the view that is displayed to the end-user
    ///Multiple Asset Quantity view, or the, Single Asset Quantity view
    public List<AssetWrapper> assetW;
    private List<AssetWrapper> assetW_Single = new List<AssetWrapper>();
    private List<AssetWrapper> assetW_Multiple = new List<AssetWrapper>();
    
    // Inner Exception Class
    private class InnerException extends Exception {}
    
    // Debug and Exception flags - Only for Test Cases
    Boolean isDebug = true;
    Boolean throwException = false;
    
    /** 
    ** Constructor: takes no arugments 
    ** -isDebug is always false
    **/    
    public ProductsToAssets() {
        try {
            //Call init
            init();
        } catch (InnerException e) {
            System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** Overloaded Constructor: only for testing purposes, sets isDebug = input argument
    **/
    public ProductsToAssets(Boolean dBug) {
        try {
            // Set isDebug
            this.isDebug = dBug;
            // Call 
            init();
        } catch (InnerException e){
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** Init Method
    **/
    public void init() {
        try {
            //Set the sectionHeader, AssetWrapper List reference, 
            setSectionHeader();
            setAssetW();
            setToggleButtonHeader();
            
            //Get query parameters - OID & AID [Opportunity ID, Account ID]        
            getOIDQueryParameter();
            getAIDQueryParameter();
            
            //Set Account and Opportunity names
            setAccountOpportunityName();
            
            //Query Opportunity Line Item table and store in opportunity line item list
            setOLIS();
            //Query the Assets table to isolate Converted Assets on the Account for display 
            setConvertedAssets();
            
            //Utilize the OLI list to set the Asset Wrapper List to be used by the VF Page
            setAssetWrapperList();
                 
            // Setup OLIS to null - speedup controller.
            olis = null;
                                  
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }    
    }

    // Getters
    /**
    ** getOIDQueryParameter: gets the OID Query parameter [Opportunity ID]
    **/
    public Boolean getOIDQueryParameter(){
        try {
            opportunity = new Opportunity(id=ApexPages.currentPage().getParameters().get('oid'));
            
            if(opportunity.ID == null) {
                throw new InnerException('Manual Exception: OID or AID is Null!');
            }
            
            return true;
            
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** getAIDQueryParameter: gets the AID Query parameter [Account ID]
    **/    
    public Boolean getAIDQueryParameter(){
        try {
            account = new Account(id=ApexPages.currentPage().getParameters().get('aid'));
            
            if(account.ID == null) {
                throw new InnerException('Manual Exception: OID or AID is Null!');
            }
            
            return true;
            
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
     
    public String getOpportunityID() {
        return this.opportunity.ID;
    } 
    
    
    public Account getAccount() {
        return this.account;
    }
    
    public Opportunity getOpportunity() {
        return this.opportunity;
    }
    
    public String getAccountID() {
        return this.account.ID;
    }
    
    public String getSectionHeader() {
        return this.sectionHeader;
    }
    
    public Asset getAssetStatus() {
        return assetStatus;
    }
    
    public Boolean getToggleFlag() {
        return this.toggleFlag;
    }
    
    public List<OpportunityLineItem> getOlis() {
        return this.olis;
    }
    
    public String getToggleButtonHeader() {
        return this.toggleButtonHeader; 
    }

    public List<AssetWrapper> getAssetW(){
        return this.assetW;
    }
    
    public List<Asset> getConvertedAssets(){
        return this.convertedAssets;
    }

    public Integer getConvertedAssetsCount(){
        return this.convertedAssets.size();
    }

    
    // Setters
    public void setThrowException(Boolean te) {
        this.throwException = te;
    }
    
    
    /**
    ** setAccountName: runs query to get Account name
    **/ 
    public void setAccountOpportunityName(){
        try {
            Opportunity opp = [Select o.Name, o.Account.Name from Opportunity o where o.ID=:opportunity.ID LIMIT 1];
            this.opportunity.Name = opp.Name;
            this.account.Name = opp.Account.Name;
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
        } catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
                if(isDebug) System.debug(e.getDmlMessage(i));
            throw new InnerException(e);
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** setSectionHeader:
    ** -if toggleFlag=false, then sectionHeader=sectionHeaderMultiple [displays multiple quantity asset header]
    ** -else, sectionHeader = sectionHeaderSingle [displays single quantity asset header]
    **/
    private void setSectionHeader(){
        if(!toggleFlag)
            sectionHeader = sectionHeaderMultiple;
        else
            sectionHeader = sectionHeaderSingle;
    }
    
    /**
    ** setAssetW:
    ** -if toggleFlag=false, then assetW=assetW_Multiple [displays editable data list for multiple quantity asset view]
    ** -else, assetW=assetW_Single [displays editable data list for single quantity asset view]
    **/
    public void setAssetW(){
        if(!toggleFlag) {
           assetW = assetW_Multiple;
        } else {
           assetW = assetW_Single;
        }
    }
    
    /**
    ** setToggleButtonHeader:
    ** -if toggleFlag=false, then toggleButtonHeader=toggleButtonHeaderSingle [displays button header to toggle to single quantity asset view]
    ** -else, toggleButtonHeader=toggleButtonHeaderMultiple [displays button header to toggle to multiple quantity asset view]
    **/
    public void setToggleButtonHeader() {
        if(!toggleFlag) {
           toggleButtonHeader = toggleButtonHeaderSingle; 
        } else {
           toggleButtonHeader = toggleButtonHeaderMultiple;
        }
    }
    
    /**
    ** setOLIS: runs query on Opportunity Line Item table to retrieve products on opportunity 
    **/
    public void setOLIS() {
        try {
            olis=[Select    o.Id, 
                            o.IsDeleted, 
                            o.ListPrice, 
                            o.OpportunityId, 
                            o.Opportunity.CloseDate, 
                            o.PricebookEntry.Product2Id,
                            o.PricebookEntryId, 
                            o.PricebookEntry.Name, 
                            o.Quantity, 
                            o.ServiceDate, 
                            o.TotalPrice, 
                            o.UnitPrice 
                    from    OpportunityLineItem o  
                    where   o.IsDeleted=false and 
                            o.OpportunityId=:opportunity.ID];
        
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
        
        } catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
                if(isDebug) System.debug(e.getDmlMessage(i));
            throw new InnerException(e);
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** setConvertedAssets: runs query against Assets table to retreive already converted assets against the account for read-only view.
    **/
    public void setConvertedAssets(){
        try {
            convertedAssets = [Select   Name, 
                                        Quantity, 
                                        Price, 
                                        Product2.Name, 
                                        Status, 
                                        InstallDate, 
                                        PurchaseDate, 
                                        UsageEndDate, 
                                        SerialNumber, 
                                        Account.Name, 
                                        Purchase_Opportunity__r.Name 
                                from    Asset 
                                where   Converted_Asset__c=true and
                                        AccountId=:account.ID and
                                        Purchase_Opportunity__r.ID=:opportunity.ID];
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');                           
                
        } catch (DmlException e){
            for(Integer i = 0; i < e.getNumDml(); i++)
                if(isDebug) System.debug(e.getDmlMessage(i));
            throw new InnerException(e);
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        } 
    }
    
    /**
    ** setAssetWrapperList: creates the single quantity asset list, and the multiple quanity list view
    ** -Depending on the toggleFlag, one or the other will be displayed.
    **/
    public void setAssetWrapperList() {
        try {
            Integer counter=0;
            Asset a1, b1;
            
            for(OpportunityLineItem o: olis) {
                a1 = new Asset();
                b1 = new Asset();
                
                a1.Name                     = o.PriceBookEntry.Name;            
                a1.Product2Id               = o.PriceBookEntry.Product2Id; 
                a1.AccountId                = account.Id;
                a1.Purchase_Opportunity__c  = opportunity.Id;
                a1.Contact                  = null;
                a1.Quantity                 = o.Quantity;
                a1.Price                    = o.TotalPrice;
                a1.InstallDate              = o.ServiceDate;
                a1.PurchaseDate             = o.Opportunity.CloseDate;
                //a1.UsageEndDate           = null;
                //a1.SerialNumber           = null;
                a1.Converted_Asset__c       = true;
             
                assetW_Multiple.add(new AssetWrapper(a1, o.Id));
                
                b1 = a1.clone();
                
                if(o.Quantity > 1.00){
                    b1.Quantity=1.00;
                    
                    b1.Price=o.TotalPrice/(o.Quantity.intValue() == 0? 1 : o.Quantity.intValue());
                }
                
                counter=o.Quantity.intValue();
                for(Integer i=0; i < counter; i++){
                    assetW_Single.add(new AssetWrapper(b1.clone(), o.Id));
                }   
            } 
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
        }catch (Exception e){
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
        
    }
    
    /**
    ** setAssetLists: creates the final asset list to be upserted 
    **/
    public void setAssetLists() {
        try {
            assets = new List<Asset>();
            
            for(AssetWrapper aW1: assetW) {
                if(aW1.getIsAssetSelected())
                    assets.add(aW1.getAsset().clone());
            }
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }

    // PageReference Methods for handling buttons on the VF page
    /** 
    ** Cancel Button
    **/
    public PageReference cancel() {
        try {
            PageReference opportunityPage = new ApexPages.StandardController(opportunity).view();
            opportunityPage.setRedirect(true);
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
            return opportunityPage;
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        } 
    }

    /**
    ** Toggle Button - 'View Single Asset Quantities' / 'View Multiple Asset Quantities'
    **/
    public PageReference toggleView() {
        try {
            if(toggleFlag) {
                toggleButtonHeader = toggleButtonHeaderSingle;
                sectionHeader = sectionHeaderMultiple;
                assetW = assetW_Multiple;
                
                toggleFlag = false;
            } else {
                toggleButtonHeader = toggleButtonHeaderMultiple;
                sectionHeader = sectionHeaderSingle;
                assetW = assetW_Single;
                
                toggleFlag = true;
            }
            
            assetStatus.Status = null;
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
            return null;
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** selectAll: checks/selects all checkboxes
    **/
    public PageReference selectAll() {
        for(AssetWrapper aW: assetW){
            aW.setIsAssetSelected(true);
        }
        
        return null;
    }
    
    /** 
    ** deslectAll: unchecks all checkboxes
    **/
    public PageReference deselectAll() {
        for(AssetWrapper aW: assetW){
            aW.setIsAssetSelected(false);
        }
        
        return null;
    }
    
    /**
    ** selectAllStatus: Global select all picklist for Status
    **/
    public PageReference selectAllStatus() {
        for(AssetWrapper aw: AssetW) {
            aw.getAsset().Status = assetStatus.Status;
        }
        
        return null;
    }

    /** 
    ** Convert Button
    **/
    public PageReference convert() {
        PageReference accountPage;
        try {
            Integer num_of_assets = 0;
     
            // Setup the assets to be upserted
            setAssetLists();
            num_of_assets = assets.size();
            
            if(num_of_assets > 0) {
                // Insert or Update Assets [Upsert]
                upsert assets;
                
                // Goto Account
                accountPage = new ApexPages.StandardController(account).view();
                accountPage.setRedirect(true);
                return accountPage;
    
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: You have not selected any line items!');
                ApexPages.addMessage(myMsg);
                return null;
            }
        } catch (Exception e) {
            if(isDebug) System.debug('Convert: ' + e.getMessage());            
            throw e;
        }
    }
}