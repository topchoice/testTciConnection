public with sharing class AutoConvertLeadsToExistingAccount {
	
	@InvocableMethod
	public static void AutoConvertLeadsToExistingAccount(List<Id> LeadIds) {
		
		LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
		List<Lead> leadList = [SELECT Company FROM Lead WHERE Id IN: LeadIds];
		Set<String> companyList = new Set<String>();

		for ( Lead l : leadList) {
			companyList.add(l.Company);
		}

		List<Account> accList = [SELECT Name FROM Account WHERE Name IN: companyList];
		Map<String, Id> mapOfAccName = new Map<String, Id>();

		for ( Account acc : accList) {
			mapOfAccName.put(acc.Name, acc.Id);
		}

		for ( Lead l : leadList) {
			Database.LeadConvert leadConvert = new Database.LeadConvert();
			leadConvert.setLeadId(l.Id);
			leadConvert.setConvertedStatus(CLeadStatus.MasterLabel);
			leadConvert.setAccountId(mapOfAccName.get(l.Company));
			// leadConvert.setDoNotCreateOpportunity(TRUE);
			MassLeadconvert.add(leadConvert);
		}
    
        if (!MassLeadconvert.isEmpty()) {
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);
        }
	}
}