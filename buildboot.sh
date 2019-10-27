/opt/karaf/bin/karaf run & 
sleep 333
/opt/karaf/bin/client -r 93  "shell:sleep 1;"
sleep 93
/opt/karaf/bin/client -r 3  -l 2 "shutdown -f;" 
sleep 33 
