@IsTest
public class TestForceForecasting {

    static testmethod void insertUser() {
    
        User u = New User();
        
        u.FirstName = 'Calvin';
        u.LastName = 'Bates';
        u.Email = 'calbat32@gmail.com';
        u.Alias = 'cbat32';
        u.Username = 'calbat32@gmail.com';
        u.ProfileId = '00ei0000000mhFd';
                
        u.TimezoneSidKey = 'America/Phoenix';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
                
        insert u;
    
    }
    
}