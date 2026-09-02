using './main.bicep'

param prefix = 'a2z104'
param environment = 'lab'
param deployBillableCompute = false
param deployBastion = false
param deployAlerts = false
param alertEmail = ''
