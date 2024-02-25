@IsTest
public class TriggerTestUtility {
	static Integer myNumber = 1;

	public static Id getFakeId(Schema.SObjectType sObjectType) {
		String result = String.valueOf(myNumber++);
		return (Id) (sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED)
			.getKeyPrefix() +
		'0'.repeat(12 - result.length()) +
		result);
	}
}
