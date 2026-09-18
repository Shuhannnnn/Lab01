wvResizeWindow -win $_nWave1 0 23 1440 829
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/2026_Fall/iclab/iclab089/Lab01_2026_F/FALL_2026_LAB01/01_RTL/OISS.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/clk} \
{/TESTBED/Ex_cycle\[8:0\]} \
{/TESTBED/Inst_seq_I\[95:0\]} \
{/TESTBED/Inst_latency_I\[47:0\]} \
{/TESTBED/Inst_order_O\[23:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/clk} \
{/TESTBED/Ex_cycle\[8:0\]} \
{/TESTBED/Inst_seq_I\[95:0\]} \
{/TESTBED/Inst_latency_I\[47:0\]} \
{/TESTBED/Inst_order_O\[23:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 33801.441153 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 74072.057646 -snap {("G1" 3)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 74718.975180 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 75042.433947 -snap {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetCursor -win $_nWave1 36550.840673 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 89032.025620 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 74152.922338 -snap {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 99948.759007 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 92185.748599 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 90649.319456
wvSetCursor -win $_nWave1 89921.537230
wvZoom -win $_nWave1 89921.537230 100838.270616
wvExit
