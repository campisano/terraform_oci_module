# Terraform (semi-)minimalistic modules for Oracle OCI

From [campisano.org/Oci (Cloud)](http://www.campisano.org/wiki/en/Oci_(Cloud)#Setup_free_virtual_machines_using_Terraform)

This project shows how to use (semi-)minimalistic Terraform modules (configurable with a custom vars.json file) to create a [free-tier infrastructure](https://www.oracle.com/cloud/free/#always-free) with 2 free Virtual Private Servers (VPS) in the Oracle Cloud Infrastructure (OCI).



Project Structure
-----------------

```
./
├── modules/oci/instance        (module for instance provision)
│   ├── input.ts                  (module input vars)
│   ├── main.ts                   (module resources)
│   └── output.ts                 (module output vars)
│
├── modules/oci/subnet          (module for subnet provision)
│   ├── input.ts                  (module input vars)
│   ├── main.ts                   (module resources)
│   └── output.ts                 (module output vars)
│
├── modules/oci/vcn             (module for vcn provision)
│   ├── input.ts                  (module input vars)
│   ├── main.ts                   (module resources)
│   └── output.ts                 (module output vars)
│
├── init_script.sh              (optional script to run at first boot)
├── input.ts                    (declare main input vars)
├── main.ts                     (main source file to setup resources)
├── output.ts                   (declare main output vars)
├── provider.tf                 (provider configs)
├── versions.tf                 (terraform versions configs)
├── Makefile                    (make file with a set of useful commands)
└── vars.json                   (json file to define custom variables)
```



Minimum System Requirements
---------------------------

* An OCI [account](https://www.oracle.com/cloud/sign-in.html), a [free account](https://www.oracle.com/cloud/free/) can be used.

* The Oracle config file (`~/.oci/config`) configured to have access to the OCI API services using [APIKeyAuth](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth) authentication. This will be used by Terraform to create and manage resources e.g. the VPS creation. Follow those steps:

```
go to https://cloud.oracle.com/identity/users
open you user api-key section
click on add apikey
download private key to ~/.oci/my-api-key.pem
click on create
save the config file snippet content in ~/.oci/config sobstituting the key_file value with ~/.oci/my-api-key.pem
```

* Configure the tenancy_ocid variable in the var.json file with the value saved in the `~/.oci/config` file.

* An SSH Key Pair to have access to the VPS. To create a new keypair, do the following:

```
ssh-keygen -q -t rsa -b 2048 -N '' -f ~/.ssh/oci-keypair
chmod 400 ~/.ssh/oci-keypair
```

* The Terraform command. To install, see [the official doc](https://www.terraform.io/downloads.html).

* Install [Make](https://www.gnu.org/software/make/). This tool is used to run predefined Terraform commands.

* Choose a O.S. image to use for your VPSs. A list is available [here](https://docs.oracle.com/en-us/iaas/images/). In this example we will use `Canonical-Ubuntu-20.04-Minimal-2021.05.17-0`.



# Usage



Prepare
-------

Use `make init` command to prepare Terraform local data and to download the Oracle provider driver.

Create
------

Use `make apply` to create the whole infrastructure.

Destroy
-------

Use `make destroy` to destroy the whole infrastructure.



Example
-------

* Output example for the `make apply` command:

![make apply image](/docs/README.md/make_apply.png?raw=true "make apply command")

* Output example for the `make destroy` command:

![make destroy image](/docs/README.md/make_destroy.png?raw=true "make destroy command")

* Login

You can login in your VPS with the command `ssh -i ~/.ssh/oci-keypair root@111.22.33.44`. Remember to replace `111.22.33.44` with the static ip of your new machine. It is shown in the output of the `make apply` command.



Customize
---------

This project can create several VPSs. Each machine can be configured with a static ip, and an initial script can be defined to customize the machine O.S. so that software can be added or removed programmatically. This is configurable modifying the variables defined in the `vars.json` file.

The following snippet is a sample of a `vars.json` to:
* configure the oci provider;
* configure the oci modules that creates:
  * a virtual network;
  * two subnetworks;
  * a machine in each subnetwork.

```
{
    "oci_provider": {
        "auth": "APIKey",
        "config_file_profile": "DEFAULT",
        "tenancy_ocid": "ocidX.tenancy.ocX..."
    },
    "oci_vcn_module": {
        "tf-vcn1": {
            "cidr_block": "10.1.0.0/16"
        }
    },
    "oci_subnet_module": {
        "tf-vcn1-subnet1": {
            "vcn_name": "tf-vcn1",
            "cidr_block": "10.1.20.0/24"
        },
        "tf-vcn1-subnet2": {
            "vcn_name": "tf-vcn1",
            "cidr_block": "10.1.21.0/24"
        }
    },
    "oci_instance_module": {
        "tf-instance1": {
            "subnet_name": "tf-vcn1-subnet1",
            "keypair_path": "~/.ssh/oci-keypair.pub",
            "instance_shape": "VM.Standard.E2.1.Micro",
            "image_ocid": "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaae37x4oll5jixkbmkc63pk25ggvjh3h4iug7trp35agtexcpatw6q",
            "boot_disk_size": 100,
            "static_ip": true,
            "init_script_path": "init_script.sh"
        },
        "tf-instance2": {
            "subnet_name": "tf-vcn1-subnet2",
            "keypair_path": "~/.ssh/oci-keypair.pub",
            "instance_shape": "VM.Standard.E2.1.Micro",
            "image_ocid": "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaae37x4oll5jixkbmkc63pk25ggvjh3h4iug7trp35agtexcpatw6q",
            "boot_disk_size": 100,
            "static_ip": true,
            "init_script_path": "init_script.sh"
        }
    }
}
```
