public class InputFileControllerExtension {
 
    ApexPages.StandardController stdController;
    private final Vehicle__c veh;
 
    public Attachment attachment {
        get {
            if (attachment == null) attachment = new Attachment();
            return attachment;
        }
 
        set;
    }
 
    public InputFileControllerExtension(ApexPages.StandardController stdController)
    {
        this.veh = (Vehicle__c)stdController.getRecord();
        this.stdController = stdController;
    }
 
    public PageReference save() {
        attachment.parentid = veh.id;
        insert attachment;
       
        PageReference page = ApexPages.currentPage();
        page.setRedirect(true);
        return page;
     }

}