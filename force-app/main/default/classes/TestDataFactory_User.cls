@isTest
public with sharing class TestDataFactory_User {
    private User usr;
    private static Map<String,Profile> profileMap = new Map<String,Profile>();
    private static Map<String,UserRole> roleMap = new Map<String,UserRole>();

    public TestDataFactory_User(User usr) {
        this.usr = usr;
    }

    // Entry point builder method to start composing object attributes
    public static TestDataFactory_User start() {
        return new TestDataFactory_User(
            new User( 
                Alias = 'tu',
                Email='tester@tester.com',
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', 
                TimeZoneSidKey='America/Los_Angeles', 
                UserName = setUniqueUserName()
                )
        );
    }

    // allow override of profile
    // add to map to avoid requery in same context
    public TestDataFactory_User overrideProfile(String profileName) {
        profileName = profileName.toLowerCase();
        if(!profileMap.containsKey(profileName)){
            Profile p = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
            profileMap.put(profileName,p);
        } 
        usr.ProfileId = profileMap.get(profileName).Id;
        return this;
    }
    
    
	// allow override of role
    // add to map to avoid requery in same context
    public TestDataFactory_User overrideRole(String roleName) {
        roleName = roleName.toLowerCase();
        if(!roleMap.containsKey(roleName)){
            UserRole r = [SELECT Id FROM UserRole WHERE Name = :roleName LIMIT 1];
            roleMap.put(roleName,r);
        } 
        usr.UserRoleId = roleMap.get(roleName).Id;
        return this;
    }

    // don't actually create in testing
    public User create(){
        return usr;
    }

    private static string setUniqueUserName(){
		return UserInfo.getOrganizationId() + DateTime.Now().getTime() + Math.random() + '@eccles.tests.com';
    }
    
    public TestDataFactory_User setFirstName(String firstName){
        usr.firstname = firstName;
        return this;
    }
    
    public TestDataFactory_User setLastName(String lastName){
        usr.lastname = lastName;
        return this;
    }

}