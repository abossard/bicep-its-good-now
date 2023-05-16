param deploy bool = false
param location string = resourceGroup().location

// inline conditionals
var dnsZoneName = deploy ? 'mydnszone' : 'myotherdnszone'

// conditional deployment
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = if (deploy) {
  name: dnsZoneName
  location: location
}

// what if it's unclear if a resource already exists?
// ARM can't check of if-exists, but you might know if it does?
@allowed([
  'new'
  'existing'
])
param newOrExisting string = 'new'
param salt string = toLower(substring(uniqueString(resourceGroup().id),0,4))
var storageAccountName = 'anbost${salt}'

resource saNew 'Microsoft.Storage/storageAccounts@2022-09-01' = if (newOrExisting == 'new') {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource saExisting 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (newOrExisting == 'existing') {
  name: storageAccountName
}

output storageAccountId string = ((newOrExisting == 'new') ? saNew.id : saExisting.id)

// alternative you can set a tag and evaluate that
var tagName = 'existing'
var isExisting = contains(resourceGroup().tags, tagName) ? resourceGroup().tags[tagName] == 'true' ? true : false : false
resource saNew2 'Microsoft.Storage/storageAccounts@2022-09-01' = if (!isExisting) {
  name: '${storageAccountName}2'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
resource defaultTags 'Microsoft.Resources/tags@2022-09-01' = if (!isExisting) {
  name: 'default'
  scope: resourceGroup()
  properties: {
    tags: {
      '${tagName}': true
    }
  }
}

resource saExisting2 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (isExisting) {
  name: '${storageAccountName}2'
}

output storageAccountId2 string = !isExisting ? saNew2.id : saExisting2.id
output isFreshDeployment bool = !isExisting
