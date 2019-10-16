public class e2{

    public e2(ApexPages.StandardController cont){}

    List<Campaign> camps = [SELECT Name, StartDate, EndDate from Campaign];
    
    public List<Campaign> getcamps(){
    return camps;
    }


}