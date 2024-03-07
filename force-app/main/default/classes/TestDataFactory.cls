@isTest
public with sharing class TestDataFactory {

    @isTest
    public static void createAdminUser(){
        String profileId = [Select Id from Profile where Profile.Name ='System Administrator' LIMIT 1].Id;
        User user = new User(
            Username=String.valueOf(Date.today()) + 'randomNameJustForPass'+ 'salesforceUser@gmail.com',
            Email='usertester1@gmail.com',
            LastName= 'User1',
            Alias = 'User1',
            profileId = profileId,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert user;
        System.assertEquals(user.Alias, 'User1');
    }

    @isTest
    public static void createPartnerLeadTwentyDaysAfterToday(){
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Lead' AND DeveloperName = 'PartnerLead' LIMIT 1];

        Lead lead = new Lead(
            LastName = 'Lead1',
            Company = 'Company1',
            RecordTypeId = rt.Id,
            Has_Task__c = false
            
        );
        insert lead;
        Test.setCreatedDate(lead.Id,  Date.today().addDays(-10));
        Test.startTest();
            Lead myLead = [Select Id, firstName,CreatedDate from Lead];
            System.assertEquals(myLead.CreatedDate, Date.today().addDays(-10));
            Test.stopTest();
    }
}