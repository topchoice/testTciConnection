public class GroupsController {
    public String selectedVal{
        get{return selectedVal;}set{selectedVal= value;}
    }
    public String selectedVal1{
    get;set;
    }
    public List<SelectOption> users_id {
         get{return users_id;}
         set{users_id=value;}
    }
    public PageReference setmyValue(){
         List<GroupMember> gm = [SELECT userorgroupid from GroupMember where groupid=:selectedVal];  
         List<String> group_id  = new  List<String>();
         for(GroupMember g:gm){
              group_id.add(g.userorgroupid+'');
         }
         List<USER> users_1  = [SELECT name from User where id in :group_id];
         users_id = new List<SelectOption>();
          for(User u:users_1 ){
              users_id.add(new SelectOption(u.name,u.name));
         }
        return null;
    }
    public List<selectOption> getGroupsList(){        
            SET<String> fields = new SET<String>();
                        fields = Schema.SObjectType.Group.fields.getmap().keyset();
                        System.debug(fields);
                        List<Group> groups = [select developername,name, type from group where type= 'Regular'];
                        Map<id,Group> group_maps = new Map<id,Group>();
                        List<selectOption> g1roupsList = new List<selectOption>();
            for(Group g :groups){
                        group_maps.put(g.id,g);
                g1roupsList.add(new SelectOption(g.id,g.developername));
                        }
                        System.debug(group_maps);
            return g1roupsList;
    }
}