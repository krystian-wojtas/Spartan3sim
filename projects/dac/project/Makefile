# project specific synt modules

synt += ../Top.v
synt += ../Controller.v
synt += ../DacSpi.v
synt += ../../generic/Debouncer.v

# generic synt modules

synt += ../../generic/Counter.v
synt += ../../generic/ModClk.v
synt += ../../generic/Spi.v
synt += ../../generic/Serial.v
synt += ../../generic/Shiftreg.v

# project specific sim modules

sim += $(synt)
sim += ../sim/TopTest.v
sim += ../sim/TopTestBench.v
sim += ../sim/DacLTC2624-behav.v

# generic sim modules

sim += ../../generic/sim/Clock.v
sim += ../../generic/sim/Reset.v
sim += ../../generic/sim/Set.v
sim += ../../generic/sim/Monitor.v

# generic makefile

include ../../generic/makefile/generic
