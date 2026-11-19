
set systemTime [clock seconds]
set tStart [clock clicks -milliseconds] 

wipe   # clear memory of all past model definitions
model BasicBuilder -ndm 3 -ndf 6;	# Define the model builder, ndm=#dimension, ndf=#dofs

set dataDir Data;				# set up name of data directory (you can remove this)
file mkdir $dataDir; 				# create data directory






set ppNodesInfo [open ppNodesInfo.dat w]

set Nstory 12

set Nx 4
set Ny 4
set L [expr 6.1/3]


#Viscous damper-base node
     node 100001 0. 0 0.
     fix 100001 1 1 1 1 1 1
     node 110001 [expr 3*$L] 0 0.
     fix 110001 1 1 1 1 1 1


#Brackets & hhhhhhhhhh
for {set n 1} {$n <=[expr $Nstory+1]} {incr n 1} {
     if {$n == 1} {
       for {set j 1} {$j <=[expr 3*$Nx+1]} {incr j 1} {
            set nodeNum [expr 120000+100*($n-1)+$j]
            set xCoord [expr ($j-1)*$L/$Nx]
            set yCoord 0
            set zCoord 0
            node $nodeNum $xCoord $yCoord $zCoord
            
            puts $ppNodesInfo "$nodeNum  $xCoord  $yCoord $zCoord"
            fix $nodeNum 1 1 1 1 1 1
       }
     } else {
       for {set j 1} {$j <=[expr 3*$Nx+1]} {incr j 1} {
            set nodeNum [expr 120000+100*($n-1)+$j]
            set xCoord [expr ($j-1)*$L/$Nx]
            set yCoord [expr 4.6+4*($n-2)]
            set zCoord 0
            node $nodeNum $xCoord  $yCoord $zCoord
            puts $ppNodesInfo "$nodeNum  $xCoord  $yCoord $zCoord"




       }
     }
}

for {set jj 1} {$jj <=[expr 3*$Nx+1]} {incr jj 1} {
mass [expr 120000+100*1+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*2+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*3+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*4+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*5+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*6+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*7+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*8+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*9+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*10+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*11+$jj] 5.569 0. 0. 0. 0. 0.
mass [expr 120000+100*12+$jj] 6.135 0. 0. 0. 0. 0.

}


equalDOF 120101 120113 2 
equalDOF 120201 120213 2 
equalDOF 120301 120313 2 
equalDOF 120401 120413 2 
equalDOF 120501 120513 2 
equalDOF 120601 120613 2 
equalDOF 120701 120713 2 
equalDOF 120801 120813 2 
equalDOF 120901 120913 2 
equalDOF 121001 121013 2 
equalDOF 121101 121113 2 
equalDOF 121201 121213 2 





node 15000 -1 0 0
node 15001 -1 4.6 0
node 15002 -1 8.6 0
node 15003 -1 12.6 0
node 15004 -1 16.6 0
node 15005 -1 20.6 0
node 15006 -1 24.6 0
node 15007 -1 28.6 0
node 15008 -1 32.6 0
node 15009 -1 36.6 0
node 15010 -1 40.6 0
node 15011 -1 44.6 0
node 15012 -1 48.6 0

fix 15000 1 1 1 1 1 1






#mass $nodeTag (ndf$MasValues)

#mass 3 1390 0. 1390 0. 0. 0.
#mass 4 1390 0. 1390 0. 0. 0.









# MATERIAL parameters -------------------------------------------------------------------



set matTag 55
set E [expr 12400*1000000/1000]
uniaxialMaterial Elastic $matTag $E 

set nfdw 10; 		# number of fibers along dw
set nftw 10;	 	      # number of fibers along tw

set GJ 1;
set d 0.9
set b 0.9
set y2 [expr -$d/2]
set y3 [expr  $d/2]
set z2 [expr -$b/2]
set z3 [expr  $b/2]

section fiberSec  10 -GJ $GJ {
   		patch quadr  $matTag  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
}

set PDelta "ON"
#set PDelta "OFF"

# Geometric transformation for columns
if {$PDelta == "ON"} {
   geomTransf LinearWithPDelta  1 0 0 1
} else {
   geomTransf Linear  1 0 0 1
}

#geomTransf Linear 1 0 0 1
set np 10
element nonlinearBeamColumn 10560101 15000 15001 $np 10 1;
element nonlinearBeamColumn 10560102 15001 15002 $np 10 1;
element nonlinearBeamColumn 10560103 15002 15003 $np 10 1;
element nonlinearBeamColumn 10560104 15003 15004 $np 10 1;
element nonlinearBeamColumn 10560105 15004 15005 $np 10 1;
element nonlinearBeamColumn 10560106 15005 15006 $np 10 1;
element nonlinearBeamColumn 10560107 15006 15007 $np 10 1;
element nonlinearBeamColumn 10560108 15007 15008 $np 10 1;
element nonlinearBeamColumn 10560109 15008 15009 $np 10 1;
element nonlinearBeamColumn 10560110 15009 15010 $np 10 1;
element nonlinearBeamColumn 10560111 15010 15011 $np 10 1;
element nonlinearBeamColumn 10560112 15011 15012 $np 10 1;

set d 0.01
set b 1
set y2 [expr -$d/2]
set y3 [expr  $d/2]
set z2 [expr -$b/2]
set z3 [expr  $b/2]

section fiberSec  20 -GJ $GJ {
   		patch quadr  $matTag  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
}


set d 0.5
set b 0.5
set y2 [expr -$d/2]
set y3 [expr  $d/2]
set z2 [expr -$b/2]
set z3 [expr  $b/2]

section fiberSec  21 -GJ $GJ {
   		patch quadr  $matTag  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
}

set IDBeamTransf2 1
element nonlinearBeamColumn 10560201 15001 120101 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560202 15002 120201 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560203 15003 120301 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560204 15004 120401 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560205 15005 120501 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560206 15006 120601 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560207 15007 120701 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560208 15008 120801 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560209 15009 120901 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560210 15010 121001 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560211 15011 121101 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "
element nonlinearBeamColumn 10560212 15012 121201 $IDBeamTransf2 "HingeRadau 20 0.05 20 0.05 21 "





set secTag 1
set nu 0.372
set h 0.191
set rho 0.456
section ElasticMembranePlateSection $secTag $E $nu $h $rho

#nDMaterial ElasticIsotropic $secTag $E $nu

set secArgs "1"


set Plate ShellMITC4
for {set m 1} {$m <=[expr $Nstory]} {incr m 1} {
     if {$m == 1} {
        #Left CLT panel
        block2D $Nx $Ny 1 1 $Plate $secArgs "
        1 0. 0. 0.
        2 $L 0. 0.
        3 $L 4.6 0.
        4 0 4.6 0.
        "

        #Center CLT panel
        block2D $Nx $Ny 26 26 $Plate $secArgs "
        1 $L 0. 0.
        2 [expr 2*$L] 0. 0.
        3 [expr 2*$L] 4.6 0.
        4 $L 4.6 0.
        "

        #Right CLT panel
        block2D $Nx $Ny 51 51 $Plate $secArgs "
        1 [expr 2*$L] 0. 0.
        2 [expr 3*$L] 0. 0.
        3 [expr 3*$L] 4.6 0.
        4 [expr 2*$L] 4.6 0.
        "
     } else {
        #Left CLT panel
        block2D $Nx $Ny [expr 1000*($m-1)+1] [expr 1000*($m-1)+1] $Plate $secArgs "
        1 0. [expr 4.6+4*($m-2)] 0.
        2 $L [expr 4.6+4*($m-2)] 0.
        3 $L [expr 4.6+4*($m-1)] 0.
        4 0 [expr 4.6+4*($m-1)] 0.
        "

        #Center CLT panel
        block2D $Nx $Ny [expr 1000*($m-1)+26] [expr 1000*($m-1)+26] $Plate $secArgs "
        1 $L [expr 4.6+4*($m-2)] 0.
        2 [expr 2*$L] [expr 4.6+4*($m-2)] 0.
        3 [expr 2*$L] [expr 4.6+4*($m-1)] 0.
        4 $L [expr 4.6+4*($m-1)] 0.
        "

        #Right CLT panel
        block2D $Nx $Ny [expr 1000*($m-1)+51] [expr 1000*($m-1)+51] $Plate $secArgs "
        1 [expr 2*$L] [expr 4.6+4*($m-2)] 0.
        2 [expr 3*$L] [expr 4.6+4*($m-2)] 0.
        3 [expr 3*$L] [expr 4.6+4*($m-1)] 0.
        4 [expr 2*$L] [expr 4.6+4*($m-1)] 0.
        "
      }
}

fixZ 0.0 0 0 1 0 0 0

#mass 211 10000 0. 10000 0. 0. 0.
#mass 231 10000 0. 10000 0. 0. 0.




set d 1
set b 0.191
set y2 [expr -$d/2]
set y3 [expr  $d/2]
set z2 [expr -$b/2]
set z3 [expr  $b/2]

section fiberSec  30 -GJ $GJ {
   		patch quadr  $matTag  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
}





for {set nnn 120002} {$nnn <= 120013} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120102} {$nnn <= 120113} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120202} {$nnn <= 120213} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120302} {$nnn <= 120313} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120402} {$nnn <= 120413} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120502} {$nnn <= 120513} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120602} {$nnn <= 120613} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120702} {$nnn <= 120713} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120802} {$nnn <= 120813} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 120902} {$nnn <= 120913} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 121002} {$nnn <= 121013} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 121102} {$nnn <= 121113} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}
for {set nnn 121202} {$nnn <= 121213} {incr nnn 1} {
element nonlinearBeamColumn [expr 650+1000500+$nnn] [expr $nnn-1] [expr $nnn]  $np 30 1;
}



set damage "energy"

#Shear bracket
set matTag 20
set ePf1 [expr 4.36]
set ePf2 [expr 20.26]
set ePf3 [expr 27.4]
set ePf4 [expr 19]
set ePd1 0.002
set ePd2 0.013
set ePd3 0.029
set ePd4 0.040
set rDispP 0.6
set rForceP 0.25
set uForceP 0.05
set gK1 0
set gK2 0
set gK3 0
set gK4 0
set gKLim 0
set gD1 0.9
set gD2 0
set gD3 0
set gD4 0
set gDLim 0.05
set gF1 0
set gF2 0
set gF3 0
set gF4 0
set gFLim 0
set gE 1
uniaxialMaterial Pinching4 $matTag $ePf1 $ePd1 $ePf2 $ePd2 $ePf3 $ePd3 $ePf4 $ePd4 $rDispP $rForceP $uForceP $gK1 $gK2 $gK3 $gK4 $gKLim $gD1 $gD2 $gD3 $gD4 $gDLim $gF1 $gF2 $gF3 $gF4 $gFLim $gE $damage


#Tension bracket
set matTag 21
set ePf1 [expr 9.81]
set ePf2 [expr 18.38]
set ePf3 [expr 23.13]
set ePf4 [expr 14.46]
set ePd1 0.00358
set ePd2 0.01
set ePd3 0.018
set ePd4 0.033
set rDispP 0.72
set rForceP 0.18
set uForceP 0.02
set gK1 0
set gK2 0
set gK3 0
set gK4 0
set gKLim 0
set gD1 0.97
set gD2 0
set gD3 0
set gD4 0
set gDLim 0.05
set gF1 0
set gF2 0
set gF3 0
set gF4 0
set gFLim 0
set gE 1
uniaxialMaterial Pinching4 $matTag $ePf1 $ePd1 $ePf2 $ePd2 $ePf3 $ePd3 $ePf4 $ePd4 $rDispP $rForceP $uForceP $gK1 $gK2 $gK3 $gK4 $gKLim $gD1 $gD2 $gD3 $gD4 $gDLim $gF1 $gF2 $gF3 $gF4 $gFLim $gE $damage



#Angle brackets of 1-story
element zeroLength 100000 120002 2 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100001 120003 3 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100002 120004 4 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 100003 120006 27 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 100004 120007 28 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100005 120008 29 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 100006 120010 52 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100007 120011 53 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100008 120012 54 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 101000 120002 2 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101001 120003 3 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101002 120004 4 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 101003 120006 27 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 101004 120007 28 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101005 120008 29 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 101006 120010 52 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101007 120011 53 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101008 120012 54 -mat 20 21 -dir 1 2 -doRayleigh 1




element zeroLength 100010 22 120102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100011 23 120103 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100012 24 120104 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 100013 47 120106 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 100014 48 120107 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100015 49 120108 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 100016 72 120110 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100017 73 120111 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100018 74 120112 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 101010 22 120102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101011 23 120103 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101012 24 120104 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 101013 47 120106 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 101014 48 120107 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101015 49 120108 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 101016 72 120110 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101017 73 120111 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101018 74 120112 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 2-story
element zeroLength 200000 120102 1002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200001 120103 1003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200002 120104 1004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 200003 120106 1027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 200004 120107 1028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200005 120108 1029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 200006 120110 1052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200007 120111 1053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200008 120112 1054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 201000 120102 1002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201001 120103 1003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201002 120104 1004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 201003 120106 1027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 201004 120107 1028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201005 120108 1029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 201006 120110 1052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201007 120111 1053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201008 120112 1054 -mat 20 21 -dir 1 2 -doRayleigh 1




element zeroLength 200010 1022 120202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200011 1023 120203 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200012 1024 120204 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 200013 1047 120206 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 200014 1048 120207 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200015 1049 120208 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 200016 1072 120210 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200017 1073 120211 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200018 1074 120212 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 201010 1022 120202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201011 1023 120203 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201012 1024 120204 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 201013 1047 120206 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 201014 1048 120207 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201015 1049 120208 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 201016 1072 120210 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201017 1073 120211 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201018 1074 120212 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 3-story
element zeroLength 300000 120202 2002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300001 120203 2003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300002 120204 2004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 300003 120206 2027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 300004 120207 2028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300005 120208 2029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 300006 120210 2052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300007 120211 2053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300008 120212 2054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301000 120202 2002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301001 120203 2003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301002 120204 2004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301003 120206 2027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 301004 120207 2028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301005 120208 2029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301006 120210 2052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301007 120211 2053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301008 120212 2054 -mat 20 21 -dir 1 2 -doRayleigh 1





element zeroLength 300010 2022 120302 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300011 2023 120303 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300012 2024 120304 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 300013 2047 120306 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 300014 2048 120307 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300015 2049 120308 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 300016 2072 120310 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300017 2073 120311 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300018 2074 120312 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301010 2022 120302 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301011 2023 120303 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301012 2024 120304 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301013 2047 120306 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 301014 2048 120307 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301015 2049 120308 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301016 2072 120310 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301017 2073 120311 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301018 2074 120312 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 4-story
element zeroLength 400000 120302 3002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 400001 120303 3003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400002 120304 3004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 400003 120306 3027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400004 120307 3028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400005 120308 3029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 400006 120310 3052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 400007 120311 3053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400008 120312 3054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 401000 120302 3002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 401001 120303 3003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401002 120304 3004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 401003 120306 3027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401004 120307 3028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401005 120308 3029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 401006 120310 3052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 401007 120311 3053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401008 120312 3054 -mat 20 21 -dir 1 2 -doRayleigh 1




element zeroLength 400010 3022 120402 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 400011 3023 120403 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400012 3024 120404 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 400013 3047 120406 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400014 3048 120407 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400015 3049 120408 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 400016 3072 120410 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 400017 3073 120411 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 400018 3074 120412 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 401010 3022 120402 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 401011 3023 120403 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401012 3024 120404 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 401013 3047 120406 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401014 3048 120407 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401015 3049 120408 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 401016 3072 120410 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 401017 3073 120411 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 401018 3074 120412 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 5-story
element zeroLength 500000 120402 4002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 500001 120403 4003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500002 120404 4004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 500003 120406 4027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500004 120407 4028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500005 120408 4029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 500006 120410 4052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 500007 120411 4053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500008 120412 4054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 501000 120402 4002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 501001 120403 4003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501002 120404 4004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 501003 120406 4027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501004 120407 4028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501005 120408 4029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 501006 120410 4052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 501007 120411 4053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501008 120412 4054 -mat 20 21 -dir 1 2 -doRayleigh 1





element zeroLength 500010 4022 120502 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 500011 4023 120503 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500012 4024 120504 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 500013 4047 120506 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500014 4048 120507 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500015 4049 120508 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 500016 4072 120510 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 500017 4073 120511 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 500018 4074 120512 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 501010 4022 120502 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 501011 4023 120503 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501012 4024 120504 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 501013 4047 120506 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501014 4048 120507 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501015 4049 120508 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 501016 4072 120510 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 501017 4073 120511 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 501018 4074 120512 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 6-story
element zeroLength 600000 120502 5002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 600001 120503 5003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600002 120504 5004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 600003 120506 5027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600004 120507 5028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600005 120508 5029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 600006 120510 5052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 600007 120511 5053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600008 120512 5054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 601000 120502 5002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 601001 120503 5003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601002 120504 5004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 601003 120506 5027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601004 120507 5028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601005 120508 5029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 601006 120510 5052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 601007 120511 5053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601008 120512 5054 -mat 20 21 -dir 1 2 -doRayleigh 1





element zeroLength 600010 5022 120602 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 600011 5023 120603 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600012 5024 120604 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 600013 5047 120606 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600014 5048 120607 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600015 5049 120608 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 600016 5072 120610 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 600017 5073 120611 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 600018 5074 120612 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 601010 5022 120602 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 601011 5023 120603 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601012 5024 120604 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 601013 5047 120606 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601014 5048 120607 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601015 5049 120608 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 601016 5072 120610 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 601017 5073 120611 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 601018 5074 120612 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 7-story
element zeroLength 700000 120602 6002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 700001 120603 6003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 700002 120604 6004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 700003 120606 6027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 700004 120607 6028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 700005 120608 6029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 700006 120610 6052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 700007 120611 6053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 700008 120612 6054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 701000 120602 6002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 701001 120603 6003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 701002 120604 6004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 701003 120606 6027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 701004 120607 6028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 701005 120608 6029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 701006 120610 6052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 701007 120611 6053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 701008 120612 6054 -mat 20 21 -dir 1 2 -doRayleigh 1





element zeroLength 700010 6022 120702 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 700011 6023 120703 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 700012 6024 120704 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 700013 6047 120706 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 700014 6048 120707 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 700015 6049 120708 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 700016 6072 120710 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 700017 6073 120711 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 700018 6074 120712 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 701010 6022 120702 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 701011 6023 120703 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 701012 6024 120704 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 701013 6047 120706 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 701014 6048 120707 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 701015 6049 120708 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 701016 6072 120710 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 701017 6073 120711 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 701018 6074 120712 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 8-story
element zeroLength 800000 120702 7002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 800001 120703 7003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 800002 120704 7004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 800003 120706 7027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 800004 120707 7028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 800005 120708 7029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 800006 120710 7052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 800007 120711 7053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 800008 120712 7054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 801000 120702 7002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 801001 120703 7003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 801002 120704 7004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 801003 120706 7027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 801004 120707 7028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 801005 120708 7029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 801006 120710 7052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 801007 120711 7053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 801008 120712 7054 -mat 20 21 -dir 1 2 -doRayleigh 1






element zeroLength 800010 7022 120802 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 800011 7023 120803 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 800012 7024 120804 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 800013 7047 120806 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 800014 7048 120807 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 800015 7049 120808 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 800016 7072 120810 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 800017 7073 120811 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 800018 7074 120812 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 801010 7022 120802 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 801011 7023 120803 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 801012 7024 120804 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 801013 7047 120806 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 801014 7048 120807 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 801015 7049 120808 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 801016 7072 120810 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 801017 7073 120811 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 801018 7074 120812 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 9-story
element zeroLength 900000 120802 8002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 900001 120803 8003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 900002 120804 8004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 900003 120806 8027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 900004 120807 8028 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 900005 120808 8029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 900006 120810 8052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 900007 120811 8053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 900008 120812 8054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 901000 120802 8002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 901001 120803 8003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 901002 120804 8004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 901003 120806 8027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 901004 120807 8028 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 901005 120808 8029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 901006 120810 8052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 901007 120811 8053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 901008 120812 8054 -mat 20 21 -dir 1 2 -doRayleigh 1





element zeroLength 900010 8022 120902 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 900011 8023 120903 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 900012 8024 120904 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 900013 8047 120906 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 900014 8048 120907 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 900015 8049 120908 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 900016 8072 120910 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 900017 8073 120911 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 900018 8074 120912 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 901010 8022 120902 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 901011 8023 120903 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 901012 8024 120904 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 901013 8047 120906 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 901014 8048 120907 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 901015 8049 120908 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 901016 8072 120910 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 901017 8073 120911 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 901018 8074 120912 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 10-story
element zeroLength 1000000 120902 9002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1000001 120903 9003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000002 120904 9004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1000003 120906 9027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000004 120907 9028 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1000005 120908 9029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1000006 120910 9052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1000007 120911 9053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000008 120912 9054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1001000 120902 9002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1001001 120903 9003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1001002 120904 9004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1001003 120906 9027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1001004 120907 9028 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1001005 120908 9029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1001006 120910 9052 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1001007 120911 9053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1001008 120912 9054 -mat 20 21 -dir 1 2 -doRayleigh 1






element zeroLength 1000010 9022 121002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1000011 9023 121003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000012 9024 121004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1000013 9047 121006 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000014 9048 121007 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1000015 9049 121008 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1000016 9072 121010 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1000017 9073 121011 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000018 9074 121012 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1001010 9022 121002 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1001011 9023 121003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1001012 9024 121004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1001013 9047 121006 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1001014 9048 121007 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1001015 9049 121008 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1001016 9072 121010 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1001017 9073 121011 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1001018 9074 121012 -mat 20 21 -dir 1 2 -doRayleigh 1



#Angle brackets of 11-story
#element zeroLength 1100000 121002 10002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1100001 121003 10003 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1100002 121004 10004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1100003 121006 10027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1100004 121007 10028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1100005 121008 10029 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1100006 121010 10052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1100007 121011 10053 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1100008 121012 10054 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1101000 121002 10002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1101001 121003 10003 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1101002 121004 10004 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1101003 121006 10027 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1101004 121007 10028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1101005 121008 10029 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1101006 121010 10052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1101007 121011 10053 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1101008 121012 10054 -mat 20 21 -dir 1 2 -doRayleigh 1






#element zeroLength 1100010 10022 121102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1100011 10023 121103 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1100012 10024 121104 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1100013 10047 121106 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1100014 10048 121107 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1100015 10049 121108 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1100016 10072 121110 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1100017 10073 121111 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1100018 10074 121112 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1101010 10022 121102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1101011 10023 121103 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1101012 10024 121104 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1101013 10047 121106 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1101014 10048 121107 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1101015 10049 121108 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1101016 10072 121110 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1101017 10073 121111 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1101018 10074 121112 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 12-story
#element zeroLength 1200000 121102 11002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1200001 121103 11003 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1200002 121104 11004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1200003 121106 11027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1200004 121107 11028 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1200005 121108 11029 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1200006 121110 11052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1200007 121111 11053 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1200008 121112 11054 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1201000 121102 11002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1201001 121103 11003 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1201002 121104 11004 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1201003 121106 11027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1201004 121107 11028 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1201005 121108 11029 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1201006 121110 11052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1201007 121111 11053 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1201008 121112 11054 -mat 20 21 -dir 1 2 -doRayleigh 1






#element zeroLength 1200010 11022 121202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1200011 11023 121203 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1200012 11024 121204 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1200013 11047 121206 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1200014 11048 121207 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1200015 11049 121208 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1200016 11072 121210 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1200017 11073 121211 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1200018 11074 121212 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1201010 11022 121202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1201011 11023 121203 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1201012 11024 121204 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1201013 11047 121206 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1201014 11048 121207 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1201015 11049 121208 -mat 20 21 -dir 1 2 -doRayleigh 1

#element zeroLength 1201016 11072 121210 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1201017 11073 121211 -mat 20 21 -dir 1 2 -doRayleigh 1
#element zeroLength 1201018 11074 121212 -mat 20 21 -dir 1 2 -doRayleigh 1












#Shear spline joint
set matTag 30
set ePf1 [expr 2.3]
set ePf2 [expr 5.9]
set ePf3 [expr 7.1]
set ePf4 [expr 6.8]
set ePd1 0.002
set ePd2 0.015
set ePd3 0.031
set ePd4 0.040
set rDispP 0.7
set rForceP 0.2
set uForceP 0.03
set gK1 0
set gK2 0
set gK3 0
set gK4 0
set gKLim 0
set gD1 0.9
set gD2 0
set gD3 0
set gD4 0
set gDLim 0.05
set gF1 0
set gF2 0
set gF3 0
set gF4 0
set gFLim 0
set gE 1
uniaxialMaterial Pinching4 $matTag $ePf1 $ePd1 $ePf2 $ePd2 $ePf3 $ePd3 $ePf4 $ePd4 $rDispP $rForceP $uForceP $gK1 $gK2 $gK3 $gK4 $gKLim $gD1 $gD2 $gD3 $gD4 $gDLim $gF1 $gF2 $gF3 $gF4 $gFLim $gE $damage



#Tension spline joint
set matTag 31
set ePf1 [expr 1.36]
set ePf2 [expr 3.6]
set ePf3 [expr 5.16]
set ePf4 [expr 5.8]
set ePd1 0.0007
set ePd2 0.007
set ePd3 0.023
set ePd4 0.034
set rDispP 0.65
set rForceP 0.15
set uForceP 0.02
set gK1 0
set gK2 0
set gK3 0
set gK4 0
set gKLim 0
set gD1 0.97
set gD2 0
set gD3 0
set gD4 0
set gDLim 0.03
set gF1 0
set gF2 0
set gF3 0
set gF4 0
set gFLim 0
set gE 1
uniaxialMaterial Pinching4 $matTag $ePf1 $ePd1 $ePf2 $ePd2 $ePf3 $ePd3 $ePf4 $ePd4 $rDispP $rForceP $uForceP $gK1 $gK2 $gK3 $gK4 $gKLim $gD1 $gD2 $gD3 $gD4 $gDLim $gF1 $gF2 $gF3 $gF4 $gFLim $gE $damage


#Spline joint of 1-story
#for {set zz 1} {$zz <=21} {incr zz 1} {
#element zeroLength [expr 2100+$zz] [expr 11*$zz] [expr (21+$zz-1)*11+1] -mat 31 30 -dir 1 2 -doRayleigh 1
#}
#for {set zz 22} {$zz <=38} {incr zz 1} {
#element zeroLength [expr 2100+$zz] [expr 11*($zz-21+2)] [expr (21+$zz-21+2-1)*11+1] -mat 31 30 -dir 1 2 -doRayleigh 1
#}

#Spline joint of 2-story
#for {set zz 1} {$zz <=21} {incr zz 1} {
#element zeroLength [expr 2200+$zz] [expr 11*$zz+1000] [expr (21+$zz-1)*11+1+1000] -mat 31 30 -dir 1 2 -doRayleigh 1
#}
#for {set zz 22} {$zz <=30} {incr zz 1} {
#element zeroLength [expr 2200+$zz] [expr 11*($zz-21+6)+1000] [expr (21+$zz-21+6-1)*11+1+1000] -mat 31 30 -dir 1 2 -doRayleigh 1
#}

#Spline joint of 3-story
#for {set zz 1} {$zz <=21} {incr zz 1} {
#element zeroLength [expr 2300+$zz] [expr 11*$zz+1000] [expr (21+$zz-1)*11+1+1000] -mat 31 30 -dir 1 2 -doRayleigh 1
#}
#for {set zz 22} {$zz <=30} {incr zz 1} {
#element zeroLength [expr 2300+$zz] [expr 11*($zz-21+6)+1000] [expr (21+$zz-21+6-1)*11+1+1000] -mat 31 30 -dir 1 2 -doRayleigh 1
#}

set S1 44
set S2 38
set S3 37
set S4 36
set S5 34
set S6 32
set S7 30
set S8 27
set S9 24
set S10 21
set S11 18
set S12 14

#Spline joint of 1-story
for {set zz 1} {$zz <=[expr $S1]} {incr zz 1} {
element zeroLength [expr 20005000+$zz] 15 36 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 25005000+$zz] 40 61 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 2-story
for {set zz 1} {$zz <=[expr $S2]} {incr zz 1} {
element zeroLength [expr 30005000+$zz] 1015 1036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 35005000+$zz] 1040 1061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 3-story
for {set zz 1} {$zz <=[expr $S3]} {incr zz 1} {
element zeroLength [expr 40005000+$zz] 2015 2036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 45005000+$zz] 2040 2061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 4-story
for {set zz 1} {$zz <=[expr $S4]} {incr zz 1} {
element zeroLength [expr 50005000+$zz] 3015 3036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 55005000+$zz] 3040 3061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 5-story
for {set zz 1} {$zz <=[expr $S5]} {incr zz 1} {
element zeroLength [expr 60005000+$zz] 4015 4036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 65005000+$zz] 4040 4061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 6-story
for {set zz 1} {$zz <=[expr $S6]} {incr zz 1} {
element zeroLength [expr 70005000+$zz] 5015 5036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 75005000+$zz] 5040 5061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 7-story
for {set zz 1} {$zz <=[expr $S7]} {incr zz 1} {
element zeroLength [expr 80005000+$zz] 6015 6036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 85005000+$zz] 6040 6061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 8-story
for {set zz 1} {$zz <=[expr $S8]} {incr zz 1} {
element zeroLength [expr 90005000+$zz] 7015 7036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 95005000+$zz] 7040 7061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 9-story
for {set zz 1} {$zz <=[expr $S9]} {incr zz 1} {
element zeroLength [expr 100005000+$zz] 8015 8036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 105005000+$zz] 8040 8061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 10-story
for {set zz 1} {$zz <=[expr $S10]} {incr zz 1} {
element zeroLength [expr 110005000+$zz] 9015 9036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 115005000+$zz] 9040 9061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 11-story
for {set zz 1} {$zz <=[expr $S11]} {incr zz 1} {
element zeroLength [expr 120005000+$zz] 10015 10036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 125005000+$zz] 10040 10061 -mat 31 30 -dir 1 2 -doRayleigh 1
}

#Spline joint of 12-story
for {set zz 1} {$zz <=[expr $S12]} {incr zz 1} {
element zeroLength [expr 130005000+$zz] 11015 11036 -mat 31 30 -dir 1 2 -doRayleigh 1
element zeroLength [expr 135005000+$zz] 11040 11061 -mat 31 30 -dir 1 2 -doRayleigh 1
}





set Ee [expr 2000*1000*1000*0.191/1000]
uniaxialMaterial ENT 111000 $Ee

for {set mm 1} {$mm <=[expr $Nstory]} {incr mm 1} {
     for {set nn 2} {$nn <=5} {incr nn 1} {
     element zeroLength [expr 250000+100*$mm+$nn] [expr 120000+($mm-1)*100+$nn] [expr ($mm-1)*1000+$nn] -mat 111000 -dir 2
     element zeroLength [expr 1250000+100*$mm+$nn] [expr ($mm-1)*1000+20+$nn] [expr 120000+($mm)*100+$nn] -mat 111000 -dir 2
     }
     for {set nn 6} {$nn <=8} {incr nn 1} {
     element zeroLength [expr 250000+100*$mm+$nn] [expr 120000+($mm-1)*100+$nn] [expr ($mm-1)*1000+$nn+21] -mat 111000 -dir 2
     element zeroLength [expr 1250000+100*$mm+$nn] [expr ($mm-1)*1000+20+$nn+21] [expr 120000+($mm)*100+$nn] -mat 111000 -dir 2
     }
     for {set nn 9} {$nn <=12} {incr nn 1} {
     element zeroLength [expr 250000+100*$mm+$nn] [expr 120000+($mm-1)*100+$nn] [expr ($mm-1)*1000+$nn+21+21] -mat 111000 -dir 2
     element zeroLength [expr 1250000+100*$mm+$nn] [expr ($mm-1)*1000+20+$nn+21+21] [expr 120000+($mm)*100+$nn] -mat 111000 -dir 2
     }
}






set Kd 1e7;
set ad 1;
set Cd1 3930;
set Cd2 3868;
set Cd3 3768;
set Cd4 3632;
set Cd5 3462;
set Cd6 3260;
set Cd7 3028;
set Cd8 2766;
set Cd9 2474;
set Cd10 2154;
set Cd11 1808;
set Cd12 1432;

uniaxialMaterial ViscousDamper 1 $Kd $Cd1 $ad 
uniaxialMaterial ViscousDamper 2 $Kd $Cd2 $ad 
uniaxialMaterial ViscousDamper 3 $Kd $Cd3 $ad 
uniaxialMaterial ViscousDamper 4 $Kd $Cd4 $ad 
uniaxialMaterial ViscousDamper 5 $Kd $Cd5 $ad 
uniaxialMaterial ViscousDamper 6 $Kd $Cd6 $ad 
uniaxialMaterial ViscousDamper 7 $Kd $Cd7 $ad 
uniaxialMaterial ViscousDamper 8 $Kd $Cd8 $ad 
uniaxialMaterial ViscousDamper 9 $Kd $Cd9 $ad 
uniaxialMaterial ViscousDamper 10 $Kd $Cd10 $ad 
uniaxialMaterial ViscousDamper 11 $Kd $Cd11 $ad 
uniaxialMaterial ViscousDamper 12 $Kd $Cd12 $ad 

element twoNodeLink 510100 100001 6 -mat 1 -dir 1 -orient 0 0 1
element twoNodeLink 510101 110001 60 -mat 1 -dir 1 -orient 0 0 1

element twoNodeLink 510200 120101 1006 -mat 2 -dir 1 -orient 0 0 1
element twoNodeLink 510201 120113 1060 -mat 2 -dir 1 -orient 0 0 1

element twoNodeLink 510300 120201 2006 -mat 3 -dir 1 -orient 0 0 1
element twoNodeLink 510301 120213 2060 -mat 3 -dir 1 -orient 0 0 1

element twoNodeLink 510400 120301 3006 -mat 4 -dir 1 -orient 0 0 1
element twoNodeLink 510401 120313 3060 -mat 4 -dir 1 -orient 0 0 1

element twoNodeLink 510500 120401 4006 -mat 5 -dir 1 -orient 0 0 1
element twoNodeLink 510501 120413 4060 -mat 5 -dir 1 -orient 0 0 1

element twoNodeLink 510600 120501 5006 -mat 6 -dir 1 -orient 0 0 1
element twoNodeLink 510601 120513 5060 -mat 6 -dir 1 -orient 0 0 1

element twoNodeLink 510700 120601 6006 -mat 7 -dir 1 -orient 0 0 1
element twoNodeLink 510701 120613 6060 -mat 7 -dir 1 -orient 0 0 1

element twoNodeLink 510800 120701 7006 -mat 8 -dir 1 -orient 0 0 1
element twoNodeLink 510801 120713 7060 -mat 8 -dir 1 -orient 0 0 1

element twoNodeLink 510900 120801 8006 -mat 9 -dir 1 -orient 0 0 1
element twoNodeLink 510901 120813 8060 -mat 9 -dir 1 -orient 0 0 1

element twoNodeLink 511000 120901 9006 -mat 10 -dir 1 -orient 0 0 1
element twoNodeLink 511001 120913 9060 -mat 10 -dir 1 -orient 0 0 1

element twoNodeLink 511100 121001 10006 -mat 11 -dir 1 -orient 0 0 1
element twoNodeLink 511101 121013 10060 -mat 11 -dir 1 -orient 0 0 1

element twoNodeLink 511200 121101 11006 -mat 12 -dir 1 -orient 0 0 1
element twoNodeLink 511201 121113 11060 -mat 12 -dir 1 -orient 0 0 1






for {set wy 120102} {$wy <= 120112} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120202} {$wy <= 120212} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120302} {$wy <= 120312} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120402} {$wy <= 120412} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120502} {$wy <= 120512} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120602} {$wy <= 120612} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120702} {$wy <= 120712} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120802} {$wy <= 120812} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 120902} {$wy <= 120912} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 121102} {$wy <= 121112} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}
for {set wy 121202} {$wy <= 121212} {incr wy 1} {
pattern Plain $wy Linear {
load $wy 0. [expr -29915/11000] 0. 0. 0. 0.;
}
}


for {set P 15001} {$P <= 15012} {incr P 1} {
pattern Plain $P Linear {
load $P 0. -344 0. 0. 0. 0.;
}
}

# Gravity-analysis: load-controlled static analysis
	set Tol 1.0e-6;							# convergence tolerance for test
	variable constraintsTypeGravity Plain;	# default;
	constraints $constraintsTypeGravity ;   # how it handles boundary conditions
	numberer RCM;							# renumber dof's to minimize band-width (optimization)
	system BandGeneral ;					# how to store and solve the system of equations in the analysis (large model: try UmfPack)
	test NormDispIncr $Tol 6 ; 				# determine if convergence has been achieved at the end of an iteration step
	algorithm Newton;						# use Newton's solution algorithm: updates tangent stiffness at every iteration
	set NstepGravity 10;  					# apply gravity in 10 steps
	set DGravity [expr 1.0/$NstepGravity]; 	# first load increment;
	integrator LoadControl $DGravity;		# determine the next time step for an analysis
	analysis Static;						# define type of analysis static or transient
	analyze $NstepGravity;					# apply gravity

	# maintain constant gravity loads and reset time to zero
	loadConst -time 0.0
	puts "Model Built"


############################################################################
#                       Eigenvalue Analysis                    			   
############################################################################
	set pi [expr 2.0*asin(1.0)];						# Definition of pi
	set nEigenI 1;										# mode i = 1
	set nEigenJ 2;										# mode j = 2
	set lambdaN [eigen [expr $nEigenJ]];				# eigenvalue analysis for nEigenJ modes
	puts "lambdaN = $lambdaN ";
	set lambdaI [lindex $lambdaN [expr 0]];				# eigenvalue mode i = 1
	set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]];	# eigenvalue mode j = 2
	puts "lambdaI = $lambdaI ";									# display the first mode period in the command window
	set w1 [expr pow($lambdaI,0.5)];					# w1 (1st mode circular frequency)
	set w2 [expr pow($lambdaJ,0.5)];					# w2 (2nd mode circular frequency)
	set T1 [expr 2.0*$pi/$w1];							# 1st mode period of the structure
	set T2 [expr 2.0*$pi/$w2];							# 2nd mode period of the structure
	puts "T1 = $T1 s";									# display the first mode period in the command window
	puts "T2 = $T2 s";									# display the second mode period in the command window

recorder Drift -file Drift.out -time -iNode 120002 120102 120202 120302 120402 120502 120602 120702 120802 120902 121002 121102 -jNode 120102 120202 120302 120402 120502 120602 120702 120802 120902 121002 121102 121202 -dof 1 -perpDirn 2 ;
recorder Drift -file Drift2.out -time -iNode 1 1001 2001 3001 4001 5001 6001 7001 8001 9001 10001 11001 -jNode 21 1021 2021 3021 4021 5021 6021 7021 8021 9021 10021 11021 -dof 1 -perpDirn 2 ;


#recorder Drift -file Disp.out -time -iNode 120002 120102 120202 120302 120402 120502 120602 120702 120802 120902 121002 121102 -jNode 2 1002 2002 3002 4002 5002 6002 7002 8002 9002 10002 11002 -dof 1 -perpDirn 2 ;
recorder Node -file Disp1.out -time -node 120002 120102 120202 120302 120402 120502 120602 120702 120802 120902 121002 121102 -dof 1 disp;
recorder Node -file Disp2.out -time -node 2 1002 2002 3002 4002 5002 6002 7002 8002 9002 10002 11002 -dof 1 disp;
recorder Node -file Disp3.out -time -node 22 1022 2022 3022 4022 5022 6022 7022 8022 9022 10022 11022 -dof 1 disp;

#recorder Node -file Dispdamper1.out -time -node 100001 21 1021 2021 3021 4021 5021 6021 7021 8021 9021 10021 -dof 2 disp;
recorder Node -file Dispdamper1.out -time -node 100001 120101 120201 120301 120401 120501 120601 120701 120801 120901 121001 121101 -dof 2 disp;
recorder Node -file Dispdamper2.out -time -node 6 1006 2006 3006 4006 5006 6006 7006 8006 9006 10006 11006 -dof 2 disp;



set ddd [open "deltaTTT.txt"]
set dtt [read $ddd]

set ss [open "Scale.txt"]
set sss [read $ss]


set G [expr 9.81*$sss]

#set G [expr 9.81*3]
timeSeries Path 101 -dt $dtt -filePath xxx.txt -factor $G
pattern UniformExcitation 102 1 -acceleration 101




set Damp 0.246
#set Damp 0.05
set alpha [expr 2*$Damp*$w1*$w2/($w1+$w2)]
set beta [expr 2*$Damp/($w1+$w2)]
rayleigh $alpha 0 $beta 0



set nnn [open "number.txt"]
set nn [read $nnn]

#Time History Analysis
#source SmartAnalyze.tcl
#constraints Transformation
#numberer Plain
#system BandGeneral
#integrator Newmark 0.5 0.25
#SmartAnalyzeTransient 0.1 $nn

wipeAnalysis
constraints Transformation
numberer RCM
system SparseGeneral
test EnergyIncr 1e-6 100 0
#test NormDispIncr 1e-6 100
algorithm KrylovNewton
integrator Newmark 0.5 0.25
analysis Transient
analyze $nn 0.01



puts "Done!"

set tStop [clock clicks -milliseconds] 
puts "-------------------------------------------------------" 
puts "Analysis time taken: [expr ($tStop-$tStart)/60000] min" 


#recorder display Frame 10 10 1500 1500 -wipe
#vup 0 1 0 
#vpn 1 1 1
#prp 0 0 10000
#display 10 -1 10
#after 3000