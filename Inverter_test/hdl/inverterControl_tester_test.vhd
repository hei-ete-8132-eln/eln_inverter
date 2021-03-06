ARCHITECTURE test OF inverterControl_tester IS
                                                            -- clock and enables
  constant clockPeriod: time := 1.0/clockFrequency * 1 sec;
  signal sClock: std_uLogic := '1';
  constant mainsPeriod: time := 1.0/mainsFrequency * 1 sec;
  signal sMains: std_uLogic := '1';
  signal mainsDelayed: std_uLogic := '0';
                                                                     -- controls
  constant modePeriod: time := 2*mainsPeriod;
  signal threeLevel_int: std_uLogic;
                                                                      -- lowpass
  constant lowpassShift: positive := 12;
  signal pwm1, pwm2: std_uLogic;
  signal pwm: integer;
                                                           -- period measurement
  signal lastTriggerRisingEdge : time := 0 sec;
  signal measuredPeriod : time := mainsPeriod;
  signal measuredFrequency : real := mainsFrequency;
                                                      -- non-overlap measurement
  signal lastPwmHighFallingEdge : time := 0 sec;
  signal lastPwmLowFallingEdge : time := 0 sec;
  signal measuredDeadTime : time := nonOverlapPeriod;
  signal measuredDeadTimeNs : positive := nonOverlapPeriod / 1 ns;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- clock and reset
  reset <= '1', '0' after 4*clockPeriod;

  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after 9.0/10.0 * clockPeriod;

  sMains <= not sMains after mainsPeriod/2;
  mainsDelayed <= transport sMains after 1.0/8.0 * mainsPeriod;
  mainsTriggered <= mainsDelayed;

  ------------------------------------------------------------------------------
                                                                     -- controls
  threeLevel_int <= '0', '1' after modePeriod;
  threeLevel <= threeLevel_int;

  switchEvenOdd <= '0', '1' after 2*modePeriod;

  doubleFrequency <= '0', '1' after 3*modePeriod;

  ------------------------------------------------------------------------------
                                                         -- power supply control
  controlSupplyVoltage: process
  begin
    supplyVoltage <= 12.0;

    wait;
  end process controlSupplyVoltage;


  ------------------------------------------------------------------------------
                                                              -- sampling enable
  sampleEn <= '1';
                                                             -- PWM count enable
  pwmCountEn <= '1';

  ------------------------------------------------------------------------------
                                                                  -- PWM signals
  pwm1 <= '1' when pwm1High = '1'
    else '0' when pwm1Low_n = '1';

  pwm2 <= '1' when pwm2High = '1'
    else '0' when pwm2Low_n = '1';

  pwm <= 1 when (pwm1 = '1') and (pwm2 = '0')
    else -1 when (pwm1 = '0') and (pwm2 = '1')
    else 0;

  ------------------------------------------------------------------------------
                                                           -- period measurement
  updatePeriodMeasurement: process(trigger)
  begin
    if rising_edge(trigger) then
      measuredPeriod <= now - lastTriggerRisingEdge;
      lastTriggerRisingEdge <= now;
    end if;
  end process updatePeriodMeasurement;

  measuredFrequency <= 1.0 / ( real(measuredPeriod / 1 ns) * 1.0E-9 );

  ------------------------------------------------------------------------------
                                                        -- dead time measurement
  updateDeadTimeMeasurement: process(pwm1High, pwm1Low_n)
  begin
    if falling_edge(pwm1High) then
      lastPwmHighFallingEdge <= now;
    end if;
    if falling_edge(pwm1Low_n) then
      lastPwmLowFallingEdge <= now;
    end if;
    if rising_edge(pwm1High) then
      measuredDeadTime <= now - lastPwmLowFallingEdge;
    end if;
    if rising_edge(pwm1Low_n) then
      measuredDeadTime <= now - lastPwmHighFallingEdge;
    end if;
  end process updateDeadTimeMeasurement;

  measuredDeadTimeNs <= measuredDeadTime / 1 ns;

END ARCHITECTURE test;
