public abstract class TriggerHandler {
    public static Boolean bypassTrigger = false;

    public static Boolean checkBypassForUser() {
        TriggerBypassSetting__c settings = TriggerBypassSetting__c.getInstance(UserInfo.getUserId());
        return (settings != null && settings.BypassTriggers__c);
    }

    public virtual void beforeInsert(List<SObject> newRecords) {}
    public virtual void afterInsert(List<SObject> newRecords) {}
    public virtual void beforeUpdate(List<SObject> newRecords) {}
    public virtual void afterUpdate(List<SObject> newRecords) {}


    public static void setBypassTrigger(Boolean bypass) {
        bypassTrigger = bypass;
    }

    public static Boolean getBypassTrigger() {
        return bypassTrigger;
    }

    public void run(TriggerOperation operation, List<SObject> newRecords, Map<Id, SObject> oldMap) {
        if (getBypassTrigger() || checkBypassForUser()) {
            return;
        }

        switch on operation {
            when BEFORE_INSERT {
                beforeInsert(newRecords);
            }
            when AFTER_INSERT {
                afterInsert(newRecords);
            }
            when BEFORE_UPDATE {
                beforeUpdate(newRecords);
            }
            when AFTER_UPDATE {
                afterUpdate(newRecords);
            }
        }
    }
}
