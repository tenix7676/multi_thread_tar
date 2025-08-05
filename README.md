A small script to make sure tar uses multithreading. 
## Installation
Copy the code below to your `~/.bashrc` config and use tar as you normally would, now multithreaded!
```sh
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
}
```
