# SwiftReflector

SwiftReflector is an experiment and helper class to get some reflection on Swift

## Examples

### Instantiate the Reflector

	let reflector = Reflector<NSString>()

### Class Information

	// Return full qualified name
    let name        = reflector.name
    
    // Class properties
    let properties  = reflector.properties
    
    // Class Instance methods
    let methods     = reflector.methods

### Create instances

	// Creates a new instance
	let instance    = reflector.createInstance()

  // Create a new instance from name
  let instance    = Reflector.createInstance("NSData")
	
### Execute code

	// Executes code without return value
	reflector.execute({ (`self`) -> () in
      println("I have access to self: \(`self`)")
    }, instance: instance)
    
    // Executes code with return value
    let returnValue:String = reflector.execute({ (`self`) -> String in
      return `self`.substringFromIndex(5)
    }, instance: instance)
