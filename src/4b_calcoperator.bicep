@allowed([
  'sum'
  'multiply'
  'divide'
  'subtract'
])
param operation string

param numberPairs array

module calcs 'calculator.bicep' = [for (pair, i) in numberPairs: {
  name: 'myCalculator${i}'
  params: {
    operation: operation
    number1: pair[0] ?? 0
    number2: pair[1] ?? 0
  }
}]

output operation string = operation
output results array = [for i in range(0, length(numberPairs)): calcs[i].outputs.result]
