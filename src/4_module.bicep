
module oneCalc 'calculator.bicep' = {
  name: 'calculator'
  params: {
    number1: 1
    number2: 2
    operation: 'sum'
  }
}

output oneCalcResult int = oneCalc.outputs.result

var someCalculations = [
  {
    number1: 2
    number2: 2
    operation: 'multiply'
  }
  {
    number1: 9
    number2: 3
    operation: 'divide'
  }
]

module someCalcs 'calculator.bicep' = [for calc in someCalculations: {
  name: 'calculator-${calc.operation}'
  params: {
    number1: calc.number1
    number2: calc.number2
    operation: calc.operation
  }
}]

output forCalcsResult array = [for i in range(0, length(someCalculations)): someCalcs[i].outputs.result]

var nestedCalculations = [
  {
    operation: 'subtract'
    pairs: [
      [1,2]
      [3,4]
    ]
  }
  {
    operation: 'sum'
    pairs: [
      [5,6]
      [7,8]
    ]
  }
]

module nestedCalcs '4b_calcoperator.bicep' = [for calc in nestedCalculations: {
  name: 'calculator-${calc.operation}'
  params: {
    numberPairs: calc.pairs
    operation: calc.operation
  }
}]

output nestedCalcsResult array = [for i in range(0, length(nestedCalculations)): nestedCalcs[i].outputs.results]
