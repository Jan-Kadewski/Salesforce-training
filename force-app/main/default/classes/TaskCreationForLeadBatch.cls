public class TaskCreationForLeadBatch implements Database.Batchable<sObject>, Stateful {

    public Database.QueryLocator start(Database.BatchableContext BC) {
      String query = 'SELECT Id, RecordType.Name, CreatedDate FROM Lead WHERE RecordType.Name = \'PartnerLead\' AND CreatedDate > LAST_N_DAYS:10';
        return Database.QueryLocator(query);    
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Task> tasks = new List<Task>();
        List<Lead> leads = new List<Lead>();
        List<Log__c> logs = new List<Log__c>();
        Id adminUserId = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].Id;
        
        for(sObject sObj : scope){
            Lead lead = (Lead)sObj;
            lead.Has_Task__c = true;
            Task task = new Task(
                Subject = 'Call',
                Priority = 'High',
                OwnerId = adminUserId,
                DueDate = DateTime.now().addDays(7).date(),
                Phone = lead.Phone
            );
            tasks.add(task);
            leads.add(lead);
        }
        update leads;
        List<Database.SaveResult> results = Database.insert(tasks, false);
        if(!results.isSuccess()){
            for(Database.Error error : results.getErrors()){
                Log__c log = new Log__c();
                log.Description__c = error.getMessage();     
                logs.add(log);
            }   
        }
        if (!logs.isEmpty()) {
            insert logs;
        }    }

    public void finish(Database.BatchableContext BC) {
        BatchControl__c control = BatchControl__c.getOrgDefaults();
        control.FinishedAt__c = Datetime.now();
        
      List<Lead> leadsWithoutCreatedTask = [  Select Id, RecordType.Name, CreatedDate from Lead where 
      RecordType.Name ='PartnerLead' and CreatedDate > N_DAYS_AGO:10 and Has_Task__c = false];
      

      if(leadsWithoutCreatedTask.size() >=1 && Datetime.now().hour() <5 && control.runNumber__c <2) {
        control.runNumber__c ++;
        Id batchJobId = Database.executeBatch(new TaskCreationForLeadBatch(), 200);
      }
      update control; 
    }

} 