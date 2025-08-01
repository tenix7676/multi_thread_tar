A small script to make sure tar uses multithreading. 
## Installation
Copy the code below to your '~/.bashrc' config and use tar as you normally would, now multithreaded!
```sh
_is_a_flag()
{
	[[ "${1:0:1}" == - ]] && [[ "${1:1:1}" != - ]]
}

_flag_into_many_flags()
{
	local flag="${1:1}"
	for (( i=0; i<${#flag}; i++ )); do
		printf " -${flag:$i:1}"
	done
}

_parse()
{
	for arg in "$@"; do
		if _is_a_flag "$arg"; then
			_flag_into_many_flags "$arg"
		else
			printf " $arg"
		fi
	done
}

tar()
{
local ARGS=$(_parse "$@")
local NEW_ARGS=$(echo "${ARGS}" | sed '
	s/ -z/ --use-compress-program=pigz/g
	s/ -j/ --use-compress-program=pbzip2/g
	s/ -J/ --use-compress-program=pixz/g
')
command tar ${NEW_ARGS[@]}
}
```
