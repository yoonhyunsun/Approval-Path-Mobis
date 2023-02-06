public without sharing class SSO {
   public PageReference loginSSO(){
        String samlName = ApexPages.currentPage().getParameters().get('saml');
            String samlId;
        if(samlName == null){
            List<SamlSsoConfig> ssoList = [SELECT Id FROM SamlSsoConfig WHERE DeveloperName = 'AzureSSO'];
            if(ssoList.size() !=0  )samlId = ssoList[0].Id;
            
        }else{
            List<SamlSsoConfig> ssoList = [SELECT Id FROM SamlSsoConfig WHERE DeveloperName = :samlName];
            if(ssoList.size() !=0  )samlId = ssoList[0].Id;
        }

        String ssoUrl = Auth.AuthConfiguration.getSamlSsoUrl(null, '/', samlId);
        PageReference pageRef = new PageReference(ssoUrl);
        return pageRef;
    }
}