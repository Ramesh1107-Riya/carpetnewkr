*select * from wistock where colour='NATURAL' .OR. colour='WHITE' .OR. colour='UNDYED' INTO TABLE wistock2
*select * from wistock where quality='100TBMCHS' .and. colour='011-01' 
select * from wistock where colour='NATURAL' .OR. colour='WHITE' .OR. colour='UNDYED';
union all;
select * from wistock where quality='100TBMCHS' .and. (colour='011-01' .or. colour='004-01' .or. colour='012-01' .or. colour='008-02' .or. colour='003-01' .or. colour='YARN-MIX' .or. colour='NH10-01' .or. colour='005-01' .or. colour='007-01');
union all;
select * from wistock where quality='60TBMCHS' .and. (colour='LIG+GRY' .or. colour='3+R8+P1+Q3');
union all;
select * from wistock where quality='80TBMCHS' .and. (colour='005-01' .or. colour='003-01' .or. colour='007-01' .or. colour='4+T10+V3Z2');
union all;
select * from wistock where quality='100TBMC' .and. (colour='478-01');
union all;
select * from wistock where quality='60TBHC' .and. (colour='GR3');
union all;
select * from wistock where quality='50TBHC' .and. (colour='478-01')