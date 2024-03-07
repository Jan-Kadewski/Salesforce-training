@isTest
public with sharing class TaskCreationForLeadBatchTest {
    
    @testSetup
    static void setup(){
        TestDataFactory.createAdminUser();
        TestDataFactory.createPartnerLeadTwentyDaysAfterToday();
    }
    

    @isTest
    static void  createTaskAssosiatedWithLead(){
        
        Test.startTest();
        TaskCreationForLeadBatch batch = new TaskCreationForLeadBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(1, tasks.size(), 'One task should have been created.');
        
        Lead updatedLead = [SELECT Has_Task__c FROM Lead];
        System.assertEquals(updatedLead.Has_Task__c, true,'Has task should be true');
        
        List<Log__c> logs = [SELECT Id FROM Log__c];
        System.assertEquals(0, logs.size(), 'There should be no error logs.');

    }
    
}