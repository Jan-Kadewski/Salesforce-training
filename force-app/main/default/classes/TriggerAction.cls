
public class TriggerAction {
	public interface BeforeInsert {
		void beforeInsert(List<SObject> newList);
	}

	public interface AfterInsert {
		void afterInsert(List<SObject> newList);
	}

	public interface BeforeUpdate {
		void beforeUpdate(List<SObject> newList, List<SObject> oldList);
	}

	public interface AfterUpdate {
		void afterUpdate(List<SObject> newList, List<SObject> oldList);
	}

	public interface BeforeDelete {
		void beforeDelete(List<SObject> oldList);
	}

	public interface AfterDelete {
		void afterDelete(List<SObject> oldList);
	}

	public interface AfterUndelete {
		void afterUndelete(List<SObject> newList);
	}
}
