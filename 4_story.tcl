
set systemTime [clock seconds]
set tStart [clock clicks -milliseconds] 

wipe   # clear memory of all past model definitions
model BasicBuilder -ndm 3 -ndf 6;	# Define the model builder, ndm=#dimension, ndf=#dofs

set dataDir Data;				# set up name of data directory (you can remove this)
file mkdir $dataDir; 				# create data directory






set ppNodesInfo [open ppNodesInfo.dat w]

set Nstory 4

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
mass [expr 120000+100*2+$jj] 5.463 0. 0. 0. 0. 0.
mass [expr 120000+100*3+$jj] 5.463 0. 0. 0. 0. 0.
mass [expr 120000+100*4+$jj] 6.135 0. 0. 0. 0. 0.



}


equalDOF 120101 120113 2 
equalDOF 120201 120213 2 
equalDOF 120301 120313 2 
equalDOF 120401 120413 2 






node 15000 -1 0 0
node 15001 -1 4.6 0
node 15002 -1 8.6 0
node 15003 -1 12.6 0
node 15004 -1 16.6 0


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






set secTag 1
set nu 0.372
set h 0.245
set rho 0.448
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
set b 0.245
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
element zeroLength 1000000 120002 2 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100000 120002 2 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100001 120003 3 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100002 120004 4 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000020 120005 5 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1000030 120005 26 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100003 120006 27 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100004 120007 28 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100005 120008 29 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000050 120009 30 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1000060 120009 51 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100006 120010 52 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100007 120011 53 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100008 120012 54 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000080 120012 54 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1010000 120002 2 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101000 120002 2 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101001 120003 3 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101002 120004 4 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1010020 120005 5 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1010030 120005 26 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101003 120006 27 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101004 120007 28 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101005 120008 29 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1010050 120009 30 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1010060 120009 51 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101006 120010 52 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101007 120011 53 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101008 120012 54 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1010080 120012 54 -mat 20 21 -dir 1 2 -doRayleigh 1



element zeroLength 1000100 22 120102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100010 22 120102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100011 23 120103 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100012 24 120104 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000120 25 120105 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1000130 46 120105 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100013 47 120106 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100014 48 120107 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100015 49 120108 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000150 50 120109 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1000160 71 120109 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100016 72 120110 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100017 73 120111 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 100018 74 120112 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1000180 74 120112 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1010100 22 120102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101010 22 120102 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101011 23 120103 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101012 24 120104 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1010120 25 120105 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1010130 46 120105 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101013 47 120106 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101014 48 120107 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101015 49 120108 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1010150 50 120109 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 1010160 71 120109 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101016 72 120110 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101017 73 120111 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 101018 74 120112 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 1010180 74 120112 -mat 20 21 -dir 1 2 -doRayleigh 1



#Angle brackets of 2-story
element zeroLength 2000000 120102 1002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200000 120102 1002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200001 120103 1003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200002 120104 1004 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2000020 120105 1005 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2000030 120105 1026 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200003 120106 1027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200004 120107 1028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200005 120108 1029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2000060 120109 1051 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200006 120110 1052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200007 120111 1053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200008 120112 1054 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2000080 120112 1054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2010000 120102 1002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201000 120102 1002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201001 120103 1003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201002 120104 1004 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2010020 120105 1005 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2010030 120105 1026 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201003 120106 1027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201004 120107 1028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201005 120108 1029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2010060 120109 1051 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201006 120110 1052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201007 120111 1053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201008 120112 1054 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2010080 120112 1054 -mat 20 21 -dir 1 2 -doRayleigh 1


element zeroLength 2000100 1022 120202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200010 1022 120202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200011 1023 120203 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200012 1024 120204 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2000120 1025 120205 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2000130 1046 120205 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200013 1047 120206 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200014 1048 120207 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200015 1049 120208 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2000160 1071 120209 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200016 1072 120210 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200017 1073 120211 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 200018 1074 120212 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2000180 1074 120212 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2010100 1022 120202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201010 1022 120202 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201011 1023 120203 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201012 1024 120204 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2010120 1025 120205 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2010130 1046 120205 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201013 1047 120206 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201014 1048 120207 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201015 1049 120208 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 2010160 1071 120209 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201016 1072 120210 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201017 1073 120211 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 201018 1074 120212 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 2010180 1074 120212 -mat 20 21 -dir 1 2 -doRayleigh 1




#Angle brackets of 3-story
element zeroLength 300000 120202 2002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300001 120203 2003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300002 120204 2004 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 3000020 120205 2005 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 300003 120206 2027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300004 120207 2028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300005 120208 2029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 3000060 120209 2051 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300006 120210 2052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300007 120211 2053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300008 120212 2054 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301000 120202 2002 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301001 120203 2003 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301002 120204 2004 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 3010020 120205 2005 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301003 120206 2027 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301004 120207 2028 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301005 120208 2029 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 3010060 120209 2051 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301006 120210 2052 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301007 120211 2053 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301008 120212 2054 -mat 20 21 -dir 1 2 -doRayleigh 1





element zeroLength 300010 2022 120302 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300011 2023 120303 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300012 2024 120304 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 3000120 2025 120305 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 300013 2047 120306 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300014 2048 120307 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300015 2049 120308 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 3000160 2071 120309 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300016 2072 120310 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300017 2073 120311 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 300018 2074 120312 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301010 2022 120302 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301011 2023 120303 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301012 2024 120304 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 3010120 2025 120305 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 301013 2047 120306 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301014 2048 120307 -mat 20 21 -dir 1 2 -doRayleigh 1
element zeroLength 301015 2049 120308 -mat 20 21 -dir 1 2 -doRayleigh 1

element zeroLength 3010160 2071 120309 -mat 20 21 -dir 1 2 -doRayleigh 1
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

set S1 88
set S2 68
set S3 54
set S4 36



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






set Ee [expr 2000*1000*1000*0.245/1000]
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
set Cd1 2196;
set Cd2 1953;
set Cd3 1560;
set Cd4 1026;


uniaxialMaterial ViscousDamper 1 $Kd $Cd1 $ad 
uniaxialMaterial ViscousDamper 2 $Kd $Cd2 $ad 
uniaxialMaterial ViscousDamper 3 $Kd $Cd3 $ad 
uniaxialMaterial ViscousDamper 4 $Kd $Cd4 $ad 



element twoNodeLink 510100 120001 6 -mat 1 -dir 1 -orient 0 0 1
element twoNodeLink 510101 120013 60 -mat 1 -dir 1 -orient 0 0 1

element twoNodeLink 510200 120101 1006 -mat 2 -dir 1 -orient 0 0 1
element twoNodeLink 510201 120113 1060 -mat 2 -dir 1 -orient 0 0 1

element twoNodeLink 510300 120201 2006 -mat 3 -dir 1 -orient 0 0 1
element twoNodeLink 510301 120213 2060 -mat 3 -dir 1 -orient 0 0 1

element twoNodeLink 510400 120301 3006 -mat 4 -dir 1 -orient 0 0 1
element twoNodeLink 510401 120313 3060 -mat 4 -dir 1 -orient 0 0 1








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




for {set P 15001} {$P <= 15004} {incr P 1} {
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

#recorder Element -file Force2.out -time -ele 510400 section 1 stressStrain;
#recorder Node -file vel.out -time -node 4 8 12 16 20 24 28 32 36 40 44 48 52 -dof 1 vel;
#recorder Element -file Force.out –time -ele 510400 globalForce;
#recorder Element -file Force4.out –time -ele 510400 localForce;



recorder Node -file Forcedamper.out -time -node 120001 120013 120101 120113 120201 120213 120301 120313 -dof 2 reaction;
recorder Node -file Dispdamper1.out -time -node 120001 120013 120101 120113 120201 120213 120301 120313 -dof 2 disp;
recorder Node -file Dispdamper2.out -time -node 6 60 1006 1060 2006 2060 3006 3060 -dof 2 disp;

recorder Drift -file Drift.out -time -iNode 120002 120102 120202 120302 -jNode 120102 120202 120302 120402 -dof 1 -perpDirn 2 ;
recorder Drift -file Drift2.out -time -iNode 1 1001 2001 3001 -jNode 21 1021 2021 3021 -dof 1 -perpDirn 2 ;


#recorder Drift -file Disp.out -time -iNode 120002 120102 120202 120302 120402 120502 120602 120702 120802 120902 121002 121102 -jNode 2 1002 2002 3002 4002 5002 6002 7002 8002 9002 10002 11002 -dof 1 -perpDirn 2 ;
#recorder Node -file Disp1.out -time -node 120002 120102 120202 120302 -dof 1 disp;
#recorder Node -file Disp2.out -time -node 2 1002 2002 3002 -dof 1 disp;
#recorder Node -file Disp3.out -time -node 22 1022 2022 3022 -dof 1 disp;


recorder Node -file shear.out -time -node 120001 120002	120003 120004 120005 120006 120007 120008 120009 120010 120011 120012 120013 -dof 1 reaction;
recorder Node -file Disproof.out -time -node 120401 -dof 1 disp;
recorder Node -file Disproof2.out -time -node 3075 120413 -dof 1 disp;

set ddd [open "deltaTTT.txt"]
set dtt [read $ddd]

set ss [open "Scale.txt"]
set sss [read $ss]


set G [expr 9.81*$sss]

#set G [expr 9.81*3]
timeSeries Path 101 -dt $dtt -filePath xxx.txt -factor $G
pattern UniformExcitation 102 1 -acceleration 101




set Damp 0.13
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
analyze $nn 0.005



puts "Done!"

set tStop [clock clicks -milliseconds] 
puts "-------------------------------------------------------" 
puts "Analysis time taken: [expr ($tStop-$tStart)/60000] min" 


#recorder display Frame 10 10 1500 1500 -wipe
#vup 0 1 0 
#vpn 1 1 1
#prp 0 0 10000
#display 10 -1 10
#after 30000