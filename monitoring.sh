#!/bin/bash
arc=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
fram=$(free -m | awk '$1 == "Mem:" {printf("\033[0;35m%d\033[0m"), $2}')
uram=$(free -m | awk '$1 == "Mem:" {printf("\033[0;35m%d\033[0m"), $3}')
pram=$(free | awk '$1 == "Mem:" {printf("\033[0;35m%.2f\033[0m"), $3/$2*100}')
udisk=$(df -h --total | grep "total" | awk '{printf("\033[1;33m%s\033[0m/\033[1;33m%s \033[0m(\033[1;33m%s\033[0m) \033[0m\n", $3, $4, $5)}')
cpu1=$(top -bn1 | grep "Cpu(s)" | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | sed -n 4p | awk '{printf("\033[1;3m%.1f%%\033[0m", (100 - $1))}')
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then printf"\033[0;31mNon\033[0m" ; else printf "\033[1;3mOui\033[0m" ; fi)
ctcp=$(cat /proc/net/sockstat | grep TCP | awk '{print $3}')
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "
                   ___
             _sudZUZ#Z#XZoe_
          _jmZZ2!!-----!!X##wa
        .<wdP--           -!YZL,
       .mX2^      _%aaa__     XZ[.                               ,#.
       oZ[     _jdXY!-?S#wa   ]Xb;                              :###:
      _#e^    .]X2(     -Xw|  )XXc        ##:        :##         ^#^
     .2Z      ]X[.       xY|  ]oZ(        ##          ##
     .2#;     )3k;     _s!-   jXf     __  ##    __    ##  __      _     __          _
      1Z>     -]Xb          __#2(   ,####:## ,######. ##.#####. :### ,######. ###.####:
      -Zo;      +!4ZwaaaauZZXY     ,##   ### ##:  :## ###   ###  ##  #:   ^## ^###^ ^##:
       ^#[,       --?!!!!!!-       ##     ## ##    ## ##     ##  ##    ___,##  ##:   ^##
        XUb;.                      ##     ## #######: ##     ##  ##  .#######  ##^    ##
        ^Y##u                      ##     ## ##^      ##     ##  ##  ##^  ^##  ##     ##
          <lois                    ##.   ,## ##       ##    ,##  ##  ##    ##  ##     ##
            -frUd                  :#:._,### ##:__,## ##:__,##^ ,##. ##.__:##. ##     ##
               ---                 ^:####  ## #####^  ^######^  #### ^#####^## ##     ##

                                        [Architecture]

    $arc
   ____________________________________________________________________________________

     Coeur(s) Physique(s)               $pcpu
     vCpu(s)                            $vcpu
     Utilisation RAM                    $uram/${fram}MB ($pram%)
     Utilisation Disque                 $udisk
     Charge CPU                         $cpu1
     Dernier boot                       $lb
     Utilisation LVM                    $lvmu
     Connexions TCP                     $ctcp ETABLIE(S)
     Utilisateur(s) actif(s)            $ulog
     Addresse IP                        $ip (MAC: $mac)
     Actions Sudo                       $cmds Commandes
   ____________________________________________________________________________________"
