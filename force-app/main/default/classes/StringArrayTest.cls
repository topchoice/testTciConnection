public class StringArrayTest {

	// public method
	public static String[] generateStringArray(Integer length) {
		String[] mArray = new List<String>();
		for( Integer i=0; i<length; i++) {
			mArray.add('Test ' + i);

			System.debug(mArray[i]);
		}
		return mArray;
	}
}