provider "oci" {
  auth                = var.oci_provider.auth
  config_file_profile = var.oci_provider.config_file_profile
  # tenancy_ocid        = var.oci_provider.tenancy_ocid
  # user_ocid           = var.oci_provider.user_ocid
  # private_key         = var.private_key_path
  # fingerprint         = var.fingerprint
  # region              = var.oci_provider.region
}

# reference to setup credentials

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth

#go to https://cloud.oracle.com/identity/users
#open you user api-key section
#click on add apikey
#download private key to ~/.oci/my-api-key.pem
#click on create
#copy the config file snippet content in ~/oci/config sobstituting the key_file value with ~/.oci/my-api-key.pem



# (future) reference to setup ~/.oci/config

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#terraformproviderconfiguration_topic-SDK_and_CLI_Config_File

# https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm#SDK_and_CLI_Configuration_File
