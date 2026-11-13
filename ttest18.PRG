SELECT s_inv_no,s_inv_date,o_run_num,O_cust_num,o_desg_no,o_base_no,o_size_1,o_size_2,s_size_cm1,s_size_cm2;
FROM ordrsold;
WHERE s_inv_date>={^2018/01/01} .and. s_inv_date<={^2018/12/31} .and. o_size_1=267 .and. o_size_2=351;
Order by s_inv_date;
Into table sold01

SELECT s_inv_no,s_inv_date,o_run_num,O_cust_num,o_desg_no,o_base_no,o_size_1,o_size_2,s_size_cm1,s_size_cm2;
FROM ordrsold;
WHERE s_inv_date>={^2018/01/01} .and. s_inv_date<={^2018/12/31} .and. o_size_1=267 .and. o_size_2=351;
HAVING S_size_CM1<267 .OR. S_size_CM2<351;
Order by s_inv_date;
into table sold02


SELECT s_inv_no,s_inv_date,o_run_num,O_cust_num,o_desg_no,o_base_no,o_size_1,o_size_2,s_size_cm1,s_size_cm2,o_size_1-s_size_cm1 as size1,o_size_2-s_size_cm2 as size2;
FROM ordrsold;
WHERE s_inv_date>={^2018/01/01} .and. s_inv_date<={^2018/12/31} .and. o_size_1=267 .and. o_size_2=351;
Order by s_inv_date;
Into table sold03
