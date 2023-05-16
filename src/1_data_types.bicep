// arrays

var stringArray = [
  'abc'
  'def'
  'ghi'
]

var integerArray = [
  1
  2
  3
]

var mixedArray = [
  'abc'
  1
  'def'
  2
]

param someArray array = [
  'abc'
  'def'
  'ghi'
]
param someIndex int = 1

var defaultSomeArray = empty(someArray) ? ['default'] : someArray

output defaultedSomeValue string = length(defaultSomeArray) >= someIndex ? defaultSomeArray[someIndex] : 'default'
output joined string = join(stringArray, ',')
output indexed int = integerArray[1]
output defaultArray string = empty(someArray) ? 'default' : someArray[0]

output mixedString string = mixedArray[0]
output mixedInt int = mixedArray[1]

// objects

var zipCodePropertyName = 'zip'
var defaultAddress = {
  street: '123 Main St'
  state: 'CA'
  '${zipCodePropertyName}': '12345'
}

param someAddress object
var defaultCity = contains(defaultAddress, 'city') ? defaultAddress.city :  'Zurich'
var theAddress = union(defaultAddress, {city: defaultCity}, someAddress)

output zip string = theAddress[zipCodePropertyName]
output street string = theAddress.street
var nestedProperty = 'street'
var nestedObject = {
  dev: {
    name: 'dev'
    age: 10
  }
  qa: {
    name: 'qa'
    age: 20
    '${nestedProperty}': 'nested'
  }
}

output nestedObject string = nestedObject.qa[nestedProperty]

// strings
var defaultString = 'default'
var multiLineString = '''
  line 1
  line 2
  line 3
'''

output defaultString string = defaultString
output multiLineStringLines int = length(split(multiLineString, '\n'))
