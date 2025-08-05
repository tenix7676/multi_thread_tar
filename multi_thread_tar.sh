#!/usr/bin/env bash

#For DEBUGGING:
#function list()
#{
#	for arg in "$@"
#	do
#		printf \'"${arg}"\''\n'
#	done
#}

___is_a_flag()
{
	[[ "${1:0:1}" == - ]] && [[ "${1:1:1}" != - ]]
}

___flag_into_many_flags()
{
	local flag="${1:1}"
	for (( i=0; i<${#flag}; i++ )); do
		echo "-${flag:$i:1}"
	done
}

___parse()
{
	declare -n in=$1
	declare -n out=$2	
	for arg in "${in[@]}"
	do
		if ___is_a_flag "$arg"
		then
			out+=($(___flag_into_many_flags "$arg"))
		else
			out+=("${arg}")
		fi
	done
}

tar()
{
	local args=("$@")
	local PARSED_ARGS
	___parse args PARSED_ARGS
	local NEW_ARGS
	for arg in "${PARSED_ARGS[@]}"
	do
		local new_arg="$(printf "%s" "$arg" | sed '
		s/-z/--use-compress-program=pigz/g
		s/-j/--use-compress-program=pbzip2/g
		s/-J/--use-compress-program=pixz/g
		')"
		NEW_ARGS+=("${new_arg}")
	done
	command tar ${NEW_ARGS[@]}

	#For DEBUGGING:
	#printf "\nOG:\n"
	#list "${@}"
	#printf "\nParsed:\n"
	#list "${PARSED_ARGS[@]}"
	#printf "\nNew list\n"
	#list "${NEW_ARGS[@]}"
}

#For DEBUGGING:
#tar -zfd gig --hello="Fasd asd ttt" pizza "dum mmy"
