#!/usr/bin/env bash
#
# Deploy to Azure, which requires some shell magic to make things happy
#

# Are the azure tools installed?
if [ "`command -v azure`X" == "X" ]; then 
    echo "You must have the Azure xplat-cli installed."
    echo "https://azure.microsoft.com/en-us/documentation/articles/xplat-cli/"
    exit 1
fi

# Get the machine name from the command line or prompt for it
if [ "x$1" = "x" ]; then
	echo "Please enter a name for your virtual machine: "
	read MACHINE_NAME
	export NITROGEN_VM_NAME="$MACHINE_NAME"
else
	export NITROGEN_VM_NAME="$1"
fi

# Subscription
echo -n "Retrieving subscription..."
export AZURE_SUBSCRIPTION_ID="`azure account show | grep ID | grep -v Tenant | awk '{ print $4 }'`"
echo "done ($AZURE_SUBSCRIPTION_ID)."

# Download management certificate
echo -n "Retrieving management certificate..."
export AZURE_MANAGEMENT_CERT="`azure account cert export | grep 'exported to' | awk '{ print $5 }'`"
echo "done. ($AZURE_MANAGEMENT_CERT)"

# Make SSH Key Pair
echo -n "Making ssh key pair for login..."
openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 -keyout NitrogenPrivateKey.key -out NitrogenCert.pem >& /dev/null 2>&1
chmod 600 NitrogenPrivateKey.key
export NITROGEN_CERT="NitrogenCert.pem"
export NITROGEN_KEY="NitrogenPrivateKey.key"
echo "done."

# Save settings
echo "export NITROGEN_VM_NAME=\"$NITROGEN_VM_NAME\"" > bash.settings
echo "export AZURE_SUBSCRIPTION_ID=\"$AZURE_SUBSCRIPTION_ID\"" >> bash.settings
echo "export AZURE_MANAGEMENT_CERT=\"$AZURE_MANAGEMENT_CERT\"" >> bash.settings
echo "export NITROGEN_KEY=\"$NITROGEN_KEY\"" >> bash.settings
echo "export NITROGEN_CERT=\"$NITROGEN_CERT\"" >> bash.settings

echo "To provision your nitrogen machines please execute the following commands:"
echo "> . bash.settings"
echo "> vagrant up --provider azure --provision"
