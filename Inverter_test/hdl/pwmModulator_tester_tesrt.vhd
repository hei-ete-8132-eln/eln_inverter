LIBRARY ieee;
  USE ieee.math_real.all;

ARCHITECTURE tesrt OF pwmModulator_tester IS
                                                            -- clock and enables
  constant clockPeriod: time := 1.0/clockFrequency * 1 sec;
  signal sClock: std_uLogic := '1';
  constant pwmCountPeriod: time := 1.0/pwmCountFrequency * 1 sec;
  signal pwmCountEn_int: std_uLogic := '1';
                                                                 -- time signals
  constant outAmplitude: real := 0.95;
  signal tReal: real := 0.0;
  signal outReal: real := 0.0;
                                                          -- outputs for display
  signal pwm: integer;
  signal pwmFiltered: real := 0.0;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- clock and reset
  reset <= '1', '0' after 4*clockPeriod;

  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after 9.0/10.0 * clockPeriod;

  ------------------------------------------------------------------------------
                                                             -- PWM count enable
  pwmCountEn_int <= '1' after pwmCountPeriod-clockPeriod when pwmCountEn_int = '0'
    else '0' after clockPeriod;
  pwmCountEn <= pwmCountEn_int;

  ------------------------------------------------------------------------------
                                                                     -- controls
  threeLevel <= '0', '1' after 40 ms;

  switchEvenOdd <= '0', '1' after 80 ms;

  doubleFrequency <= '0', '1' after 120 ms;

  ------------------------------------------------------------------------------
                                                                  -- time signal
  process(sClock)
  begin
    if rising_edge(sClock) then
      tReal <= tReal + (1.0/clockFrequency);
    end if;
  end process;

  outReal <= outAmplitude * sin(2.0*math_pi*mainsFrequency*tReal);

  amplitude <= to_signed(
    integer( outReal/2.0 * real(2**amplitude'length-1)),
    amplitude'length
  );

  ------------------------------------------------------------------------------
                                                          -- outputs for display
  pwm <= 1 when (pwm1 = '1') and (pwm2 = '0')
    else -1 when (pwm1 = '0') and (pwm2 = '1')
    else 0;

  pwmFiltered <= lowpass1 - lowpass2;

END ARCHITECTURE tesrt;
