param number1 int
param number2 int

@allowed([
  'sum'
  'multiply'
  'divide'
  'subtract'
])
param operation string

var sum = operation == 'sum' ? number1 + number2 : 0
var multiply = operation == 'multiply' ? number1 * number2 : 0
var divide = operation == 'divide' ? number1 / number2 : 0
var subtract = operation == 'subtract' ? number1 - number2 : 0

output result int = sum + multiply + divide + subtract
