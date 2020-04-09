alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'

# Show open ports
alias openports='netstat -nape --inet'

# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
        awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

# IP address lookup
alias my="whatsmyip"
function whatsmyip() {
    # Dumps a list of all IP addresses for every device
    # /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';

    # Internal IP Lookup
    echo -n "Internal IP: "
    /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

    # External IP Lookup
    echo -en "External IP: $(wget https://api.ipify.org -O - -q)\n"
}

# Show current network information
netinfo() {
    echo "--------------- Network Information ---------------"
    ifconfig | awk /'inet addr/ {print $2}'
    echo ""
    ifconfig | awk /'Bcast/ {print $3}'
    echo ""
    ifconfig | awk /'inet addr/ {print $4}'

    ifconfig | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
}
