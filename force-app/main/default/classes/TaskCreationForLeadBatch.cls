public class TaskCreationForLeadBatch implements Database.Batchable<sObject> {

    Date tenDaysAgo = Date.today().addDays(-10);

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Has_Task__c,Phone FROM Lead WHERE RecordType.Name = \'PartnerLead\' AND CreatedDate =:tenDaysAgo';
            return Database.getQueryLocator(query);    
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Task> tasks = new List<Task>();
        List<Lead> leads = new List<Lead>();
        List<Log__c> logs = new List<Log__c>();
        String ADMIN_USER_ID = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].Id;

        for(sObject sObj : scope){
            Lead lead = (Lead)sObj;
            lead.Has_Task__c = true;

            Task task = new Task(
                Subject = 'Call',
                Priority = 'High',
                OwnerId = ADMIN_USER_ID,
                ActivityDate = Date.today().addDays(7),
                whoId = lead.Id
            );
            tasks.add(task);
            leads.add(lead);
        }
        update leads;
        List<Database.SaveResult> taskInsertResults = Database.insert(tasks, false);
        for (Integer i = 0; i < taskInsertResults.size(); i++) {
            if (!taskInsertResults[i].isSuccess()) {
                for (Database.Error error : taskInsertResults[i].getErrors()) {
                    Log__c log = new Log__c(
                        RecordId__c = tasks[i].whoId,
                        Description__c = error.getMessage()
                    );
                    logs.add(log);
                }
            }
        }

        if (!logs.isEmpty()) {
            insert logs;
        }
    }

    public void finish(Database.BatchableContext BC) {
        BatchControl__c control = BatchControl__c.getOrgDefaults();
        control.FinishedAt__c = Datetime.now();
        insert control;

      List<Lead> leadsWithoutCreatedTask = [  Select Id, RecordType.Name, CreatedDate from Lead where 
      RecordType.Name ='PartnerLead' and CreatedDate > N_DAYS_AGO:10 and Has_Task__c = false];
      

      if(leadsWithoutCreatedTask.size() >=1 && Datetime.now().hour() <5 && control.runNumber__c <2) {
        control.runNumber__c ++;
        update control;

        Id batchJobId = Database.executeBatch(new TaskCreationForLeadBatch(), 200);
      }
    }

} 