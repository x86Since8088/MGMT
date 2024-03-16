#!/bin/sh

RouterIPAddress="192.168.2.254"

R=$(curl -k "https://$RouterIPAddress/cgi-bin/broadbandstatistics.ha")

# Attempt robust parsing
# Data=$(echo "$R" | awk -F '[<>]' '/<th/{gsub(/^[[:space:]]+|^[[:space:]]+$/,"",$3); print "\"" $3 "\": \"" $6 "\""}')
#     $R.Content.ToString() -split "\s*\<tr[^\>]*\>|\</tr[^\>]*>|\<br[^\>]*\>\s*" -match '\<th' -replace '\&nbsp;',' ' -replace '\s*?\n\s*' -replace '\s*\<th[^\>]*\>\s*','{"' -replace '\s*\</th\>\<td[^\>]*\>\s*','":"' -replace '\s*\</td\>\s*','"}' |
# awk '{split($R,a,"\s*\<tr[^\>]*\>|\</tr[^\>]*>|\<br[^\>]*\>\s*");print a}'
echo """
 {
    awk -F'<tr[^>]*>' '''
    /<th>/ {
        gsub(/<\/?th>/, "", $0)
        name = $0
    }
    /<td>/ {
        gsub(/<\/?td>/, "", $0)
        value = $0
        data[name] = value
    }
    END {
        printf "{"
        sep = ""s
        for (key in data) {
            printf "%s\"%s\":\"%s\"", sep, key, data[key]
            sep = ","
        }
        print "}"
    }
'''
}
""" > /dev/null 

Data="{$(
    echo "$R" | 
    awk '{split($0,a,"<tr"); print a[3],a[2],a[1]}' |
    sed -e 's/\<th//g'
)}"
if [ -n "$Data" ]; then
    echo "{ $Data }"
else
    echo "There was an issue with robust parsing. Attempting to parse the page with a less robust method."

    BroadbandIPv4Address=$(echo "$R" | grep -oE 'Broadband IPv4 Address.*' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    BroadbandIPv4Gateway=$(echo "$R" | grep -oE 'Gateway IPv4 Address.*' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

    echo "{ \"BroadbandIPv4Address\": \"$BroadbandIPv4Address\", \"BroadbandIPv4Gateway\": \"$BroadbandIPv4Gateway\" }"
fi
