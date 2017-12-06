main: (
  REF INT count = LOC INT := 0;
  REF[]INT jumps = LOC[1:1092]INT;

  # Read input #
  PROC raise logical file end = (REF FILE f) BOOL: ( except logical file end );
  on logical file end(stand in, raise logical file end);
  DO
    INT number;
    # Read line into line #
    read((number, new line));
    # Store integer #
    count +:= 1;
    jumps[count] := number
  OD;
  except logical file end:
    SKIP;

  (
    REF INT pc = LOC INT := 1;
    REF INT steps = LOC INT := 0;

    WHILE pc >= 1 & pc <= count DO
      # print((pc, new line)); #
      INT dest = pc + jumps[pc];
      IF jumps[pc] >= 3 THEN
        jumps[pc] -:= 1
      ELSE
        jumps[pc] +:= 1
      FI;
      pc := dest;
      steps +:= 1
    OD;

    # Print output #
    print((steps, new line))
  )
)
