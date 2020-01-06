ARCHITECTURE sim OF sigmaDeltaModulator IS

  constant samplingPeriod: time := 1.0/modulationFrequency * 1 sec;
  constant a1 : real := 0.3;
  constant a2 : real := 0.7;
  constant c1 : real := 2.0;
  constant c2 : real := 1.0;
  signal vIn: real;
  signal accumulator1, accumulator2: real := 0.0;
  signal forwardSum, quantized: real := 1.0;

BEGIN
  ------------------------------------------------------------------------------
                                                   -- differential input voltage
  vin <= vInP - vInN;

  ------------------------------------------------------------------------------
                                                                      -- lowpass
  integrators: process
  begin
    wait for samplingPeriod;
    accumulator1 <= accumulator1 + a1 * (vIn - vRef*quantized);
    accumulator2 <= accumulator2 + a2 * accumulator1;
  end process integrators;

  forwardSum <= vIn + c1*accumulator1 + c2*accumulator2;
  quantized <= 1.0 when forwardSum > 0.0 else -1.0;
  dOut <= '1' when quantized > 0.0 else '0';

END ARCHITECTURE sim;
