#!/bin/bash

# VARIABLES <<<<<<<<<<<<<<<<<<<<<<<<<<
VALID_FILE_PATH=true

# MAIN <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Check if paramater is present.
if [[ -z ${1} ]]
then
	echo -e "Please enter a file name as a parameter, preceeded by a full path if necessary.\nRealtive paths will work."
	echo "USAGE: $ mkscript /path/to/new/script.sh"
	exit 1
fi

# Create the file if filepath is valid, otherwise exit.
touch ${1} > /dev/null || exit 1

if ${VAILD_FILE_PATH}
then
	# Write compulsory bash statement to new script.
	echo -e "#!/bin/bash\n" > ${1}
	
	# Change permissions on new script.
	sudo chmod 777 ${1}
fi

