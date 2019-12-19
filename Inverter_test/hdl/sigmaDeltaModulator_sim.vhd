ARCHITECTURE sim OF sigmaDeltaModulator IS

  constant samplingPeriod: time := 1.0/samplingFrequency * 1 sec;
  signal pwm1, pwm2: std_uLogic;
  signal accumulator1, lowpassOutput1: real := 0.0;
  signal accumulator2, lowpassOutput2: real := 0.0;

BEGIN
  ------------------------------------------------------------------------------
                                                               -- remove overlap
  pwm1 <= '1' when switch1High = '1'
    else '0' when switch1Low = '1';
  pwm2 <= '1' when switch2High = '1'
    else '0' when switch2Low = '1';

  ------------------------------------------------------------------------------
                                                                      -- lowpass
  integrators: process
  begin
    wait for samplingPeriod;
    if pwm1 = '1' then
      accumulator1 <= accumulator1 - lowpassOutput1 + 1.0;
    else
      accumulator1 <= accumulator1 - lowpassOutput1;
    end if;
    if pwm2 = '1' then
      accumulator2 <= accumulator2 - lowpassOutput2 + 1.0;
    else
      accumulator2 <= accumulator2 - lowpassOutput2;
    end if;
  end process integrators;

  lowpassOutput1 <= accumulator1 / 2.0**lowpassShift;
  lowpass1 <= supplyVoltage * lowpassOutput1;
  lowpassOutput2 <= accumulator2 / 2.0**lowpassShift;
  lowpass2 <= supplyVoltage * lowpassOutput2;
  lowpassDiff <= supplyVoltage * (lowpassOutput1 - lowpassOutput2);

END ARCHITECTURE sim;
