ARCHITECTURE sim OF pwmNonOverlapLowpass IS

  constant samplingPeriod: time := 1.0/clockFrequency * 1 sec;
  signal pwm: std_uLogic;
  signal accumulator, lowpassOutput: real := 0.0;

BEGIN
  ------------------------------------------------------------------------------
                                                               -- remove overlap
  pwm <= '1' when pwmHigh = '1'
    else '0' when pwmLow = '1';

  ------------------------------------------------------------------------------
                                                                      -- lowpass
  integrator: process
  begin
    wait for samplingPeriod;
    if pwm = '1' then
      accumulator <= accumulator - lowpassOutput + 1.0;
    else
      accumulator <= accumulator - lowpassOutput - 1.0;
    end if;
  end process integrator;

  lowpassOutput <= accumulator / 2.0**lowpassShift;
  lowpassOut <= lowpassOutput;

END ARCHITECTURE sim;
