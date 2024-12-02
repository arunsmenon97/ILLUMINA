/**
* @File Name : ILA_HighRiskEventTrigger.cls
* @Description : Trigger to create cases on high risks
* @Author : ARUN
* @Last Modified By :
* @Last Modified On : November 30, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 30, 2024 |   | Initial Version
**/

trigger ILA_HighRiskEventTrigger on ILA_High_Risk_Event__e (after insert) {
    List<Case>caseLst = new  List<Case>();
    set<id>ownerIds = new set<id>();
    for (ILA_High_Risk_Event__e event : Trigger.new) {
        ownerIds.add(event.CreatedById); 
    }
    try{ 
        User caseUser = [SELECT id FROM User WHERE  Id NOT IN :ownerIds AND Name = 'Integration User' LIMIT 1];
        for (ILA_High_Risk_Event__e event : Trigger.new) {
            Case c = new Case();
            c.AccountId = event.ILA_Account_Id__c;
            c.OwnerId = caseUser.id;
            c.Subject = 'High Risk Case';
            c.Description = 'High Risk Case';
            c.Priority ='High';
            c.Status ='Open';
            caseLst.add(c);
        }
        if (!caseLst.isEmpty()) {
            insert caseLst;
           // system.debug('caseLst'+caseLst);
        }
    }catch(exception e){
        system.debug(e.getMessage());
    }
    
}