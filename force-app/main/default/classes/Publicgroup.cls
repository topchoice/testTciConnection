public with sharing class Publicgroup
{
  public boolean isExport {get; set;}
  public List<Group> publicGroup;
  public string groupId {get; set;}
  public boolean gettable {get; set;}
  public static set<id> userids = new set<id>();
  public  Map<ID,String> Group_Name {get;set;}

  public Publicgroup(ApexPages.StandardController controller) 
  {
    Group con = (Group)controller.getRecord();
                 if(Apexpages.currentPage().getParameters().get('Export') != null){
                 isExport = true;
                 }
                 else{
                 isExport = false;
                 }
    publicGroup = [SELECT Id, Name FROM Group WHERE Type = 'Regular'];
    System.Debug('Public group :'+publicGroup); 

  }

  public List<SelectOption> getgrouplist() {

        List<SelectOption> options = new List<SelectOption>();
        if(publicGroup.size()>0){
            options.add(new SelectOption('','------- Select Public Group --------')); 

            for (Group gr : publicGroup){
                options.add(new SelectOption(gr.Id,gr.name ));
            }
        }
        return options;
    }

     public void GetGroupMembers()
     {
       System.debug('GroupID :'+ groupId);

        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<Id> groupIdProxys = new Set<Id>();

        if(groupId != null && groupId != ''){ 
        gettable= true;

          List<GroupMember> GroupMembers = [select UserOrGroupId,Group.Name from GroupMember where GroupId =:groupId];
          for(GroupMember m:GroupMembers){
          if(((String)m.UserOrGroupId).startsWith(userType)){
          userids.add(m.UserOrGroupId);
          }else if (((String)m.UserOrGroupId).startsWith(groupType)){

          groupIdProxys.add(m.userOrGroupId);

                    if(groupIdProxys.size() > 0){
                        Set<id> groupId = new set<id>();
                        Set<id> roleId = new set<id>();
                        Set<id> roleAndSubId = new set<Id>();

                        List<Group> publgroup = [Select Id, Type, relatedId From Group Where Id = :groupIdProxys];
                                for(Group g2 : publgroup){

                                    if(g2.Type == 'Role'){
                                            roleId.add(g2.relatedId);
                                            system.debug('********:'+roleId);    
                                            }else if(g2.Type== 'RoleAndSubordinates'){
                                            roleAndSubId.add(g2.relatedId);  
                                            system.debug('********:'+roleAndSubId);   
                                            }else if(g2.Type== 'RoleAndInternalSubordinates'){
                                            roleAndSubId.add(g2.relatedId);
                                            system.debug('********:'+roleAndSubId);      
                                            }else if(g2.Type== 'Regular'){
                                            groupId.add(g2.id);    
                                            }
                                            system.debug(g2);
                                }
                if(roleAndSubId.size()>0){
                roleId.addAll(getAllSubRoleIds(roleAndSubId));
                }
                if(roleId.size()>0){

                  list<User> urs = [select id from user where UserRoleId IN: roleId];
                  for(User u: urs){
                    userids.add(u.id);
                  }
                }
                if(groupId.size()>0){

                    list<GroupMember> gmr = [select id, UserOrGroupId from GroupMember where GroupId IN: groupId];
                        for(GroupMember gm1 :gmr ){
                        userids.add(gm1.UserOrGroupId);        
                        }
                }

            }
         }

        }
       }else{
            gettable= false;
            groupid = '';
            }
     }

     public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

        Set<ID> currentRoleIds = new Set<ID>();
        List<UserRole> urole = [select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null Limit 40000];

        for(UserRole userRole :urole)
            currentRoleIds.add(userRole.Id);

        if(currentRoleIds.size() > 0)
          currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));

        return currentRoleIds;

     }

     public list<user> getUsers() {

        List<GroupMember> GroupMembers1 = new List<GroupMember>();
                             GroupMembers1 = [select UserOrGroupId,Group.Name from GroupMember where GroupId =:groupId];
                                     Group_Name = new Map<ID,String>();
                                        for(GroupMember u :GroupMembers1){
                                        Group_Name.put(u.UserOrGroupId,u.Group.Name);
                                        }   

                           list<user> u = new list<user>();
                           u= [select id,name,username,email,UserRole.name,profile.name,isActive from user where id in:userids and IsActive = true];
                           if(u.size() >0){
                           return u;
                           }else{
                           return null;
                           } 
     } 

     public PageReference export(){

                 isExport = true;
                 return null;
    }


}