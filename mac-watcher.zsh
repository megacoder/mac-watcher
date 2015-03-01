#!/bin/bash
#!/bin/zsh

ME=$(basename "${0}")
USAGE="usage: ${ME} [-i <seconds>]"

INTERVAL=15
while getopts i: c; do
	case "${c}" in
	i ) INTERVAL="${OPTARG}";;
	* ) echo "${USAGE}" >&2; exit 1;;
	esac
done

shift $(expr "${OPTIND}" - 1)

# I use zsh(1) but this will also work in bash(1).

snapshot()	{
	# Rather than cat(1), we send the files through grep(1) so we
	# have each line start with its filename.  Change the first
	# colon into a space for readability.  Strip off the '/sys/class/net'
	# lead-in and the "/address" tail.  Normalize spaces.
	/bin/grep . /sys/class/net/*/address				|
	sed -e 's/:/\t/' -e 's;/sys/class/net/;;' -e 's;/address;;'	|
	while read iface mac junk; do
		printf '%23s %s\n' "${iface}" "${mac}"
	done
}

OLD=
while :; do
	NEW=$( snapshot )
	if [[ "${OLD}" != "${NEW}" ]]; then
		date
		diff -y --width=90 <(echo "${OLD}") <(echo "${NEW}")
		OLD="${NEW}"
	fi
	sleep "${INTERVAL}"
done
