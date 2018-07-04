#!/bin/bash


# <<---------------------------------------- >>
# <<<< VARIABLES >>>>
# <<---------------------------------------- >>

USER_OPTIONS=("all" "scripts" "docs" "pdf" "dirs")
FILE_TYPES=("*" "*.sh" "*.txt" "*.pdf" "*")
FIND_TYPE="f"
FILE_TYPE=""


# <<---------------------------------------- >>
# <<<< FUNCTIONS >>>>
# <<---------------------------------------- >>

USAGE() {
	echo "----------------------------------------------------"
	echo -e "USAGE: my baseDir option optionalSearch"
        echo "Options include:"
        for OPTION in ${USER_OPTIONS[@]}
        do
                echo "  > ${OPTION}"
        done
	echo "OptionalSearch is essentially input to a grep to filter results."
	echo "NOTE: baseDir may be set prior to calling script."
        echo "----------------------------------------------------"
        exit ${1}
}

# <<<< Likely that aliases will be set with param $1 (baseDir) set, so when calling this script you are working from param $2, the 'option'
USAGE2() {
        echo "----------------------------------------------------"
        echo -e "USAGE: my option optionalSearch"
        echo "Options include:"
        for OPTION in ${USER_OPTIONS[@]}
        do      
                echo "  > ${OPTION}"
        done 
        echo "OptionalSearch is essentially input to a grep to filter results."
        echo "----------------------------------------------------"
        exit ${1}
}


# <<---------------------------------------- >>
# <<<< MAIN >>>>
# <<---------------------------------------- >>

# <<<< Deal with directory to be searched >>>>
if [[ -z $1 ]] || [[ ! -d $1 ]]
then
	USAGE 1
else
	BASE_DIR=$1	
fi

# <<<< Determine FILE_TYPE and FIND_TYPE >>>>
if [[ -z "$2" ]]
then 
	FILE_TYPE="*"
else
	if [[ "$2" == "dirs" ]]
	then
		FIND_TYPE="d"
		FILE_TYPE="*"			
	else     
		for ((i=0; i <=${#USER_OPTIONS}; i++))
        	do
                	if [[ "$2" == ${USER_OPTIONS[$i]} ]]
                	then
                        	FILE_TYPE="${FILE_TYPES[$i]}"
                	fi
       		done
	fi

        if [[ -z "$FILE_TYPE" ]]
        then
                USAGE 2
        fi
fi

# <<<< Generate PATHS_FOUND >>>>
if [[ -n $3 ]]
then 
	PATHS_FOUND=($(find $BASE_DIR -type "$FIND_TYPE" -name "$FILE_TYPE" | grep "$3"))
else
	PATHS_FOUND=($(find $BASE_DIR -type "$FIND_TYPE" -name "$FILE_TYPE"))
fi

# <<<< PROCESS RESULTS >>>>

if [[ ${#PATHS_FOUND[@]} -eq 0 ]]
then
	echo "----------------------------------------------------"
	echo "There are no files/dirs that meet your criteria."
        echo "----------------------------------------------------"

elif [[ ${#PATHS_FOUND[@]} -eq 1 ]]
then
	# <<<< Immediately vim file or ls dir as only one option >>>>
	if [[ -f "$PATHS_FOUND" ]]
	then
		echo "$PATHS_FOUND"
		if [[ $2 = pdf ]]
		then
			open $PATHS_FOUND
		else
			vim $PATHS_FOUND
		fi
	else
		echo "Enter 'y' or 'yes' to ls $PATHS_FOUND."
		read LS_OR_NOT
		if [[ $LS_OR_NOT == "y" || $LS_OR_NOT == "yes" ]]
		then
			ls -al $PATH_FOUND
		else
			exit 0
		fi
	fi

else 

	# <<<< Display options and request user selection >>>>
	declare -i "i=1"
	echo "Select an option:"
	if [[ $FIND_TYPE = "f" ]]
	then
		for  PATH_FOUND in ${PATHS_FOUND[@]}
		do	
			if [[ -f $PATH_FOUND ]]
			then
				echo "$i > $PATH_FOUND"
			fi 
			i=$i+1
		done
	elif [[ $FIND_TYPE = "d" ]]
	then
		for  PATH_FOUND in ${PATHS_FOUND[@]}
                do
                        if [[ -d $PATH_FOUND ]]
                        then
                                echo "$i > $PATH_FOUND"
                        fi
                        i=$i+1
                done
	fi
	
	# <<<< Process user selection and either vim file or ls dir >>>>
	declare -i SELECT
	read SELECT
	if [[ $SELECT =~ ^[0-9]+$ ]]
	then
		PATH_FOUND="${PATHS_FOUND[$SELECT-1]}"
		if [[ $FIND_TYPE = "d" ]]
		then
			echo $PATH_FOUND
			ls -al $PATH_FOUND 
		else
			vim $PATH_FOUND
		fi
	fi

fi



