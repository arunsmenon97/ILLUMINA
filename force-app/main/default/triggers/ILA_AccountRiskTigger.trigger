/**
* @File Name : ILA_AccountRiskTigger
* @Description : Trigger class for Account risk changes
* @Author : ARUN
* @Last Modified By :
* @Last Modified On : November 30, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 30, 2024 |   | Initial Version
**/
trigger ILA_AccountRiskTigger on Account (after insert,after update) {
    
    List<Account> changedAccounts = new List<Account>();
    
    if(trigger.isUpdate){
        for (Account account : Trigger.new) {
            if (Trigger.oldMap.get(account.Id).ILA_Risk__c != account.ILA_Risk__c && account.ILA_Risk__c == 'High') {
                changedAccounts.add(account);
            }
        }
    }
    if(trigger.isInsert){
        for (Account account : Trigger.new) {
            if (account.ILA_Risk__c == 'High') {
                changedAccounts.add(account);
            }
        }
    }
    
    if (!changedAccounts.isEmpty()) {
        List<ILA_High_Risk_Event__e> events = new List<ILA_High_Risk_Event__e>();
        
        for (Account account : changedAccounts) {
            ILA_High_Risk_Event__e event = new ILA_High_Risk_Event__e();
            event.ILA_Risk__c = account.ILA_Risk__c;
            event.ILA_Account_Id__c = account.Id;
            events.add(event);
            //system.debug('highhhhhhhhhhhhh');
        }      
        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
    }
}