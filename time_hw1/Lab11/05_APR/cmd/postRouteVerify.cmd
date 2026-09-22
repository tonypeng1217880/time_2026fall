verifyConnectivity -type all -error 1000 -warning 50
verify_drc
verifyProcessAntenna -reportfile gcd.antenna.rpt -error 1000

saveDesign ./DBS/gcd_verified.inn
