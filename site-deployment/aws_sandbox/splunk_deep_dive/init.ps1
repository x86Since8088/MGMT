# This file is used to initialize the sandbox environment. It is executed by the sandbox environment when the environment is first created.
# These credentiuals are for temporary lab environments only. They are not to be used in production environments.
$Sandbox = [hashtable]::Synchronized(@{
    UserName = 'cloud_user_p_edb6a8dc@realhandsonlabs.com'
    Password = '^tQnUliTsW2mQ2RiCHOE'
    url      = 'https://portal.azure.com/#@realhandsonlabs.com/resource/subscriptions/80ea84e8-afce-4851-928a-9e2219724c69/resourceGroups/1-9ae6afc1-playground-sandbox/overview'
    ApplicationID = 'eec31c0e-29ab-4226-b771-a87423e73baf'
    Secret   = 'YXK8Q~8OzC.0esfgih3jRb4MhGnLoQtfFnwh7cYj'
    SplunkEnterpriseForLinuxDownloadURL = 'https://download.splunk.com/products/splunk/releases/9.2.0.1/linux/splunk-9.2.0.1-d8ae995bf219-Linux-x86_64.tgz'
    SPLUNK_USERNAME = 'eddie'
    SPLUNK_PASSWORD = '$p|unkEnt3rpr!$e'
    SplunkLinuxHostIP = '4.227.161.164'
    SplunkLinuxHostKeyFilePath = 'C:\Users\Eddie\Downloads\splunkdeepdive_key.pem'
})

$Sandbox = [hashtable]::Synchronized(@{
    UserName = 'cloud_user'
    Password = ']a(3QsPv'
    SPLUNK_USERNAME = 'admin'
    SPLUNK_PASSWORD = '$p|unkEnt3rpr!$e'
    SplunkLinuxHostIP = '3.236.158.249'
    SplunkEnterpriseForLinuxDownloadURL = 'https://download.splunk.com/products/splunk/releases/9.2.0.1/linux/splunk-9.2.0.1-d8ae995bf219-Linux-x86_64.tgz'
    SplunkLinuxHostKeyFilePath = ''
})
