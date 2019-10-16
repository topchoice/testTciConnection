/*
 * Trigger Factory
 *
 * Interface for Implementing single trigger architecture/pattern.
 */
public class TriggerFactory {
	
	// Exception used for when handlerName is not a proper class name
	// or class is not an instance of TriggerHandler	
	public class HandlerException extends Exception{}

	// Creates and Executes the TriggerHandlerInterface
	public static void createAndExecuteHandler( String handlerName) {
		TriggerHandlerInterface handler = create( handlerName) ;
		execute( handler) ;
	}

	// Creates a TriggerHandlerInterface based off the handlerName that is passed in
	private static TriggerHandlerInterface create( String handlerName) {
		System.Type classType = Type.forName( handlerName) ;
		// Need to check to see if it is a valid class or not
		if ( classType == null) {
			throw new HandlerException( 'Not a valid class name for ' + handlerName) ;
		}

		Object handler = classType.newInstance();

		if ( !(handler instanceOf TriggerHandlerInterface) ) {
			throw new HandlerException( 'Not a valid instance of Trigger Handler for class name ' + handlerName) ;
		}

		return (TriggerHandlerInterface) handler ;
	}

	// Call the various DML operations in the trigger context
	private static void execute( TriggerHandlerInterface handler) {
		// Handles before DML operations Insert, Update, and Delete
		if ( Trigger.isBefore) {
			if ( Trigger.isInsert) {
				handler.beforeInsert( Trigger.new) ;
			} else if ( Trigger.isUpdate) {
				handler.beforeUpdate( Trigger.newMap, Trigger.oldMap) ;
			} else if ( Trigger.isDelete) {
				handler.beforeDelete( Trigger.oldMap) ;
			}
		} else if ( Trigger.isAfter) {
			if ( Trigger.isInsert) {
				handler.afterInsert( Trigger.newMap) ;
			} else if ( Trigger.isUpdate) {
				handler.afterUpdate( Trigger.newMap, Trigger.oldMap) ;
			} else if ( Trigger.isDelete) {
				handler.afterDelete( Trigger.oldMap) ;
			} else if ( Trigger.isUnDelete) {
				handler.afterUnDelete( Trigger.newMap) ;
			}
		}
	}
}