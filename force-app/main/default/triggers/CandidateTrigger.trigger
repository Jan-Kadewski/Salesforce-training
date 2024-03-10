trigger CandidateTrigger on Candidate__c (before insert, after insert) {
    new CandidateTriggerHandler().run(Trigger.operationType, Trigger.new, Trigger.oldMap);
}
