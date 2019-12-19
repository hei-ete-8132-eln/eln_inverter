ARCHITECTURE sim OF pwmLowpass IS

  constant samplingPeriod: time := 1.0/samplingFrequency * 1 sec;
  signal accumulator, lowpassOutput: real := 0.0;

BEGIN

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
