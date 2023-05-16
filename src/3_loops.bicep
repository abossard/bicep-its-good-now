// simple numbers
param endNumber int = 10
param location string = resourceGroup().location
param salt string = toLower(substring(uniqueString(resourceGroup().id), 0, 4))

param storageAccountSetup object = {
  sa001: {
    sku: 'Standard_LRS'
  }
  sa002: {
    sku: 'Standard_ZRS'
  }
}

// create storage accounts from array
resource storageAccounts 'Microsoft.Storage/storageAccounts@2022-09-01' = [for item in items(storageAccountSetup): {
  name: 'sa${salt}${item.key}'
  kind: 'StorageV2'
  location: location
  sku: {
    name: item.value.sku
  }
}]

// loops always need to refer structures that are there from the beginning
output storageAccountIds array = [for i in range(0, length(items(storageAccountSetup))) : storageAccounts[i].id]

output someNumbers array = [for index in range(0, endNumber): index]
output someNumberInObjects array = [for index in range(0, endNumber): {
  number: index
}]


// here we have list as input, it's really similar to a object based input:
param orgNames array = [
  'Contoso'
  'Fabrikam'
  'Coho'
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = [for name in orgNames: {
  name: 'nsg-${name}'
  location: location
}]

output deployedNSGs array = [for (name, i) in orgNames: {
  orgName: name
  nsgName: nsg[i].name
  resourceId: nsg[i].id
}]

param excludedNames array = [
  'Contoso'
]

resource nsg2 'Microsoft.Network/networkSecurityGroups@2020-06-01' = [for name in orgNames: if (!contains(excludedNames, name)) {
  name: 'nsg2-${name}'
  location: location
}]

var result = [for (name, i) in orgNames: (!contains(excludedNames, name)) ? {
  orgName: name
  nsgName: nsg2[i].name
  resourceId: nsg2[i].id
}: null]

output deployedNSGs2 array = filter(result, item => item != null)

// can we combine it all?
var finalNames = filter(orgNames, name => !contains(excludedNames, name))
resource nsg3 'Microsoft.Network/networkSecurityGroups@2020-06-01' = [for name in finalNames: {
  name: 'nsg3-${name}'
  location: location
}]

output deployedNSGs3 array = [for (name, i) in finalNames: {
  orgName: name
  nsgName: nsg3[i].name
  resourceId: nsg3[i].id
}]

// convert list to object?
var someData = [
  {
    name: 'Contoso'
    value: '123'
  }
  {
    name: 'Fabrikam'
    value: '456'
  }
]
var someDataObject = toObject(someData, item => item.name, item => item.value)
output someDataObject object = someDataObject

// and back to a list?
output someDataList array = map(items(someDataObject), item => {
  name: item.key
  value: item.value
})
